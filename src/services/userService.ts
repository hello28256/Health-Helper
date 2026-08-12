import bcrypt from 'bcrypt';
import crypto from 'crypto';

import { env } from '../utils/env';
import { logger } from '../utils/logger';
import { ConflictError, UnauthorizedError, NotFoundError } from '../utils/errors';
import { JwtUtil, jwtUtil } from '../utils/jwt';
import { prisma } from '../models/prisma';

export interface RegisterInput {
  email: string;
  password: string;
  deviceId: string;
  displayName?: string;
}

export interface LoginInput {
  email: string;
  password: string;
  deviceId: string;
}

export interface RefreshInput {
  refreshToken: string;
  deviceId: string;
}

export interface AuthResult {
  user: PublicUser;
  accessToken: string;
  refreshToken: string;
  /**
   * 仅测试用：暴露 passwordHash 验证 bcrypt。
   * 生产代码不应该读这个字段。
   */
  __test_passwordHash?: string;
}

export type PublicUser = {
  id: string;
  email: string;
  displayName: string | null;
  heightCm: number | null;
  weightKg: number | null;
  birthDate: Date | null;
  createdAt: Date;
};

/**
 * Prisma 类型用泛型避开测试时传入 mock 的问题。
 * 真实环境用 PrismaClient，测试环境传 mock。
 */
// eslint-disable-next-line @typescript-eslint/no-explicit-any
type PrismaLike = any;

/**
 * UserService —— 业务逻辑层
 *
 * 设计要点：
 * - 密码 bcrypt 哈希（cost = env.BCRYPT_ROUNDS）
 * - refresh token 存哈希而非明文（数据库泄露不会泄露 token）
 * - 每端独立 refresh token（deviceId 维度），满足"多端登录"诉求
 * - 同一端重复登录会失效旧 token，避免 token 永久堆积
 */
export class UserService {
  constructor(
    private readonly prisma: PrismaLike,
    private readonly jwt: JwtUtil,
  ) {}

  // eslint-disable-next-line class-methods-use-this
  private toPublic(user: any): PublicUser {
    return {
      id: user.id,
      email: user.email,
      displayName: user.displayName ?? null,
      heightCm: user.heightCm ? Number(user.heightCm) : null,
      weightKg: user.weightKg ? Number(user.weightKg) : null,
      birthDate: user.birthDate ?? null,
      createdAt: user.createdAt,
    };
  }

  async register(input: RegisterInput): Promise<AuthResult> {
    const existing = await this.prisma.user.findUnique({ where: { email: input.email } });
    if (existing) {
      throw new ConflictError('Email already registered');
    }

    const passwordHash = await bcrypt.hash(input.password, env.BCRYPT_ROUNDS);

    const user = await this.prisma.user.create({
      data: {
        email: input.email,
        passwordHash,
        displayName: input.displayName ?? null,
      },
    });

    const tokens = await this.issueTokens(user.id, input.deviceId);
    logger.info('User registered', { userId: user.id, deviceId: input.deviceId });

    return { user: this.toPublic(user), ...tokens, __test_passwordHash: passwordHash };
  }

  async login(input: LoginInput): Promise<AuthResult> {
    const user = await this.prisma.user.findUnique({ where: { email: input.email } });
    if (!user) {
      // 不区分"邮箱不存在"和"密码错"——避免账号枚举
      throw new UnauthorizedError('Invalid credentials');
    }

    const ok = await bcrypt.compare(input.password, user.passwordHash);
    if (!ok) {
      throw new UnauthorizedError('Invalid credentials');
    }

    const tokens = await this.issueTokens(user.id, input.deviceId);
    logger.info('User logged in', { userId: user.id, deviceId: input.deviceId });

    return { user: this.toPublic(user), ...tokens };
  }

