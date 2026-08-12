import { Request, Response, NextFunction } from 'express';
import { ZodTypeAny, ZodError } from 'zod';
import { ValidationError } from '../../utils/errors';

/**
 * 通用 Zod 校验中间件 —— 把 req.body / req.query / req.params 用 schema 校验，
 * 失败抛 ValidationError（自动转 400 JSON）。
 */
// eslint-disable-next-line @typescript-eslint/no-explicit-any
export function validateBody(schema: ZodTypeAny) {
  return (req: Request, _res: Response, next: NextFunction): void => {
    try {
      req.body = schema.parse(req.body);
      next();
    } catch (err) {
      if (err instanceof ZodError) {
        next(new ValidationError('Invalid request body', err.flatten()));
      } else {
        next(err);
      }
    }
  };
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export function validateQuery(schema: ZodTypeAny) {
  return (req: Request, _res: Response, next: NextFunction): void => {
    try {
      const parsed = schema.parse(req.query);
      (req as any).validatedQuery = parsed;
      next();
    } catch (err) {
      if (err instanceof ZodError) {
        next(new ValidationError('Invalid query parameters', err.flatten()));
      } else {
        next(err);
      }
    }
  };
}
