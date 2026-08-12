import { prisma } from '../models/prisma';
import { NotFoundError, ValidationError } from '../utils/errors';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type PrismaLike = any;

export interface FoodDto {
  id: number;
  name: string;
  nameZh: string | null;
  category: string | null;
  servingSizeG: number | null;
  kcalPer100g: number | null;
  proteinG: number | null;
  fatG: number | null;
  carbsG: number | null;
  fiberG: number | null;
  sodiumMg: number | null;
}

export interface SearchFoodsInput {
  q?: string;
  category?: string;
  limit?: number;
  offset?: number;
}

export interface RecordDietInput {
  userId: string;
  foodId: number;
  mealType: 'breakfast' | 'lunch' | 'dinner' | 'snack';
  consumedAt: Date;
  servings: number;
}

export interface DietRecordDto {
  id: string;
  userId: string;
  foodId: number;
  mealType: string;
  consumedAt: Date;
  servings: number;
  food: FoodDto;
  // 服务端计算的实际摄入（基于 servings × 每 100g 营养）
  consumed: {
    kcal: number;
    proteinG: number;
    fatG: number;
    carbsG: number;
    fiberG: number;
    sodiumMg: number;
  };
}

export interface DailyNutritionSummary {
  date: string; // YYYY-MM-DD
  kcal: number;
  proteinG: number;
  fatG: number;
  carbsG: number;
  fiberG: number;
  sodiumMg: number;
  recordCount: number;
  byMeal: Record<string, { kcal: number; recordCount: number }>;
}

const MEAL_TYPES = ['breakfast', 'lunch', 'dinner', 'snack'] as const;

/**
 * DietService —— 饮食记录业务逻辑
 *
 * 设计要点：
 * - 营养数据是只读参考库（food_nutrients 表），由种子或数据导入维护
 * - 用户只引用 foodId，份数（servings = 多少份 servingSizeG）由用户输入
 * - 实际摄入 = servings × servingSizeG/100 × 每 100g 营养
 */
export class DietService {
  constructor(private readonly prisma: PrismaLike) {}

  async searchFoods(input: SearchFoodsInput): Promise<FoodDto[]> {
    const where: any = {};

    if (input.q) {
      where.OR = [
        { nameZh: { contains: input.q } },
        { name: { contains: input.q } },
      ];
    }
    if (input.category) {
      where.category = input.category;
    }

    const rows = await this.prisma.foodNutrient.findMany({
      where,
      take: input.limit ?? 20,
      skip: input.offset ?? 0,
      orderBy: { id: 'asc' },
    });

    return rows.map((f: any) => this.toFoodDto(f));
  }

  async getFood(foodId: number): Promise<FoodDto> {
    const f = await this.prisma.foodNutrient.findUnique({ where: { id: foodId } });
    if (!f) throw new NotFoundError('Food');
    return this.toFoodDto(f);
  }

  async recordDiet(input: RecordDietInput): Promise<DietRecordDto> {
    if (input.servings <= 0) {
      throw new ValidationError('servings must be positive', { servings: input.servings });
    }
    if (!MEAL_TYPES.includes(input.mealType as typeof MEAL_TYPES[number])) {
      throw new ValidationError(`mealType must be one of: ${MEAL_TYPES.join(', ')}`);
    }

    const food = await this.prisma.foodNutrient.findUnique({ where: { id: input.foodId } });
    if (!food) throw new NotFoundError('Food');

    const rec = await this.prisma.dietRecord.create({
      data: {
        userId: input.userId,
        foodId: input.foodId,
        mealType: input.mealType,
        consumedAt: input.consumedAt,
        servings: input.servings,
      },
    });

    const consumed = this.computeConsumed(food, input.servings);

    return {
      id: rec.id,
      userId: rec.userId,
      foodId: Number(rec.foodId),
      mealType: rec.mealType,
      consumedAt: rec.consumedAt,
      servings: Number(rec.servings),
      food: this.toFoodDto(food),
      consumed,
    };
  }

