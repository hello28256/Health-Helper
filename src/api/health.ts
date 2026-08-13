import { Router, Request, Response, NextFunction } from 'express';
import { z } from 'zod';

import { requireAuth } from './middlewares/auth';
import { validateBody, validateQuery } from './middlewares/validate';
import { UnauthorizedError } from '../utils/errors';
import { createHealthRecordsService, HEALTH_METRICS } from '../services/healthRecordsService';

const recordHealthSchema = z.object({
  records: z
    .array(
      z.object({
        metric: z.enum(HEALTH_METRICS as unknown as [string, ...string[]]),
        value: z.number().finite(),
        unit: z.string().min(1).max(16),
        startAt: z.string().datetime().transform((s) => new Date(s)),
        endAt: z
          .string()
          .datetime()
          .transform((s) => new Date(s))
          .optional(),
        source: z.string().min(1).max(64),
        raw: z.unknown().optional(),
      }),
    )
    .min(1)
    .max(500),
});

const listHealthQuerySchema = z.object({
  metric: z.enum(HEALTH_METRICS as unknown as [string, ...string[]]),
  from: z.string().datetime().transform((s) => new Date(s)),
  to: z.string().datetime().transform((s) => new Date(s)),
});

const latestHealthQuerySchema = z.object({
  metric: z.enum(HEALTH_METRICS as unknown as [string, ...string[]]),
});

/**
 * /api/health —— 健康数据批量上报 + 查询
 *
 * 路由：
 * - POST   /records               批量上报（HealthKit / Health Connect 同步）
 * - GET    /records?metric=&from=&to=  历史范围查询
 * - GET    /records/latest?metric=     最新一条
 *
 * 步骤（steps）走专用 /api/exercises/steps 端点（带 max-value 策略），
 * 这里只覆盖 7 种非步数指标。
 */
export function buildHealthRouter(): Router {
  const router = Router();
  const healthService = createHealthRecordsService();

  router.use(requireAuth);

  router.post(
    '/records',
    validateBody(recordHealthSchema),
    async (req: Request, res: Response, next: NextFunction) => {
      try {
        if (!req.user) throw new UnauthorizedError();
        const records = await healthService.record({
          userId: req.user.id,
          records: req.body.records.map((r: any) => ({
            metric: r.metric,
            value: r.value,
            unit: r.unit,
            startAt: r.startAt,
            endAt: r.endAt ?? null,
            source: r.source,
            raw: r.raw,
          })),
        });
        res.status(201).json({ records });
      } catch (err) {
        next(err);
      }
    },
  );

  router.get(
    '/records',
    validateQuery(listHealthQuerySchema),
    async (req: Request, res: Response, next: NextFunction) => {
      try {
        if (!req.user) throw new UnauthorizedError();
        const q = (req as any).validatedQuery ?? {};
        const records = await healthService.list({
          userId: req.user.id,
          metric: q.metric,
          from: q.from,
          to: q.to,
        });
        res.json({ records });
      } catch (err) {
        next(err);
      }
    },
  );

  router.get(
    '/records/latest',
    validateQuery(latestHealthQuerySchema),
    async (req: Request, res: Response, next: NextFunction) => {
      try {
        if (!req.user) throw new UnauthorizedError();
        const q = (req as any).validatedQuery ?? {};
        const record = await healthService.latest({
          userId: req.user.id,
          metric: q.metric,
        });
        res.json({ record });
      } catch (err) {
        next(err);
      }
    },
  );

  return router;
}