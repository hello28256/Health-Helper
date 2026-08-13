import { prisma } from '../models/prisma';
import { ValidationError } from '../utils/errors';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type PrismaLike = any;

/**
 * 健康指标枚举 —— 跟 Prisma 的 HealthMetric 对齐。
 * 限制 8 种：步数（已走独立端点）、心率、睡眠、体重、血压、血糖、血氧、体温。
 * 扩展时同时改 Prisma schema 的 HealthMetric enum + openapi.ts 的 HealthMetric schema。
 */
export const HEALTH_METRICS = [
  'steps',
  'heart_rate',
  'sleep',
  'weight',
  'blood_pressure',
  'blood_glucose',
  'spo2',
  'body_temperature',
] as const;
export type HealthMetric = typeof HEALTH_METRICS[number];

export interface RecordHealthInput {
  userId: string;
  metric: HealthMetric;
  value: number;
  unit: string; // "bpm", "kg", "mmHg", "min", "mmol/L", "%", "°C"
  startAt: Date;
  endAt?: Date | null;
  source: string; // "ios_healthkit" | "android_health_connect" | "manual"
  raw?: unknown; // 平台原始 payload（可选）
}

export interface HealthRecordDto {
  id: string;
  userId: string;
  metric: string;
  value: number;
  unit: string;
  startAt: Date;
  endAt: Date | null;
  source: string;
  createdAt: Date;
}

export interface BatchRecordHealthInput {
  userId: string;
  records: Array<Omit<RecordHealthInput, 'userId'>>;
}

export interface ListHealthInput {
  userId: string;
  metric: HealthMetric;
  from: Date;
  to: Date;
}

export interface LatestHealthInput {
  userId: string;
  metric: HealthMetric;
}

const MAX_BATCH_SIZE = 500;

/**
 * HealthRecordsService —— 健康数据批量上报（HealthKit / Health Connect）
 *
 * 设计要点：
 * - **批量上报**：一次最多 500 条，节省移动端电量和网络
 * - **多用户严格隔离**：所有查询都带 userId
 * - **latest 单点**：移动端首页展示用，按 startAt desc 取 1 条
 * - **写入不查重**：同 metric + startAt 的数据可重复存（比如心率多次采样）；
 *   客户端要 dedup 自己保证（健康平台 API 已经聚合过）
 * - **不验 weightKg 等服务端权威值**：服务端不做解释，只做持久化。
 *   卡路里/营养摄入这类权威计算走 dedicated 端点（exercises / diet）。
 */
export class HealthRecordsService {
  constructor(private readonly prisma: PrismaLike) {}

  /**
   * 批量写入健康记录。
   * - 空数组 / 超 500 → 400
   * - 任一条 metric 不在白名单 → 400
   * - 任一条 endAt < startAt → 400
   */
  async record(input: BatchRecordHealthInput): Promise<HealthRecordDto[]> {
    if (!input.records || input.records.length === 0) {
      throw new ValidationError('records must not be empty', { count: 0 });
    }
    if (input.records.length > MAX_BATCH_SIZE) {
      throw new ValidationError(`records batch too large (max ${MAX_BATCH_SIZE})`, {
        count: input.records.length,
      });
    }

    for (const r of input.records) {
      if (!HEALTH_METRICS.includes(r.metric as HealthMetric)) {
        throw new ValidationError(
          `metric must be one of: ${HEALTH_METRICS.join(', ')}`,
          { metric: r.metric },
        );
      }
      if (r.endAt && r.endAt < r.startAt) {
        throw new ValidationError('endAt must be >= startAt', {
          metric: r.metric,
          startAt: r.startAt,
          endAt: r.endAt,
        });
      }
      if (!Number.isFinite(r.value)) {
        throw new ValidationError('value must be a finite number', { value: r.value });
      }
      if (!r.unit || r.unit.length > 16) {
        throw new ValidationError('unit must be 1..16 chars', { unit: r.unit });
      }
      if (!r.source || r.source.length > 64) {
        throw new ValidationError('source must be 1..64 chars', { source: r.source });
      }
    }

    const created = await Promise.all(
      input.records.map((r) =>
        this.prisma.healthRecord.create({
          data: {
            userId: input.userId,
            metric: r.metric,
            value: r.value,
            unit: r.unit,
            startAt: r.startAt,
            endAt: r.endAt ?? null,
            source: r.source,
            raw: (r.raw as any) ?? null,
          },
        }),
      ),
    );

    return created.map((row: any) => this.toDto(row));
  }

  /**
   * 按 metric + 时间范围查历史（趋势图用）。
   */
  async list(input: ListHealthInput): Promise<HealthRecordDto[]> {
    const rows = await this.prisma.healthRecord.findMany({
      where: {
        userId: input.userId,
        metric: input.metric,
        startAt: { gte: input.from, lte: input.to },
      },
      orderBy: { startAt: 'asc' },
    });
    return rows.map((r: any) => this.toDto(r));
  }

  /**
   * 取某 metric 最新一条（仪表盘摘要用）。
   */
  async latest(input: LatestHealthInput): Promise<HealthRecordDto | null> {
    const row = await this.prisma.healthRecord.findFirst({
      where: { userId: input.userId, metric: input.metric },
      orderBy: { startAt: 'desc' },
    });
    return row ? this.toDto(row) : null;
  }

  // eslint-disable-next-line class-methods-use-this
  private toDto(r: any): HealthRecordDto {
    return {
      id: r.id,
      userId: r.userId,
      metric: r.metric,
      value: Number(r.value),
      unit: r.unit,
      startAt: r.startAt,
      endAt: r.endAt ?? null,
      source: r.source,
      createdAt: r.createdAt,
    };
  }
}

// ===== Factory =====

export function createHealthRecordsService(): HealthRecordsService {
  return new HealthRecordsService(prisma);
}