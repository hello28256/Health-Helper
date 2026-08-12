import { prisma } from '../models/prisma';
import { NotFoundError, ValidationError } from '../utils/errors';
import { calculateCalories, DEFAULT_BODY_WEIGHT_KG } from './calorie';

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
 */
export class StepService {
  constructor(private readonly prisma: PrismaLike) {}

  async upsert(input: UpsertStepInput): Promise<DailyStepDto> {
    if (input.steps < 0) {
      throw new ValidationError('steps must be non-negative', { steps: input.steps });
    }

    const dateKey = toDateKey(input.date);

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

    return {
      userId: row.userId,
      date: toDateKey(row.date),
      steps: Number(row.steps),
      source: row.source,
      updatedAt: row.updatedAt,
    };
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

export function createStepService(): StepService {
  return new StepService(prisma);
}
