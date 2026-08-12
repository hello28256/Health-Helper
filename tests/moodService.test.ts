// MoodService 单元测试

import { MoodService, VALID_MOODS } from '../src/services/moodService';
import { ValidationError } from '../src/utils/errors';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
function createPrismaMock() {
  const moodRecords: any[] = [];

  return {
    moodRecord: {
      create: async ({ data }: any) => {
        const rec = {
          id: `mood_${moodRecords.length + 1}`,
          ...data,
        };
        moodRecords.push(rec);
        return rec;
      },
      findMany: async ({ where, orderBy }: any) => {
        let rows = moodRecords.filter((r) => r.userId === where.userId);
        if (where.recordedAt?.gte) {
          const from = where.recordedAt.gte;
          rows = rows.filter((r) => r.recordedAt >= from);
        }
        if (where.recordedAt?.lte) {
          const to = where.recordedAt.lte;
          rows = rows.filter((r) => r.recordedAt <= to);
        }
        if (orderBy?.recordedAt === 'desc') rows.sort((a, b) => r_sort(a, b, 'recordedAt'));
        return rows;
      },
    },
    __moodRecords: moodRecords,
  };
}

function r_sort(a: any, b: any, field: string): number {
  return b[field].getTime() - a[field].getTime();
}

describe('MoodService.record', () => {
  it('creates a mood record with score', async () => {
    const prisma = createPrismaMock();
    const svc = new MoodService(prisma as any);

    const rec = await svc.record({
      userId: 'u1',
      mood: 'happy',
      score: 8,
      note: '今天项目上线了',
      recordedAt: new Date('2026-08-12T10:00:00Z'),
    });

    expect(rec.mood).toBe('happy');
    expect(rec.score).toBe(8);
    expect(rec.note).toBe('今天项目上线了');
  });

  it('creates a record without score and note', async () => {
    const prisma = createPrismaMock();
    const svc = new MoodService(prisma as any);

    const rec = await svc.record({
      userId: 'u1',
      mood: 'calm',
      recordedAt: new Date(),
    });

    expect(rec.mood).toBe('calm');
    expect(rec.score).toBeNull();
    expect(rec.note).toBeNull();
  });

  it('rejects invalid mood', async () => {
    const prisma = createPrismaMock();
    const svc = new MoodService(prisma as any);

    await expect(
      svc.record({
        userId: 'u1',
        mood: 'ecstatic' as any,
        recordedAt: new Date(),
      }),
    ).rejects.toBeInstanceOf(ValidationError);
  });

  it('rejects score out of 1-10 range', async () => {
    const prisma = createPrismaMock();
    const svc = new MoodService(prisma as any);

    await expect(
      svc.record({ userId: 'u1', mood: 'happy', score: 11, recordedAt: new Date() }),
    ).rejects.toBeInstanceOf(ValidationError);

    await expect(
      svc.record({ userId: 'u1', mood: 'happy', score: 0, recordedAt: new Date() }),
    ).rejects.toBeInstanceOf(ValidationError);
  });

  it('exposes valid mood list', () => {
    expect(VALID_MOODS).toContain('happy');
    expect(VALID_MOODS).toContain('anxious');
    expect(VALID_MOODS.length).toBeGreaterThanOrEqual(6);
  });
});

describe('MoodService.list', () => {
  it('returns records in range, newest first', async () => {
    const prisma = createPrismaMock();
    const svc = new MoodService(prisma as any);

    await svc.record({ userId: 'u1', mood: 'happy', recordedAt: new Date('2026-08-10T10:00:00Z') });
    await svc.record({ userId: 'u1', mood: 'calm', recordedAt: new Date('2026-08-12T10:00:00Z') });
    await svc.record({ userId: 'u1', mood: 'anxious', recordedAt: new Date('2026-08-11T10:00:00Z') });

    const list = await svc.list({
      userId: 'u1',
      from: new Date('2026-08-10T00:00:00Z'),
      to: new Date('2026-08-12T23:59:59Z'),
    });

    expect(list).toHaveLength(3);
    expect(list[0].mood).toBe('calm');
    expect(list[2].mood).toBe('happy');
  });

  it('does not leak other users records', async () => {
    const prisma = createPrismaMock();
    const svc = new MoodService(prisma as any);

    await svc.record({ userId: 'u1', mood: 'happy', recordedAt: new Date() });
    await svc.record({ userId: 'u2', mood: 'sad', recordedAt: new Date() });

    const list = await svc.list({ userId: 'u1' });
    expect(list).toHaveLength(1);
    expect(list[0].mood).toBe('happy');
  });
});

describe('MoodService.trend', () => {
  it('aggregates average score by day', async () => {
    const prisma = createPrismaMock();
    const svc = new MoodService(prisma as any);

    // 2026-08-10 两条记录：score=6, score=8 → avg 7
    await svc.record({
      userId: 'u1',
      mood: 'calm',
      score: 6,
      recordedAt: new Date('2026-08-10T09:00:00Z'),
    });
    await svc.record({
      userId: 'u1',
      mood: 'happy',
      score: 8,
      recordedAt: new Date('2026-08-10T18:00:00Z'),
    });
    // 2026-08-11 一条：score=4
    await svc.record({
      userId: 'u1',
      mood: 'anxious',
      score: 4,
      recordedAt: new Date('2026-08-11T10:00:00Z'),
    });

    const trend = await svc.trend({
      userId: 'u1',
      from: new Date('2026-08-10T00:00:00Z'),
      to: new Date('2026-08-11T23:59:59Z'),
    });

    expect(trend).toHaveLength(2);
    const day10 = trend.find((t) => t.date === '2026-08-10');
    const day11 = trend.find((t) => t.date === '2026-08-11');
    expect(day10?.avgScore).toBe(7);
    expect(day10?.recordCount).toBe(2);
    expect(day10?.dominantMood).toBe('calm'); // 第一条优先（按 recordedAt 顺序），或并列按某种规则
    expect(day11?.avgScore).toBe(4);
    expect(day11?.recordCount).toBe(1);
  });

  it('handles records without score', async () => {
    const prisma = createPrismaMock();
    const svc = new MoodService(prisma as any);

    await svc.record({ userId: 'u1', mood: 'happy', recordedAt: new Date('2026-08-10T10:00:00Z') });

    const trend = await svc.trend({
      userId: 'u1',
      from: new Date('2026-08-10T00:00:00Z'),
      to: new Date('2026-08-10T23:59:59Z'),
    });

    expect(trend[0].avgScore).toBeNull();
    expect(trend[0].recordCount).toBe(1);
    expect(trend[0].dominantMood).toBe('happy');
  });
});
