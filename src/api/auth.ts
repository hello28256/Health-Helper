import { Router, Request, Response, NextFunction } from 'express';
import { z } from 'zod';

import { UserService } from '../services/userService';
import { createUserService } from '../services/userService';
import { UnauthorizedError } from '../utils/errors';
import { validateBody } from './middlewares/validate';

const registerSchema = z.object({
  email: z.string().email().max(255),
  password: z.string().min(8).max(128),
  deviceId: z.string().min(1).max(128),
  displayName: z.string().min(1).max(64).optional(),
});

const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(1),
  deviceId: z.string().min(1).max(128),
});

const refreshSchema = z.object({
  refreshToken: z.string().min(1),
  deviceId: z.string().min(1).max(128),
});

const logoutSchema = z.object({
  refreshToken: z.string().min(1),
  deviceId: z.string().min(1).max(128),
});

export function buildAuthRouter(userService: UserService = createUserService()): Router {
  const router = Router();

  router.post('/register', validateBody(registerSchema), async (req: Request, res: Response, next: NextFunction) => {
    try {
      const result = await userService.register(req.body);
      res.status(201).json(result);
    } catch (err) {
      next(err);
    }
  });

  router.post('/login', validateBody(loginSchema), async (req: Request, res: Response, next: NextFunction) => {
    try {
      const result = await userService.login(req.body);
      res.json(result);
    } catch (err) {
      next(err);
    }
  });

  router.post('/refresh', validateBody(refreshSchema), async (req: Request, res: Response, next: NextFunction) => {
    try {
      const result = await userService.refresh(req.body);
      res.json(result);
    } catch (err) {
      next(err);
    }
  });

  router.post('/logout', validateBody(logoutSchema), async (req: Request, res: Response, next: NextFunction) => {
    try {
      await userService.logout(req.body);
      res.status(204).send();
    } catch (err) {
      if (err instanceof UnauthorizedError) {
        // logout 幂等，找不到/已撤销都当成功
        res.status(204).send();
        return;
      }
      next(err);
    }
  });

  return router;
}
