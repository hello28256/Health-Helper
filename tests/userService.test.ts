// UserService 单元测试 —— TDD 红绿循环的"红"阶段
// 使用内存 mock 模拟 Prisma，不依赖真实数据库

import bcrypt from 'bcrypt';
import { UserService } from '../src/services/userService';
import { ConflictError, UnauthorizedError } from '../src/utils/errors';

// 内存版 Prisma mock —— 只实现本测试需要的方法
function createPrismaMock() {
  const users = new Map<string, any>();
  const refreshTokens = new Map<string, any>();

  return {
    user: {
      findUnique: async ({ where }: any) => {
        if (where.email) {
          for (const u of users.values()) {
            if (u.email === where.email) return u;
          }
        }
        if (where.id) return users.get(where.id) ?? null;
        return null;
      },
      create: async ({ data }: any) => {
        if ([...users.values()].some((u) => u.email === data.email)) {
          throw new Error('Unique constraint failed');
        }
        const u = {
          id: `user_${users.size + 1}`,
          email: data.email,
          passwordHash: data.passwordHash,
          displayName: data.displayName ?? null,
          heightCm: null,
          weightKg: null,
          birthDate: null,
          createdAt: new Date(),
          updatedAt: new Date(),
        };
        users.set(u.id, u);
        return u;
      },
      update: async ({ where, data }: any) => {
        const u = users.get(where.id);
        if (!u) throw new Error('Not found');
        Object.assign(u, data, { updatedAt: new Date() });
        return u;
      },
    },
    refreshToken: {
      create: async ({ data }: any) => {
        const t = { id: `rt_${refreshTokens.size + 1}`, revokedAt: null, ...data };
        refreshTokens.set(t.id, t);
        return t;
      },
      findUnique: async ({ where }: any) => {
        if (where.tokenHash) {
          for (const t of refreshTokens.values()) {
            if (t.tokenHash === where.tokenHash) return t;
          }
        }
        return null;
      },
      update: async ({ where, data }: any) => {
        const t = refreshTokens.get(where.id);
        if (!t) throw new Error('Not found');
        Object.assign(t, data);
        return t;
      },
      updateMany: async ({ where, data }: any) => {
        const matches: any[] = [];
        for (const t of refreshTokens.values()) {
          if (where.userId && t.userId !== where.userId) continue;
          if (where.deviceId && t.deviceId !== where.deviceId) continue;
          if (where.revokedAt !== undefined && t.revokedAt !== where.revokedAt) continue;
          Object.assign(t, data);
          matches.push(t);
        }
        return { count: matches.length };
      },
    },
    __users: users,
    __refreshTokens: refreshTokens,
  };
}

// 简化版 JWT 工具 mock —— 测试中我们只关心 token 字符串是否被生成和接受
function createJwtMock() {
  const issuedTokens = new Map<string, { userId: string; deviceId: string; type: string }>();

  return {
    signAccessAsync: jest.fn((payload: { userId: string; deviceId: string }) => {
      const token = `access.${payload.userId}.${payload.deviceId}`;
      issuedTokens.set(token, { ...payload, type: 'access' });
      return Promise.resolve(token);
    }),
    signRefreshAsync: jest.fn((payload: { userId: string; deviceId: string }) => {
      const token = `refresh.${payload.userId}.${payload.deviceId}.${issuedTokens.size}`;
      issuedTokens.set(token, { ...payload, type: 'refresh' });
      return Promise.resolve(token);
    }),
    verifyRefreshAsync: jest.fn((token: string) => {
      const meta = issuedTokens.get(token);
      if (!meta || meta.type !== 'refresh') throw new Error('Invalid token');
      return Promise.resolve({ userId: meta.userId, deviceId: meta.deviceId, jti: `jti-${token}` });
    }),
    __issued: issuedTokens,
  };
}

