import express, { Application, NextFunction, Request, Response } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import rateLimit from 'express-rate-limit';

import { env, corsOrigins } from '../utils/env';
import { logger } from '../utils/logger';
import { AppError } from '../utils/errors';
import { buildAuthRouter } from './auth';
import { buildUsersRouter } from './users';
import { buildExercisesRouter } from './exercises';
import { buildDietRouter } from './diet';
import { buildMoodRouter } from './mood';
import { buildChatRouter } from './chat';
import { buildDocsRouter } from './docs';

export function createApp(): Application {
  const app = express();

  // ===== 安全 / 中间件 =====
  app.use(helmet());
  app.use(
    cors({
      origin: corsOrigins.length > 0 ? corsOrigins : true,
      credentials: true,
    }),
  );
  app.use(express.json({ limit: '1mb' }));
  app.use(express.urlencoded({ extended: false }));

  if (env.NODE_ENV !== 'test') {
    app.use(morgan(env.NODE_ENV === 'production' ? 'combined' : 'dev'));
  }

  // 全局限流（跳过 docs/ 与 health，避免被自己的文档页拖垮）
  const limiter = rateLimit({
    windowMs: env.RATE_LIMIT_WINDOW_MS,
    max: env.RATE_LIMIT_MAX_REQUESTS,
    standardHeaders: true,
    legacyHeaders: false,
    skip: (req) => req.path.startsWith('/api/docs') || req.path === '/health',
    message: { error: { code: 'RATE_LIMITED', message: 'Too many requests' } },
  });
  app.use('/api/', limiter);

  // ===== 健康检查 =====
  app.get('/health', (_req: Request, res: Response) => {
    res.json({ status: 'ok', env: env.NODE_ENV, ts: new Date().toISOString() });
  });

  // ===== 路由挂载点（后续 task 补充） =====
  app.get('/api', (_req: Request, res: Response) => {
    res.json({
      name: 'health-helper-api',
      version: '0.1.0',
      endpoints: ['/api/auth', '/api/users', '/api/exercises', '/api/steps', '/api/diet', '/api/mood', '/api/chat'],
    });
  });

  // ===== 业务路由 =====
  app.use('/api/auth', buildAuthRouter());
  app.use('/api/users', buildUsersRouter());
  app.use('/api/exercises', buildExercisesRouter());
  app.use('/api/diet', buildDietRouter());
  app.use('/api/mood', buildMoodRouter());
  app.use('/api/chat', buildChatRouter());
  app.use('/api/docs', buildDocsRouter());

  // ===== 404 =====
  app.use((req: Request, res: Response) => {
    res.status(404).json({
      error: {
        code: 'NOT_FOUND',
        message: `Route ${req.method} ${req.path} does not exist`,
      },
    });
  });

  // ===== 统一错误处理 =====
  app.use((err: Error, _req: Request, res: Response, _next: NextFunction) => {
    if (err instanceof AppError) {
      logger.warn('AppError', { code: err.code, message: err.message, status: err.status });
      res.status(err.status).json({
        error: {
          code: err.code,
          message: err.message,
          details: err.details,
        },
      });
      return;
    }

    logger.error('Unhandled error', {
      message: err.message,
      stack: err.stack,
    });
    res.status(500).json({
      error: {
        code: 'INTERNAL_ERROR',
        message: env.NODE_ENV === 'production' ? 'Internal server error' : err.message,
      },
    });
  });

  return app;
}
