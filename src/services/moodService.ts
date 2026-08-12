import { prisma } from '../models/prisma';
import { ValidationError } from '../utils/errors';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type PrismaLike = any;

export const VALID_MOODS = [
  'happy',
  'calm',
  'sad',
  'anxious',
  'angry',
  'tired',
  'grateful',
  'excited',
] as const;
export type Mood = typeof VALID_MOODS[number];

export interface RecordMoodInput {
  userId: string;
  mood: Mood;
  score?: number | null;
  note?: string | null;
  recordedAt: Date;
}

export interface MoodRecordDto {
  id: string;
  userId: string;
  mood: string;
  score: number | null;
  note: string | null;
  recordedAt: Date;
}

export interface ListMoodInput {
  userId: string;
  from?: Date;
  to?: Date;
}

export interface MoodTrendPoint {
  date: string; // YYYY-MM-DD
  avgScore: number | null;
  recordCount: number;
  dominantMood: string;
}

export interface TrendInput {
  userId: string;
  from: Date;
  to: Date;
}

/**
 * MoodService —— 心理健康 · 情绪记录
 *
 * 设计要点：
 * - mood 用固定枚举（前端可以本地化显示），保证统计口径一致
 * - score 是可选 1-10 自评分，趋势图用它
 * - 多用户数据严格隔离（按 userId 查询）
 * - trend 按日聚合：avg score + 出现最多的 mood
 */
export class MoodService {
  constructor(private readonly prisma: PrismaLike) {}

  async record(input: RecordMoodInput): Promise<MoodRecordDto> {
    if (!VALID_MOODS.includes(input.mood as Mood)) {
      throw new ValidationError(`mood must be one of: ${VALID_MOODS.join(', ')}`, { mood: input.mood });
    }
    if (input.score !== undefined && input.score !== null) {
      if (input.score < 1 || input.score > 10 || !Number.isInteger(input.score)) {
        throw new ValidationError('score must be an integer in [1, 10]', { score: input.score });
      }
    }
    if (input.note && input.note.length > 2000) {
      throw new ValidationError('note too long (max 2000 chars)', { length: input.note.length });
    }

    const rec = await this.prisma.moodRecord.create({
      data: {
        userId: input.userId,
        mood: input.mood,
        score: input.score ?? null,
        note: input.note ?? null,
        recordedAt: input.recordedAt,
      },
    });

    return this.toDto(rec);
  }

  async list(input: ListMoodInput): Promise<MoodRecordDto[]> {
    const where: any = { userId: input.userId };
    if (input.from || input.to) {
      where.recordedAt = {};
      if (input.from) where.recordedAt.gte = input.from;
      if (input.to) where.recordedAt.lte = input.to;
    }

    const rows = await this.prisma.moodRecord.findMany({
      where,
      orderBy: { recordedAt: 'desc' },
    });

    return rows.map((r: any) => this.toDto(r));
  }

  async trend(input: TrendInput): Promise<MoodTrendPoint[]> {
    const records = await this.prisma.moodRecord.findMany({
      where: {
        userId: input.userId,
        recordedAt: { gte: input.from, lte: input.to },
      },
      orderBy: { recordedAt: 'asc' },
    });

    const byDay = new Map<string, { scores: number[]; moods: string[] }>();
    for (const r of records) {
      const key = toDateKey(r.recordedAt);
      if (!byDay.has(key)) byDay.set(key, { scores: [], moods: [] });
      const bucket = byDay.get(key)!;
      if (r.score !== null && r.score !== undefined) bucket.scores.push(Number(r.score));
      bucket.moods.push(r.mood);
    }

    const points: MoodTrendPoint[] = [];
    for (const [date, bucket] of byDay.entries()) {
      const avgScore =
        bucket.scores.length > 0
          ? Math.round((bucket.scores.reduce((a, b) => a + b, 0) / bucket.scores.length) * 100) / 100
          : null;
      points.push({
        date,
        avgScore,
        recordCount: bucket.moods.length,
        dominantMood: dominantMood(bucket.moods),
      });
    }

    // 按日期升序
    points.sort((a, b) => (a.date < b.date ? -1 : a.date > b.date ? 1 : 0));
    return points;
  }

  // eslint-disable-next-line class-methods-use-this
  private toDto(r: any): MoodRecordDto {
    return {
      id: r.id,
      userId: r.userId,
      mood: r.mood,
      score: r.score !== null && r.score !== undefined ? Number(r.score) : null,
      note: r.note ?? null,
      recordedAt: r.recordedAt,
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

function dominantMood(moods: string[]): string {
  const counts = new Map<string, number>();
  for (const m of moods) counts.set(m, (counts.get(m) ?? 0) + 1);
  let best = moods[0];
  let bestCount = 0;
  for (const [m, c] of counts.entries()) {
    if (c > bestCount || (c === bestCount && moods.indexOf(m) < moods.indexOf(best))) {
      best = m;
      bestCount = c;
    }
  }
  return best;
}

// ===== Factory =====

export function createMoodService(): MoodService {
  return new MoodService(prisma);
}
