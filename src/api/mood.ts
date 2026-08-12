import { Router, Request, Response, NextFunction } from 'express';
import { z } from 'zod';

import { requireAuth } from './middlewares/auth';
import { validateBody, validateQuery } from './middlewares/validate';
import { UnauthorizedError } from '../utils/errors';
import { createMoodService, VALID_MOODS } from '../services/moodService';

const recordMoodSchema = z.object({
  mood: z.enum(VALID_MOODS as unknown as [string, ...string[]]),
  score: z.coerce.number().int().min(1).max(10).optional(),
  note: z.string().max(2000).optional(),
  recordedAt: z.string().datetime().optional(),
});

const listMoodQuerySchema = z.object({
  from: z.string().datetime().optional(),
  to: z.string().datetime().optional(),
});

const trendQuerySchema = z.object({
  from: z.string().datetime(),
  to: z.string().datetime(),
});

export function buildMoodRouter(): Router {
  const router = Router();
  const moodService = createMoodService();

  router.use(requireAuth);

  router.post('/', validateBody(recordMoodSchema), async (req: Request, res: Response, next: NextFunction) => {
    try {
      if (!req.user) throw new UnauthorizedError();
      const recordedAt = req.body.recordedAt ? new Date(req.body.recordedAt) : new Date();
      const rec = await moodService.record({
        userId: req.user.id,
        mood: req.body.mood,
        score: req.body.score ?? null,
        note: req.body.note ?? null,
        recordedAt,
      });
      res.status(201).json(rec);
    } catch (err) {
      next(err);
    }
  });

  router.get('/', validateQuery(listMoodQuerySchema), async (req: Request, res: Response, next: NextFunction) => {
    try {
      if (!req.user) throw new UnauthorizedError();
      const q = (req as any).validatedQuery ?? {};
      const records = await moodService.list({
        userId: req.user.id,
        from: q.from ? new Date(q.from) : undefined,
        to: q.to ? new Date(q.to) : undefined,
      });
      res.json({ records });
    } catch (err) {
      next(err);
    }
  });

  router.get('/trend', validateQuery(trendQuerySchema), async (req: Request, res: Response, next: NextFunction) => {
    try {
      if (!req.user) throw new UnauthorizedError();
      const q = (req as any).validatedQuery ?? {};
      const trend = await moodService.trend({
        userId: req.user.id,
        from: new Date(q.from),
        to: new Date(q.to),
      });
      res.json({ trend });
    } catch (err) {
      next(err);
    }
  });

  return router;
}
