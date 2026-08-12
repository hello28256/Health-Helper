// ExerciseService + StepService 单元测试

import { ExerciseService, StepService } from '../src/services/exerciseService';
import { calculateCalories } from '../src/services/calorie';
import { NotFoundError } from '../src/utils/errors';

// ===== Prisma mock =====
// eslint-disable-next-line @typescript-eslint/no-explicit-any
function createPrismaMock() {
  const exerciseTypes = new Map<string, any>();
  const exerciseRecords: any[] = [];
  const dailySteps = new Map<string, any>(); // key = userId|date
  const users = new Map<string, any>();

  return {
    user: {
      findUnique: async ({ where }: any) => users.get(where.id) ?? null,
    },
    exerciseType: {
      findUnique: async ({ where }: any) => exerciseTypes.get(where.id) ?? null,
      findMany: async () => [...exerciseTypes.values()],
    },
    exerciseRecord: {
      create: async ({ data }: any) => {
        // 按 (userId, clientId) 去重
        const existing = exerciseRecords.find(
          (r) => r.userId === data.userId && r.clientId && r.clientId === data.clientId,
        );
        if (existing) return existing;

        const rec = {
          id: `rec_${exerciseRecords.length + 1}`,
          ...data,
          createdAt: new Date(),
        };
        exerciseRecords.push(rec);
        return rec;
      },
      findMany: async ({ where, orderBy }: any) => {
        let rows = exerciseRecords.filter((r) => r.userId === where.userId);
        if (where.startedAt?.gte) {
          const from = where.startedAt.gte;
          rows = rows.filter((r) => r.startedAt >= from);
        }
        if (where.startedAt?.lte) {
          const to = where.startedAt.lte;
          rows = rows.filter((r) => r.startedAt <= to);
        }
        if (orderBy?.startedAt === 'desc') rows.sort((a, b) => b.startedAt - a.startedAt);
        return rows;
      },
    },
    dailyStep: {
      upsert: async ({ where, create, update: _update }: any) => {
        const k = `${where.userId_date.userId}|${where.userId_date.date.toISOString().slice(0, 10)}`;
        const existing = dailySteps.get(k);
        if (existing) {
          // 取最大值（避免旧上报回退）
          if (create.steps > existing.steps) {
            existing.steps = create.steps;
            existing.source = create.source;
            existing.updatedAt = new Date();
          }
          return existing;
        }
        const row = {
          userId: create.userId,
          date: create.date,
          steps: create.steps,
          source: create.source ?? null,
          updatedAt: new Date(),
        };
        dailySteps.set(k, row);
        return row;
      },
      findUnique: async ({ where }: any) => {
        const k = `${where.userId_date.userId}|${where.userId_date.date.toISOString().slice(0, 10)}`;
        return dailySteps.get(k) ?? null;
      },
    },
    __exerciseTypes: exerciseTypes,
    __exerciseRecords: exerciseRecords,
    __users: users,
    __dailySteps: dailySteps,
  };
}

// ===== Fixtures =====

function seedExerciseTypes(prisma: ReturnType<typeof createPrismaMock>) {
  prisma.__exerciseTypes.set('running', {
    id: 'running',
    displayNameZh: '跑步',
    displayNameEn: 'Running',
    met: 9.8,
    notes: '注意热身，避免膝关节损伤。',
  });
  prisma.__exerciseTypes.set('walking', {
    id: 'walking',
    displayNameZh: '散步',
    displayNameEn: 'Walking',
    met: 3.5,
    notes: '饭后散步有助于消化。',
  });
}

function seedUser(prisma: ReturnType<typeof createPrismaMock>, id: string, weightKg = 70) {
  prisma.__users.set(id, { id, email: 'u@example.com', weightKg });
}

// ===== ExerciseService =====

