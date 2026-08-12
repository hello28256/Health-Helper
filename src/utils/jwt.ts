import jwt, { SignOptions } from 'jsonwebtoken';
import { v4 as uuidv4 } from 'uuid';
import { env } from './env';
import { UnauthorizedError } from './errors';

export interface JwtPayload {
  userId: string;
  deviceId: string;
  // 防止 access token 被当作 refresh 使用
  typ: 'access' | 'refresh';
}

/**
 * JWT 工具 —— 把签发/校验集中在一处，方便测试 mock。
 * access 与 refresh 用同一个 secret + 不同 typ 区分，TTL 不同。
 */
export class JwtUtil {
  signAccess(payload: { userId: string; deviceId: string }): string {
    return jwt.sign({ ...payload, typ: 'access' }, env.JWT_ACCESS_SECRET, {
      expiresIn: env.JWT_ACCESS_TTL,
    } as SignOptions);
  }

  signRefresh(payload: { userId: string; deviceId: string }): string {
    return jwt.sign({ ...payload, typ: 'refresh' }, env.JWT_REFRESH_SECRET, {
      expiresIn: env.JWT_REFRESH_TTL,
      jwtid: uuidv4(),
    } as SignOptions);
  }

  /**
   * 异步包装：让 service 层 await，且便于测试 mock。
   */
  async signAccessAsync(payload: { userId: string; deviceId: string }): Promise<string> {
    return this.signAccess(payload);
  }

  async signRefreshAsync(payload: { userId: string; deviceId: string }): Promise<string> {
    return this.signRefresh(payload);
  }

  async verifyRefreshAsync(token: string): Promise<{ userId: string; deviceId: string; jti: string }> {
    return this.verifyRefresh(token);
  }

  /**
   * 校验 refresh token，返回 userId/deviceId。
   * 校验失败统一抛 UnauthorizedError，调用方无需关心 jwt 错误码。
   */
  verifyRefresh(token: string): { userId: string; deviceId: string; jti: string } {
    try {
      const decoded = jwt.verify(token, env.JWT_REFRESH_SECRET) as JwtPayload & { jti: string };
      if (decoded.typ !== 'refresh') {
        throw new UnauthorizedError('Invalid token type');
      }
      if (!decoded.userId || !decoded.deviceId || !decoded.jti) {
        throw new UnauthorizedError('Malformed token payload');
      }
      return { userId: decoded.userId, deviceId: decoded.deviceId, jti: decoded.jti };
    } catch (err) {
      if (err instanceof UnauthorizedError) throw err;
      throw new UnauthorizedError('Invalid or expired refresh token');
    }
  }

  /**
   * 校验 access token（中间件用）。
   */
  verifyAccess(token: string): { userId: string; deviceId: string } {
    try {
      const decoded = jwt.verify(token, env.JWT_ACCESS_SECRET) as JwtPayload;
      if (decoded.typ !== 'access') {
        throw new UnauthorizedError('Invalid token type');
      }
      if (!decoded.userId || !decoded.deviceId) {
        throw new UnauthorizedError('Malformed token payload');
      }
      return { userId: decoded.userId, deviceId: decoded.deviceId };
    } catch (err) {
      if (err instanceof UnauthorizedError) throw err;
      throw new UnauthorizedError('Invalid or expired access token');
    }
  }
}

export const jwtUtil = new JwtUtil();