describe('UserService.register', () => {
  it('creates a user with bcrypt-hashed password', async () => {
    const prisma = createPrismaMock();
    const jwt = createJwtMock();
    const svc = new UserService(prisma as any, jwt as any);

    const result = await svc.register({
      email: 'alice@example.com',
      password: 'secret123',
      deviceId: 'web-1',
    });

    expect(result.user.email).toBe('alice@example.com');
    expect(result.__test_passwordHash).not.toBe('secret123');
    expect(result.__test_passwordHash!.startsWith('$2')).toBe(true); // bcrypt
    expect(await bcrypt.compare('secret123', result.__test_passwordHash!)).toBe(true);
    expect(result.accessToken).toMatch(/^access\./);
    expect(result.refreshToken).toMatch(/^refresh\./);
  });

  it('rejects duplicate email with ConflictError', async () => {
    const prisma = createPrismaMock();
    const jwt = createJwtMock();
    const svc = new UserService(prisma as any, jwt as any);

    await svc.register({ email: 'bob@example.com', password: 'secret123', deviceId: 'd1' });

    await expect(
      svc.register({ email: 'bob@example.com', password: 'other', deviceId: 'd2' }),
    ).rejects.toBeInstanceOf(ConflictError);
  });
});

describe('UserService.login', () => {
  it('returns tokens for valid credentials', async () => {
    const prisma = createPrismaMock();
    const jwt = createJwtMock();
    const svc = new UserService(prisma as any, jwt as any);

    await svc.register({ email: 'carol@example.com', password: 'pw123', deviceId: 'd1' });
    const result = await svc.login({ email: 'carol@example.com', password: 'pw123', deviceId: 'd2' });

    expect(result.accessToken).toBeDefined();
    expect(result.refreshToken).toBeDefined();
  });

  it('throws UnauthorizedError for wrong password', async () => {
    const prisma = createPrismaMock();
    const jwt = createJwtMock();
    const svc = new UserService(prisma as any, jwt as any);

    await svc.register({ email: 'dave@example.com', password: 'correct', deviceId: 'd1' });

    await expect(
      svc.login({ email: 'dave@example.com', password: 'WRONG', deviceId: 'd1' }),
    ).rejects.toBeInstanceOf(UnauthorizedError);
  });

  it('throws UnauthorizedError for non-existent email', async () => {
    const prisma = createPrismaMock();
    const jwt = createJwtMock();
    const svc = new UserService(prisma as any, jwt as any);

    await expect(
      svc.login({ email: 'nobody@example.com', password: 'x', deviceId: 'd1' }),
    ).rejects.toBeInstanceOf(UnauthorizedError);
  });
});

describe('UserService.refresh (multi-device)', () => {
  it('issues a new access token when refresh token is valid', async () => {
    const prisma = createPrismaMock();
    const jwt = createJwtMock();
    const svc = new UserService(prisma as any, jwt as any);

    const { user, refreshToken } = await svc.register({
      email: 'eve@example.com',
      password: 'pw123',
      deviceId: 'iphone-1',
    });

    const result = await svc.refresh({ refreshToken, deviceId: 'iphone-1' });
    expect(result.accessToken).toBeDefined();
    expect(result.user.id).toBe(user.id);
  });

  it('throws UnauthorizedError when refresh token is invalid', async () => {
    const prisma = createPrismaMock();
    const jwt = createJwtMock();
    const svc = new UserService(prisma as any, jwt as any);

    await expect(svc.refresh({ refreshToken: 'not-a-real-token', deviceId: 'd1' })).rejects.toBeInstanceOf(
      UnauthorizedError,
    );
  });

  it('throws UnauthorizedError when deviceId does not match the token', async () => {
    const prisma = createPrismaMock();
    const jwt = createJwtMock();
    const svc = new UserService(prisma as any, jwt as any);

    const { refreshToken } = await svc.register({
      email: 'frank@example.com',
      password: 'pw',
      deviceId: 'iphone-1',
    });

    await expect(svc.refresh({ refreshToken, deviceId: 'android-2' })).rejects.toBeInstanceOf(
      UnauthorizedError,
    );
  });
});

describe('UserService.logout', () => {
  it('revokes the refresh token', async () => {
    const prisma = createPrismaMock();
    const jwt = createJwtMock();
    const svc = new UserService(prisma as any, jwt as any);

    const { refreshToken } = await svc.register({
      email: 'grace@example.com',
      password: 'pw',
      deviceId: 'web-1',
    });

    await svc.logout({ refreshToken, deviceId: 'web-1' });

    await expect(svc.refresh({ refreshToken, deviceId: 'web-1' })).rejects.toBeInstanceOf(
      UnauthorizedError,
    );
  });
});
