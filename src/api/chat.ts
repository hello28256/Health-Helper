import { Router, Request, Response, NextFunction } from 'express';
import { z } from 'zod';

import { requireAuth } from './middlewares/auth';
import { validateBody, validateQuery } from './middlewares/validate';
import { UnauthorizedError } from '../utils/errors';
import { createChatService } from '../services/chatService';

const sendMessageSchema = z.object({
  content: z.string().min(1).max(4000),
});

const historyQuerySchema = z.object({
  limit: z.coerce.number().int().min(1).max(200).optional(),
});

export function buildChatRouter(): Router {
  const router = Router();
  const chatService = createChatService();

  router.use(requireAuth);

  router.post(
    '/messages',
    validateBody(sendMessageSchema),
    async (req: Request, res: Response, next: NextFunction) => {
      try {
        if (!req.user) throw new UnauthorizedError();
        const result = await chatService.sendMessage({
          userId: req.user.id,
          content: req.body.content,
        });
        res.status(201).json(result);
      } catch (err) {
        next(err);
      }
    },
  );

  router.get(
    '/history',
    validateQuery(historyQuerySchema),
    async (req: Request, res: Response, next: NextFunction) => {
      try {
        if (!req.user) throw new UnauthorizedError();
        const q = (req as any).validatedQuery ?? {};
        const history = await chatService.history({
          userId: req.user.id,
          limit: q.limit ?? 50,
        });
        res.json({ history });
      } catch (err) {
        next(err);
      }
    },
  );

  return router;
}
