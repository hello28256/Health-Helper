// DietService 单元测试

import { DietService } from '../src/services/dietService';
import { NotFoundError } from '../src/utils/errors';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
function createPrismaMock() {
  const foods = new Map<string, any>(); // key = id
  const dietRecords: any[] = [];

  return {
    foodNutrient: {
      findMany: async ({ where, take, skip }: any) => {
        let rows = [...foods.values()];
        if (where?.OR) {
          const q = where.OR[0]?.nameZh?.contains || where.OR[0]?.name?.contains || '';
          rows = rows.filter(
            (f) =>
              (f.nameZh && f.nameZh.includes(q)) ||
              (f.name && f.name.toLowerCase().includes(q.toLowerCase())),
          );
        }
        if (where?.category) {
          rows = rows.filter((f) => f.category === where.category);
        }
        if (skip) rows = rows.slice(skip);
        if (take) rows = rows.slice(0, take);
        return rows;
      },
      findUnique: async ({ where }: any) => foods.get(String(where.id)) ?? null,
    },
    dietRecord: {
      create: async ({ data }: any) => {
        const food = foods.get(String(data.foodId));
        if (!food) throw new Error('Foreign key violation');
        const rec = {
          id: `dr_${dietRecords.length + 1}`,
          ...data,
          food,
          createdAt: new Date(),
        };
        dietRecords.push(rec);
        return rec;
      },
      findMany: async ({ where }: any) => {
        let rows = dietRecords.filter((r) => r.userId === where.userId);
        if (where.consumedAt?.gte) rows = rows.filter((r) => r.consumedAt >= where.consumedAt.gte);
        if (where.consumedAt?.lte) rows = rows.filter((r) => r.consumedAt <= where.consumedAt.lte);
        return rows;
      },
    },
    __foods: foods,
    __dietRecords: dietRecords,
  };
}

function seedFoods(prisma: ReturnType<typeof createPrismaMock>) {
  prisma.__foods.set('1', {
    id: '1',
    name: 'Chicken breast, cooked',
    nameZh: '鸡胸肉（熟）',
    category: '肉类',
    servingSizeG: 100,
    kcalPer100g: 165,
    proteinG: 31,
    fatG: 3.6,
    carbsG: 0,
    fiberG: 0,
    sodiumMg: 74,
  });
  prisma.__foods.set('2', {
    id: '2',
    name: 'Rice, white, cooked',
    nameZh: '米饭（白米，熟）',
    category: '主食',
    servingSizeG: 100,
    kcalPer100g: 130,
    proteinG: 2.7,
    fatG: 0.3,
    carbsG: 28.2,
    fiberG: 0.4,
    sodiumMg: 1,
  });
  prisma.__foods.set('3', {
    id: '3',
    name: 'Broccoli, raw',
    nameZh: '西兰花',
    category: '蔬菜',
    servingSizeG: 100,
    kcalPer100g: 34,
    proteinG: 2.8,
    fatG: 0.4,
    carbsG: 7,
    fiberG: 2.6,
    sodiumMg: 33,
  });
}

describe('DietService.searchFoods', () => {
  it('finds foods by Chinese name contains', async () => {
    const prisma = createPrismaMock();
    seedFoods(prisma);
    const svc = new DietService(prisma as any);

    const hits = await svc.searchFoods({ q: '鸡' });
    expect(hits.length).toBe(1);
    expect(hits[0].nameZh).toBe('鸡胸肉（熟）');
  });

  it('finds foods by English name (case-insensitive)', async () => {
    const prisma = createPrismaMock();
    seedFoods(prisma);
    const svc = new DietService(prisma as any);

    const hits = await svc.searchFoods({ q: 'rice' });
    expect(hits.length).toBe(1);
    expect(hits[0].name).toBe('Rice, white, cooked');
  });

  it('filters by category', async () => {
    const prisma = createPrismaMock();
    seedFoods(prisma);
    const svc = new DietService(prisma as any);

    const hits = await svc.searchFoods({ category: '蔬菜' });
    expect(hits.length).toBe(1);
    expect(hits[0].category).toBe('蔬菜');
  });

  it('respects limit and offset', async () => {
    const prisma = createPrismaMock();
    seedFoods(prisma);
    const svc = new DietService(prisma as any);

    const page1 = await svc.searchFoods({ limit: 2, offset: 0 });
    expect(page1.length).toBe(2);

    const page2 = await svc.searchFoods({ limit: 2, offset: 2 });
    expect(page2.length).toBe(1);
  });
});

