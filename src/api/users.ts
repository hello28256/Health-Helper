import { Router, Request, Response, NextFunction } from 'express';
import { z } from 'zod';

import { requireAuth } from './middlewares/auth';
import { validateBody } from './middlewares/validate';
import { createUserService } from '../services/userService';
import { UnauthorizedError } from '../utils/errors';

const updateProfileSchema = z
  .object({
    displayName: z.string().min(1).max(64).optional(),
    heightCm: z.number().min(50).max(250).optional(),
    weightKg: z.number().min(20).max(300).optional(),
    birthDate: z.string().datetime().optional(),
  })
  .transform((v) => ({
    ...v,
    birthDate: v.birthDate ? new Date(v.birthDate) : undefined,
  }));

export function buildUsersRouter(): Router {
  const router = Router();
  const userService = createUserService();

  router.use(requireAuth);

  router.get('/me', async (req: Request, res: Response, next: NextFunction) => {
    try {
      if (!req.user) throw new UnauthorizedError();
      const user = await userService.getById(req.user.id);
      res.json(user);
    } catch (err) {
      next(err);
    }
  });

  router.patch('/me', validateBody(updateProfileSchema), async (req: Request, res: Response, next: NextFunction) => {
    try {
      if (!req.user) throw new UnauthorizedError();
      const user = await userService.updateProfile(req.user.id, req.body);
      res.json(user);
    } catch (err) {
      next(err);
    }
  });

  return router;
}
