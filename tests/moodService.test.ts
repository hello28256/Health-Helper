// MoodService 单元测试

import { MoodService, VALID_MOODS } from '../src/services/moodService';
import { ValidationError } from '../src/utils/errors';
import type { PushService } from '../src/services/pushService';
import type { DeviceService } from '../src/services/deviceService';

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

// ===== push 钩子测试 =====

describe('MoodService.record (push hook)', () => {
  it('triggers pushService.notifyMoodTrend when 7-day avg score < 4', async () => {
    const prisma = createPrismaMock();
    // 提前插入 6 条低分记录，让 record() 后第 7 天均分变 3.5
    const yesterday = new Date();
    yesterday.setUTCDate(yesterday.getUTCDate() - 1);
    for (let i = 0; i < 6; i++) {
      await prisma.moodRecord.create({
        data: {
          id: `seed_${i}`,
          userId: 'u1',
          mood: 'sad',
          score: 3,
          note: null,
          recordedAt: new Date(yesterday.getTime() - i * 86_400_000),
        },
      });
    }

    const push = {
      notifyMoodTrend: jest.fn().mockResolvedValue(undefined),
      shutdown: jest.fn(),
    } as unknown as PushService;
    const device = {
      listActive: jest.fn().mockResolvedValue([]),
    } as unknown as DeviceService;

    const svc = new MoodService(prisma as any, { pushService: push, deviceService: device });

    await svc.record({
      userId: 'u1',
      mood: 'sad',
      score: 4,
      recordedAt: new Date(),
    });

    // push 钩子是 fire-and-forget，等一拍让微任务执行
    await new Promise((resolve) => setImmediate(resolve));
    await Promise.resolve();
    await Promise.resolve();

    expect(push.notifyMoodTrend).toHaveBeenCalledTimes(1);
    const args = (push.notifyMoodTrend as jest.Mock).mock.calls[0][0];
    expect(args.userId).toBe('u1');
    expect(args.tokens).toEqual([]);
    expect(args.avgScore7d).toBeLessThan(4);
  });

  it('does not push when 7-day avg score >= 4', async () => {
    const prisma = createPrismaMock();
    const yesterday = new Date();
    yesterday.setUTCDate(yesterday.getUTCDate() - 1);
    for (let i = 0; i < 6; i++) {
      await prisma.moodRecord.create({
        data: {
          id: `seed_${i}`,
          userId: 'u1',
          mood: 'happy',
          score: 7,
          note: null,
          recordedAt: new Date(yesterday.getTime() - i * 86_400_000),
        },
      });
    }

    const push = { notifyMoodTrend: jest.fn() } as unknown as PushService;
    const device = { listActive: jest.fn().mockResolvedValue([]) } as unknown as DeviceService;
    const svc = new MoodService(prisma as any, { pushService: push, deviceService: device });

    await svc.record({
      userId: 'u1',
      mood: 'happy',
      score: 8,
      recordedAt: new Date(),
    });

    expect(push.notifyMoodTrend).not.toHaveBeenCalled();
  });

  it('works without push service (backward compatible)', async () => {
    const prisma = createPrismaMock();
    const svc = new MoodService(prisma as any); // 不传 push

    const rec = await svc.record({
      userId: 'u1',
      mood: 'sad',
      score: 2,
      recordedAt: new Date(),
    });

    expect(rec.mood).toBe('sad');
  });
});