describe('ExerciseService.create', () => {
  it('creates a record and server-side computes calories via MET formula', async () => {
    const prisma = createPrismaMock();
    seedExerciseTypes(prisma);
    seedUser(prisma, 'u1', 70);
    const svc = new ExerciseService(prisma as any);

    const rec = await svc.create({
      userId: 'u1',
      typeId: 'running',
      startedAt: new Date('2026-08-12T08:00:00Z'),
      durationSec: 1800, // 30 min
      // 注意：客户端不传 calories —— 服务端权威
    });

    // MET 9.8 × 70kg × 0.5h = 343
    expect(rec.calories).toBeCloseTo(343, 0);
    expect(rec.userId).toBe('u1');
  });

  it('throws NotFoundError when typeId does not exist', async () => {
    const prisma = createPrismaMock();
    seedUser(prisma, 'u1');
    const svc = new ExerciseService(prisma as any);

    await expect(
      svc.create({
        userId: 'u1',
        typeId: 'unknown',
        startedAt: new Date(),
        durationSec: 600,
      }),
    ).rejects.toBeInstanceOf(NotFoundError);
  });

  it('is idempotent by (userId, clientId)', async () => {
    const prisma = createPrismaMock();
    seedExerciseTypes(prisma);
    seedUser(prisma, 'u1');
    const svc = new ExerciseService(prisma as any);

    const input = {
      userId: 'u1',
      typeId: 'walking',
      startedAt: new Date(),
      durationSec: 600,
      clientId: 'mobile-uuid-1',
    };

    const r1 = await svc.create(input);
    const r2 = await svc.create(input);

    expect(r1.id).toBe(r2.id);
    expect(prisma.__exerciseRecords.length).toBe(1);
  });

  it('falls back to default weight when user has no weightKg set', async () => {
    const prisma = createPrismaMock();
    seedExerciseTypes(prisma);
    seedUser(prisma, 'u1', null as any); // no weight
    const svc = new ExerciseService(prisma as any);

    const rec = await svc.create({
      userId: 'u1',
      typeId: 'walking',
      startedAt: new Date(),
      durationSec: 3600, // 1h
    });

    // 3.5 × 65 (default) × 1 = 227.5
    expect(rec.calories).toBeCloseTo(227.5, 1);
  });
});

describe('ExerciseService.list', () => {
  it('returns records in date range, newest first', async () => {
    const prisma = createPrismaMock();
    seedExerciseTypes(prisma);
    seedUser(prisma, 'u1');
    const svc = new ExerciseService(prisma as any);

    await svc.create({
      userId: 'u1',
      typeId: 'walking',
      startedAt: new Date('2026-08-10T08:00:00Z'),
      durationSec: 600,
    });
    await svc.create({
      userId: 'u1',
      typeId: 'walking',
      startedAt: new Date('2026-08-12T08:00:00Z'),
      durationSec: 600,
    });
    await svc.create({
      userId: 'u1',
      typeId: 'walking',
      startedAt: new Date('2026-08-11T08:00:00Z'),
      durationSec: 600,
    });

    const list = await svc.list({
      userId: 'u1',
      from: new Date('2026-08-10T00:00:00Z'),
      to: new Date('2026-08-12T23:59:59Z'),
    });

    expect(list).toHaveLength(3);
    expect(list[0].startedAt.toISOString()).toBe('2026-08-12T08:00:00.000Z');
  });
});

// ===== StepService =====

describe('StepService.upsert', () => {
  it('creates a new daily step row', async () => {
    const prisma = createPrismaMock();
    seedUser(prisma, 'u1');
    const svc = new StepService(prisma as any);

    const row = await svc.upsert({
      userId: 'u1',
      date: new Date('2026-08-12T00:00:00Z'),
      steps: 8000,
      source: 'ios_pedometer',
    });

    expect(row.steps).toBe(8000);
  });

  it('takes the maximum when reported multiple times in a day', async () => {
    const prisma = createPrismaMock();
    seedUser(prisma, 'u1');
    const svc = new StepService(prisma as any);

    await svc.upsert({
      userId: 'u1',
      date: new Date('2026-08-12T00:00:00Z'),
      steps: 5000,
      source: 'ios_pedometer',
    });

    const row = await svc.upsert({
      userId: 'u1',
      date: new Date('2026-08-12T00:00:00Z'),
      steps: 3000,
      source: 'ios_pedometer',
    });

    expect(row.steps).toBe(5000); // 不回退
  });

  it('updates to larger value', async () => {
    const prisma = createPrismaMock();
    seedUser(prisma, 'u1');
    const svc = new StepService(prisma as any);

    await svc.upsert({
      userId: 'u1',
      date: new Date('2026-08-12T00:00:00Z'),
      steps: 5000,
      source: 'ios_pedometer',
    });
    const row = await svc.upsert({
      userId: 'u1',
      date: new Date('2026-08-12T00:00:00Z'),
      steps: 9000,
      source: 'ios_pedometer',
    });

    expect(row.steps).toBe(9000);
  });
});

describe('StepService.today', () => {
  it('returns steps for today, or 0 if none', async () => {
    const prisma = createPrismaMock();
    seedUser(prisma, 'u1');
    const svc = new StepService(prisma as any);

    const zero = await svc.today('u1', new Date('2026-08-12T00:00:00Z'));
    expect(zero.steps).toBe(0);
  });
});

// 避免 calculateCalories 未使用告警
it('sanity: calculateCalories sanity', () => {
  expect(calculateCalories({ met: 1, weightKg: 100, durationSec: 3600 })).toBe(100);
});