describe('DietService.recordDiet', () => {
  it('creates a diet record linked to food', async () => {
    const prisma = createPrismaMock();
    seedFoods(prisma);
    const svc = new DietService(prisma as any);

    const rec = await svc.recordDiet({
      userId: 'u1',
      foodId: 1,
      mealType: 'lunch',
      consumedAt: new Date('2026-08-12T12:00:00Z'),
      servings: 1.5, // 150g 鸡胸肉
    });

    expect(rec.foodId).toBe(1);
    expect(rec.servings).toBe(1.5);
    expect(rec.mealType).toBe('lunch');
  });

  it('throws NotFoundError when food does not exist', async () => {
    const prisma = createPrismaMock();
    const svc = new DietService(prisma as any);

    await expect(
      svc.recordDiet({
        userId: 'u1',
        foodId: 999,
        mealType: 'lunch',
        consumedAt: new Date(),
        servings: 1,
      }),
    ).rejects.toBeInstanceOf(NotFoundError);
  });
});

describe('DietService.summary', () => {
  it('aggregates nutrition by day across meals', async () => {
    const prisma = createPrismaMock();
    seedFoods(prisma);
    const svc = new DietService(prisma as any);

    // 早餐：100g 米饭 → 130 kcal, 2.7P, 0.3F, 28.2C
    await svc.recordDiet({
      userId: 'u1',
      foodId: 2,
      mealType: 'breakfast',
      consumedAt: new Date('2026-08-12T08:00:00Z'),
      servings: 1,
    });

    // 午餐：200g 鸡胸 → 330 kcal, 62P, 7.2F
    await svc.recordDiet({
      userId: 'u1',
      foodId: 1,
      mealType: 'lunch',
      consumedAt: new Date('2026-08-12T12:00:00Z'),
      servings: 2,
    });

    // 晚餐：300g 西兰花 → 102 kcal, 8.4P, 1.2F, 21C
    await svc.recordDiet({
      userId: 'u1',
      foodId: 3,
      mealType: 'dinner',
      consumedAt: new Date('2026-08-12T18:00:00Z'),
      servings: 3,
    });

    // 另一天的不算
    await svc.recordDiet({
      userId: 'u1',
      foodId: 1,
      mealType: 'lunch',
      consumedAt: new Date('2026-08-11T12:00:00Z'),
      servings: 1,
    });

    const summary = await svc.summary('u1', new Date('2026-08-12T00:00:00Z'));

    // 总卡：130 + 330 + 102 = 562
    expect(summary.kcal).toBeCloseTo(562, 0);
    // 蛋白：2.7 + 62 + 8.4 = 73.1
    expect(summary.proteinG).toBeCloseTo(73.1, 1);
    // 脂肪：0.3 + 7.2 + 1.2 = 8.7
    expect(summary.fatG).toBeCloseTo(8.7, 1);
    // 碳水：28.2 + 0 + 21 = 49.2
    expect(summary.carbsG).toBeCloseTo(49.2, 1);
    expect(summary.recordCount).toBe(3);
  });

  it('returns zero summary when no records for the day', async () => {
    const prisma = createPrismaMock();
    const svc = new DietService(prisma as any);

    const summary = await svc.summary('u1', new Date('2026-08-12T00:00:00Z'));
    expect(summary.kcal).toBe(0);
    expect(summary.recordCount).toBe(0);
  });
});
