import { Request, Response, NextFunction } from 'express';
import { jwtUtil } from '../../utils/jwt';
import { UnauthorizedError } from '../../utils/errors';

declare global {
  // eslint-disable-next-line @typescript-eslint/no-namespace
  namespace Express {
    interface Request {
      user?: { id: string; deviceId: string };
    }
  }
}

/**
 * JWT 鉴权中间件 —— 从 Authorization: Bearer <token> 提取 access token，
 * 校验通过后把 userId/deviceId 挂到 req.user。
 *
 * 失败统一抛 UnauthorizedError，由全局错误中间件序列化为 401 JSON。
 */
export function requireAuth(req: Request, _res: Response, next: NextFunction): void {
  const header = req.headers.authorization;
  if (!header || !header.startsWith('Bearer ')) {
    return next(new UnauthorizedError('Missing Authorization header'));
  }

  const token = header.slice('Bearer '.length).trim();
  try {
    const payload = jwtUtil.verifyAccess(token);
    req.user = { id: payload.userId, deviceId: payload.deviceId };
    next();
  } catch (err) {
    next(err);
  }
}

/**
 * 可选鉴权：有 token 就解析挂载，没有也不报错。
 * 用于"同一接口既能匿名访问又有个性化"的场景（如公开食物搜索）。
 */
export function optionalAuth(req: Request, _res: Response, next: NextFunction): void {
  const header = req.headers.authorization;
  if (!header || !header.startsWith('Bearer ')) return next();

  const token = header.slice('Bearer '.length).trim();
  try {
    const payload = jwtUtil.verifyAccess(token);
    req.user = { id: payload.userId, deviceId: payload.deviceId };
  } catch {
    // 静默忽略：可选鉴权失败不阻塞
  }
  next();
}
