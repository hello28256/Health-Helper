import { prisma } from '../models/prisma';
import { NotFoundError, ValidationError } from '../utils/errors';
import { logger } from '../utils/logger';
import { calculateCalories, DEFAULT_BODY_WEIGHT_KG } from './calorie';
import type { PushService } from './pushService';
import type { DeviceService, DeviceTokenDto } from './deviceService';

/**
 * ExerciseService / StepService 可选依赖：注入 push 钩子用。
 * 不传则不触发推送（保持向后兼容）。
 */
export interface ServiceDeps {
  pushService?: PushService;
  deviceService?: DeviceService;
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type PrismaLike = any;

export interface CreateExerciseInput {
  userId: string;
  typeId: string;
  startedAt: Date;
  durationSec: number;
  distanceKm?: number;
  clientId?: string;
}

export interface ExerciseRecordDto {
  id: string;
  userId: string;
  typeId: string;
  startedAt: Date;
  durationSec: number;
  distanceKm: number | null;
  calories: number;
  createdAt: Date;
}

export interface ListExerciseInput {
  userId: string;
  from?: Date;
  to?: Date;
}

/**
 * ExerciseService —— 运动记录的业务逻辑
 *
 * 关键点：calories 由服务端按 MET 公式权威计算，客户端不传。
 * 这样可以保证数据不被篡改，且多个客户端（手机/Web）写入时的口径一致。
 */
export class ExerciseService {
  constructor(private readonly prisma: PrismaLike) {}

  async create(input: CreateExerciseInput): Promise<ExerciseRecordDto> {
    if (input.durationSec < 0) {
      throw new ValidationError('durationSec must be non-negative', { durationSec: input.durationSec });
    }

    const type = await this.prisma.exerciseType.findUnique({ where: { id: input.typeId } });
    if (!type) throw new NotFoundError('ExerciseType');

    const user = await this.prisma.user.findUnique({ where: { id: input.userId } });
    if (!user) throw new NotFoundError('User');

    const weightKg = user.weightKg ? Number(user.weightKg) : DEFAULT_BODY_WEIGHT_KG;
    const calories = calculateCalories({
      met: Number(type.met),
      weightKg,
      durationSec: input.durationSec,
    });

    const rec = await this.prisma.exerciseRecord.create({
      data: {
        userId: input.userId,
        typeId: input.typeId,
        startedAt: input.startedAt,
        durationSec: input.durationSec,
        distanceKm: input.distanceKm ?? null,
        calories,
        clientId: input.clientId ?? null,
      },
    });

    return this.toDto(rec);
  }

  async list(input: ListExerciseInput): Promise<ExerciseRecordDto[]> {
    const where: any = { userId: input.userId };
    if (input.from || input.to) {
      where.startedAt = {};
      if (input.from) where.startedAt.gte = input.from;
      if (input.to) where.startedAt.lte = input.to;
    }

    const rows = await this.prisma.exerciseRecord.findMany({
      where,
      orderBy: { startedAt: 'desc' },
    });

    return rows.map((r: any) => this.toDto(r));
  }

  async listTypes() {
    const types = await this.prisma.exerciseType.findMany({ orderBy: { id: 'asc' } });
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    return types.map((t: any) => ({
      id: t.id,
      displayNameZh: t.displayNameZh,
      displayNameEn: t.displayNameEn,
      met: Number(t.met),
      notes: t.notes,
    }));
  }

  // eslint-disable-next-line class-methods-use-this
  private toDto(r: any): ExerciseRecordDto {
    return {
      id: r.id,
      userId: r.userId,
      typeId: r.typeId,
      startedAt: r.startedAt,
      durationSec: r.durationSec,
      distanceKm: r.distanceKm ? Number(r.distanceKm) : null,
      calories: Number(r.calories),
      createdAt: r.createdAt,
    };
  }
}

// ===== Steps =====

export interface UpsertStepInput {
  userId: string;
  date: Date; // 取 YYYY-MM-DD 落库
  steps: number;
  source?: string;
}

export interface DailyStepDto {
  userId: string;
  date: string; // YYYY-MM-DD
  steps: number;
  source: string | null;
  updatedAt: Date;
}

/**
 * StepService —— 每日步数
 *
 * 策略：同一天多次上报取最大值（移动端 OS 有时会回退旧数据）。
 * 上报是 upsert，不需要去重。
 *
 * push 钩子：单日累计 ≥10000 时触发"步数达标庆祝"。
 */
export class StepService {
  private readonly pushService: PushService | undefined;

  private readonly deviceService: DeviceService | undefined;

  constructor(private readonly prisma: PrismaLike, deps: ServiceDeps = {}) {
    this.pushService = deps.pushService;
    this.deviceService = deps.deviceService;
  }

  async upsert(input: UpsertStepInput): Promise<DailyStepDto> {
    if (input.steps < 0) {
      throw new ValidationError('steps must be non-negative', { steps: input.steps });
    }

    // 先看当前值，取较大者（业务策略：避免回退）
    const existing = await this.prisma.dailyStep.findUnique({
      where: { userId_date: { userId: input.userId, date: input.date } },
    });
    const finalSteps =
      existing && Number(existing.steps) > input.steps ? Number(existing.steps) : input.steps;

    const row = await this.prisma.dailyStep.upsert({
      where: { userId_date: { userId: input.userId, date: input.date } },
      create: {
        userId: input.userId,
        date: input.date,
        steps: finalSteps,
        source: input.source ?? null,
      },
      update: {
        steps: finalSteps,
        source: input.source ?? null,
      },
    });

    // push 钩子：fire-and-forget，失败不阻塞主流程
    void this.maybePushStepGoal(input.userId, Number(row.steps)).catch((err) =>
      logger.warn('StepService push hook failed', { error: (err as Error).message }),
    );

    return {
      userId: row.userId,
      date: toDateKey(row.date),
      steps: Number(row.steps),
      source: row.source,
      updatedAt: row.updatedAt,
    };
  }

  /**
   * 步数达标钩子：单日累计 ≥10000 时触发推送。
   * 没装 push service 或 device service 时直接 no-op。
   */
  private async maybePushStepGoal(userId: string, steps: number): Promise<void> {
    if (!this.pushService || !this.deviceService) return;
    if (steps < 10_000) return;
    const tokens: DeviceTokenDto[] = await this.deviceService.listActive(userId);
    await this.pushService.notifyStepGoalHit({ userId, tokens, steps });
  }

  async today(userId: string, today: Date = new Date()): Promise<DailyStepDto> {
    const row = await this.prisma.dailyStep.findUnique({
      where: { userId_date: { userId, date: today } },
    });
    if (!row) {
      return {
        userId,
        date: toDateKey(today),
        steps: 0,
        source: null,
        updatedAt: today,
      };
    }
    return {
      userId: row.userId,
      date: toDateKey(row.date),
      steps: Number(row.steps),
      source: row.source,
      updatedAt: row.updatedAt,
    };
  }
}

// ===== Helpers =====

export function toDateKey(d: Date): string {
  const yyyy = d.getUTCFullYear();
  const mm = String(d.getUTCMonth() + 1).padStart(2, '0');
  const dd = String(d.getUTCDate()).padStart(2, '0');
  return `${yyyy}-${mm}-${dd}`;
}

// ===== Factory =====

export function createExerciseService(): ExerciseService {
  return new ExerciseService(prisma);
}

export function createStepService(deps?: ServiceDeps): StepService {
  return new StepService(prisma, deps);
}
