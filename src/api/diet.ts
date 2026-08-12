import { Router, Request, Response, NextFunction } from 'express';
import { z } from 'zod';

import { requireAuth } from './middlewares/auth';
import { validateBody, validateQuery } from './middlewares/validate';
import { UnauthorizedError } from '../utils/errors';
import { createDietService } from '../services/dietService';

const searchFoodsQuerySchema = z.object({
  q: z.string().min(1).max(64).optional(),
  category: z.string().min(1).max(32).optional(),
  limit: z.coerce.number().int().min(1).max(100).optional(),
  offset: z.coerce.number().int().min(0).optional(),
});

const recordDietSchema = z.object({
  foodId: z.coerce.number().int().positive(),
  mealType: z.enum(['breakfast', 'lunch', 'dinner', 'snack']),
  consumedAt: z.string().datetime().optional(),
  servings: z.coerce.number().positive().max(20),
});

const summaryQuerySchema = z.object({
  date: z.string().datetime().optional(),
});

const recordsQuerySchema = z.object({
  from: z.string().datetime(),
  to: z.string().datetime(),
});

export function buildDietRouter(): Router {
  const router = Router();
  const dietService = createDietService();

  router.use(requireAuth);

  // 搜索食物
  router.get('/foods', validateQuery(searchFoodsQuerySchema), async (req: Request, res: Response, next: NextFunction) => {
    try {
      const q = (req as any).validatedQuery ?? {};
      const foods = await dietService.searchFoods({
        q: q.q,
        category: q.category,
        limit: q.limit ?? 20,
        offset: q.offset ?? 0,
      });
      res.json({ foods });
    } catch (err) {
      next(err);
    }
  });

  // 记录一餐
  router.post('/records', validateBody(recordDietSchema), async (req: Request, res: Response, next: NextFunction) => {
    try {
      if (!req.user) throw new UnauthorizedError();
      const consumedAt = req.body.consumedAt ? new Date(req.body.consumedAt) : new Date();
      const rec = await dietService.recordDiet({
        userId: req.user.id,
        foodId: req.body.foodId,
        mealType: req.body.mealType,
        consumedAt,
        servings: req.body.servings,
      });
      res.status(201).json(rec);
    } catch (err) {
      next(err);
    }
  });

  // 列出某区间饮食记录
  router.get('/records', validateQuery(recordsQuerySchema), async (req: Request, res: Response, next: NextFunction) => {
    try {
      if (!req.user) throw new UnauthorizedError();
      const q = (req as any).validatedQuery ?? {};
      const records = await dietService.listRecords({
        userId: req.user.id,
        from: new Date(q.from),
        to: new Date(q.to),
      });
      res.json({ records });
    } catch (err) {
      next(err);
    }
  });

  // 每日营养汇总
  router.get('/summary', validateQuery(summaryQuerySchema), async (req: Request, res: Response, next: NextFunction) => {
    try {
      if (!req.user) throw new UnauthorizedError();
      const q = (req as any).validatedQuery ?? {};
      const date = q.date ? new Date(q.date) : new Date();
      const summary = await dietService.summary(req.user.id, date);
      res.json(summary);
    } catch (err) {
      next(err);
    }
  });

  return router;
}
