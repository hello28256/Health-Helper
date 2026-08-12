import { Router, Request, Response, NextFunction } from 'express';
import { z } from 'zod';

import { requireAuth } from './middlewares/auth';
import { validateBody, validateQuery } from './middlewares/validate';
import { UnauthorizedError } from '../utils/errors';
import { createExerciseService, createStepService } from '../services/exerciseService';

const createExerciseSchema = z.object({
  typeId: z.string().min(1).max(64),
  startedAt: z.string().datetime().transform((s) => new Date(s)),
  durationSec: z.number().int().min(0).max(24 * 3600),
  distanceKm: z.number().min(0).max(1000).optional(),
  clientId: z.string().min(1).max(128).optional(),
});

const listExercisesQuerySchema = z.object({
  from: z.string().datetime().optional(),
  to: z.string().datetime().optional(),
});

const upsertStepSchema = z.object({
  date: z.string().datetime().optional(),
  steps: z.number().int().min(0).max(200_000),
  source: z.enum(['ios_pedometer', 'android_sensor', 'manual']).optional(),
});

export function buildExercisesRouter(): Router {
  const router = Router();
  const exerciseService = createExerciseService();
  const stepService = createStepService();

  router.use(requireAuth);

  // 列出所有运动类型（含 MET + 注意事项）
  router.get('/types', async (_req: Request, res: Response, next: NextFunction) => {
    try {
      const types = await exerciseService.listTypes();
      res.json({ types });
    } catch (err) {
      next(err);
    }
  });

  // 创建运动记录
  router.post('/', validateBody(createExerciseSchema), async (req: Request, res: Response, next: NextFunction) => {
    try {
      if (!req.user) throw new UnauthorizedError();
      const rec = await exerciseService.create({
        userId: req.user.id,
        ...req.body,
      });
      res.status(201).json(rec);
    } catch (err) {
      next(err);
    }
  });

  // 查询运动记录
  router.get('/', validateQuery(listExercisesQuerySchema), async (req: Request, res: Response, next: NextFunction) => {
    try {
      if (!req.user) throw new UnauthorizedError();
      const q = (req as any).validatedQuery ?? {};
      const records = await exerciseService.list({
        userId: req.user.id,
        from: q.from ? new Date(q.from) : undefined,
        to: q.to ? new Date(q.to) : undefined,
      });
      res.json({ records });
    } catch (err) {
      next(err);
    }
  });

  // 上报今日步数
  router.post('/steps', validateBody(upsertStepSchema), async (req: Request, res: Response, next: NextFunction) => {
    try {
      if (!req.user) throw new UnauthorizedError();
      const date = req.body.date ? new Date(req.body.date) : new Date();
      const row = await stepService.upsert({
        userId: req.user.id,
        date,
        steps: req.body.steps,
        source: req.body.source,
      });
      res.status(201).json(row);
    } catch (err) {
      next(err);
    }
  });

  // 查询今日步数
  router.get('/steps/today', async (req: Request, res: Response, next: NextFunction) => {
    try {
      if (!req.user) throw new UnauthorizedError();
      const row = await stepService.today(req.user.id);
      res.json(row);
    } catch (err) {
      next(err);
    }
  });

  return router;
}