  async summary(userId: string, day: Date): Promise<DailyNutritionSummary> {
    const dayStart = new Date(day);
    dayStart.setUTCHours(0, 0, 0, 0);
    const dayEnd = new Date(dayStart);
    dayEnd.setUTCDate(dayEnd.getUTCDate() + 1);

    const records = await this.prisma.dietRecord.findMany({
      where: {
        userId,
        consumedAt: { gte: dayStart, lt: dayEnd },
      },
    });

    // 关联 food —— 实际环境 prisma 支持 include，这里为简化手动查一次
    const foodIds = [...new Set(records.map((r: any) => Number(r.foodId)))];
    const foods = await Promise.all(foodIds.map((id) => this.prisma.foodNutrient.findUnique({ where: { id } })));
    const foodMap = new Map<number, any>();
    for (const f of foods) if (f) foodMap.set(Number(f.id), f);

    const summary: DailyNutritionSummary = {
      date: toDateKey(dayStart),
      kcal: 0,
      proteinG: 0,
      fatG: 0,
      carbsG: 0,
      fiberG: 0,
      sodiumMg: 0,
      recordCount: records.length,
      byMeal: {},
    };

    for (const r of records) {
      const food = foodMap.get(Number(r.foodId));
      if (!food) continue;
      const consumed = this.computeConsumed(food, Number(r.servings));

      summary.kcal += consumed.kcal;
      summary.proteinG += consumed.proteinG;
      summary.fatG += consumed.fatG;
      summary.carbsG += consumed.carbsG;
      summary.fiberG += consumed.fiberG;
      summary.sodiumMg += consumed.sodiumMg;

      if (!summary.byMeal[r.mealType]) {
        summary.byMeal[r.mealType] = { kcal: 0, recordCount: 0 };
      }
      summary.byMeal[r.mealType].kcal += consumed.kcal;
      summary.byMeal[r.mealType].recordCount += 1;
    }

    // 四舍五入到 2 位
    summary.kcal = Math.round(summary.kcal * 100) / 100;
    summary.proteinG = Math.round(summary.proteinG * 100) / 100;
    summary.fatG = Math.round(summary.fatG * 100) / 100;
    summary.carbsG = Math.round(summary.carbsG * 100) / 100;
    summary.fiberG = Math.round(summary.fiberG * 100) / 100;
    summary.sodiumMg = Math.round(summary.sodiumMg * 100) / 100;
    for (const meal of Object.values(summary.byMeal)) {
      meal.kcal = Math.round(meal.kcal * 100) / 100;
    }

    return summary;
  }

  async listRecords(input: { userId: string; from: Date; to: Date }): Promise<DietRecordDto[]> {
    const records = await this.prisma.dietRecord.findMany({
      where: {
        userId: input.userId,
        consumedAt: { gte: input.from, lte: input.to },
      },
      orderBy: { consumedAt: 'desc' },
    });
    const foodIds = [...new Set(records.map((r: any) => Number(r.foodId)))];
    const foods = await Promise.all(foodIds.map((id) => this.prisma.foodNutrient.findUnique({ where: { id } })));
    const foodMap = new Map<number, any>();
    for (const f of foods) if (f) foodMap.set(Number(f.id), f);

    return records.map((r: any) => {
      const food = foodMap.get(Number(r.foodId));
      return {
        id: r.id,
        userId: r.userId,
        foodId: Number(r.foodId),
        mealType: r.mealType,
        consumedAt: r.consumedAt,
        servings: Number(r.servings),
        food: food ? this.toFoodDto(food) : ({} as FoodDto),
        consumed: food ? this.computeConsumed(food, Number(r.servings)) : ({} as any),
      };
    });
  }

  // ===== private =====

  // eslint-disable-next-line class-methods-use-this
  private toFoodDto(f: any): FoodDto {
    return {
      id: Number(f.id),
      name: f.name,
      nameZh: f.nameZh ?? null,
      category: f.category ?? null,
      servingSizeG: f.servingSizeG ? Number(f.servingSizeG) : null,
      kcalPer100g: f.kcalPer100g ? Number(f.kcalPer100g) : null,
      proteinG: f.proteinG ? Number(f.proteinG) : null,
      fatG: f.fatG ? Number(f.fatG) : null,
      carbsG: f.carbsG ? Number(f.carbsG) : null,
      fiberG: f.fiberG ? Number(f.fiberG) : null,
      sodiumMg: f.sodiumMg ? Number(f.sodiumMg) : null,
    };
  }

  /**
   * 计算实际摄入：servings × servingSizeG/100 × per100g
   * servings = 1 时吃一份；servings = 1.5 时吃 1.5 份
   */
  // eslint-disable-next-line class-methods-use-this
  private computeConsumed(food: any, servings: number) {
    const servingG = food.servingSizeG ? Number(food.servingSizeG) : 100;
    const multiplier = (servings * servingG) / 100;

    const num = (v: any) => (v ? Number(v) : 0);

    return {
      kcal: Math.round(num(food.kcalPer100g) * multiplier * 100) / 100,
      proteinG: Math.round(num(food.proteinG) * multiplier * 100) / 100,
      fatG: Math.round(num(food.fatG) * multiplier * 100) / 100,
      carbsG: Math.round(num(food.carbsG) * multiplier * 100) / 100,
      fiberG: Math.round(num(food.fiberG) * multiplier * 100) / 100,
      sodiumMg: Math.round(num(food.sodiumMg) * multiplier * 100) / 100,
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

export function createDietService(): DietService {
  return new DietService(prisma);
}