  async refresh(input: RefreshInput): Promise<AuthResult> {
    let decoded;
    try {
      decoded = await this.jwt.verifyRefreshAsync(input.refreshToken);
    } catch {
      throw new UnauthorizedError('Invalid or expired refresh token');
    }
    if (decoded.deviceId !== input.deviceId) {
      // 防止 refresh token 被另一端使用
      throw new UnauthorizedError('Refresh token does not belong to this device');
    }

    // 数据库中按 tokenHash 查找（明文 token 不入库）
    const tokenHash = this.hashToken(input.refreshToken);
    const stored = await this.prisma.refreshToken.findUnique({ where: { tokenHash } });
    if (!stored || stored.revokedAt || stored.expiresAt < new Date()) {
      throw new UnauthorizedError('Refresh token revoked or expired');
    }

    const user = await this.prisma.user.findUnique({ where: { id: decoded.userId } });
    if (!user) {
      throw new UnauthorizedError('User no longer exists');
    }

    // 轮转：撤销旧 refresh，签发新的（refresh token rotation）
    await this.prisma.refreshToken.update({
      where: { id: stored.id },
      data: { revokedAt: new Date() },
    });

    const tokens = await this.issueTokens(user.id, input.deviceId);
    logger.info('Refresh token rotated', { userId: user.id, deviceId: input.deviceId });

    return { user: this.toPublic(user), ...tokens };
  }

  async logout(input: { refreshToken: string; deviceId: string }): Promise<void> {
    const tokenHash = this.hashToken(input.refreshToken);
    const stored = await this.prisma.refreshToken.findUnique({ where: { tokenHash } });
    if (!stored) return; // 幂等：找不到就当成功
    if (stored.revokedAt) return;

    await this.prisma.refreshToken.update({
      where: { id: stored.id },
      data: { revokedAt: new Date() },
    });
    logger.info('User logged out', { userId: stored.userId, deviceId: input.deviceId });
  }

  async getById(userId: string): Promise<PublicUser> {
    const user = await this.prisma.user.findUnique({ where: { id: userId } });
    if (!user) throw new NotFoundError('User');
    return this.toPublic(user);
  }

  async updateProfile(
    userId: string,
    patch: { displayName?: string; heightCm?: number; weightKg?: number; birthDate?: Date },
  ): Promise<PublicUser> {
    const data: any = {};
    if (patch.displayName !== undefined) data.displayName = patch.displayName;
    if (patch.heightCm !== undefined) data.heightCm = patch.heightCm;
    if (patch.weightKg !== undefined) data.weightKg = patch.weightKg;
    if (patch.birthDate !== undefined) data.birthDate = patch.birthDate;

    const user = await this.prisma.user.update({ where: { id: userId }, data });
    return this.toPublic(user);
  }

  // ===== private =====

  private async issueTokens(
    userId: string,
    deviceId: string,
  ): Promise<{ accessToken: string; refreshToken: string }> {
    const accessToken = await this.jwt.signAccessAsync({ userId, deviceId });
    const refreshToken = await this.jwt.signRefreshAsync({ userId, deviceId });
    const tokenHash = this.hashToken(refreshToken);

    // 同端重复登录时，先撤销该 deviceId 旧 token
    await this.prisma.refreshToken.updateMany({
      where: { userId, deviceId, revokedAt: null },
      data: { revokedAt: new Date() },
    });

    await this.prisma.refreshToken.create({
      data: {
        userId,
        deviceId,
        tokenHash,
        expiresAt: new Date(Date.now() + this.parseTtlMs(env.JWT_REFRESH_TTL)),
      },
    });

    return { accessToken, refreshToken };
  }

  // eslint-disable-next-line class-methods-use-this
  private hashToken(token: string): string {
    return crypto.createHash('sha256').update(token).digest('hex');
  }

  // eslint-disable-next-line class-methods-use-this
  private parseTtlMs(ttl: string): number {
    const match = /^(\d+)([smhd])$/.exec(ttl);
    if (!match) return 7 * 24 * 60 * 60 * 1000;
    const n = Number(match[1]);
    const unit = match[2];
    const mul = { s: 1000, m: 60_000, h: 3_600_000, d: 86_400_000 }[unit] ?? 1000;
    return n * mul;
  }
}

// 真实环境用的工厂：注入 prisma + jwtUtil
export function createUserService(): UserService {
  return new UserService(prisma, jwtUtil);
}
