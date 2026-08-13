// DeviceService 单元测试
// TDD：先写测试，再写实现

import { DeviceService, createDeviceService } from '../src/services/deviceService';
import { ValidationError } from '../src/utils/errors';

// ===== Prisma mock =====
// eslint-disable-next-line @typescript-eslint/no-explicit-any
function createPrismaMock() {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const tokens: any[] = [];

  return {
    deviceToken: {
      // upsert: 按 (userId, deviceId, platform) 唯一
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      upsert: async ({ where, create, update }: any) => {
        const k = `${where.userId_deviceId_platform.userId}|${where.userId_deviceId_platform.deviceId}|${where.userId_deviceId_platform.platform}`;
        const idx = tokens.findIndex(
          (t) =>
            t.userId === where.userId_deviceId_platform.userId &&
            t.deviceId === where.userId_deviceId_platform.deviceId &&
            t.platform === where.userId_deviceId_platform.platform,
        );
        if (idx >= 0) {
          tokens[idx] = { ...tokens[idx], ...update, lastSeenAt: new Date() };
          return tokens[idx];
        }
        const row = {
          id: `dt_${tokens.length + 1}`,
          ...create,
          createdAt: new Date(),
          lastSeenAt: new Date(),
          revokedAt: null,
        };
        tokens.push(row);
        return row;
      },
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      updateMany: async ({ where, data }: any) => {
        const updated = tokens.filter((t) => {
          if (where.userId && t.userId !== where.userId) return false;
          if (where.deviceId && t.deviceId !== where.deviceId) return false;
          if (where.platform && t.platform !== where.platform) return false;
          if (where.revokedAt === null && t.revokedAt !== null) return false;
          return true;
        });
        for (const t of updated) Object.assign(t, data);
        return { count: updated.length };
      },
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      findMany: async ({ where, orderBy }: any) => {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        let rows = tokens.filter((t: any) => {
          if (where.userId && t.userId !== where.userId) return false;
          if (where.revokedAt === null && t.revokedAt !== null) return false;
          return true;
        });
        if (orderBy?.lastSeenAt === 'desc') {
          rows.sort((a: any, b: any) => b.lastSeenAt - a.lastSeenAt);
        }
        return rows;
      },
    },
  };
}

describe('DeviceService', () => {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  let mock: any;
  let svc: DeviceService;

  beforeEach(() => {
    mock = createPrismaMock();
    svc = new DeviceService(mock);
  });

  describe('upsertToken', () => {
    it('creates a new token on first upsert', async () => {
      const row = await svc.upsertToken({
        userId: 'u1',
        deviceId: 'iphone-1',
        platform: 'ios',
        apnsToken: 'apns-abc',
        appVersion: '1.0.0',
        locale: 'zh-CN',
      });
      expect(row.apnsToken).toBe('apns-abc');
      expect(row.fcmToken).toBeNull();
      expect(row.revokedAt).toBeNull();
    });

    it('updates existing token (same userId+deviceId+platform)', async () => {
      await svc.upsertToken({
        userId: 'u1',
        deviceId: 'iphone-1',
        platform: 'ios',
        apnsToken: 'old-token',
      });
      const row = await svc.upsertToken({
        userId: 'u1',
        deviceId: 'iphone-1',
        platform: 'ios',
        apnsToken: 'new-token',
      });
      expect(row.apnsToken).toBe('new-token');
    });

    it('stores fcmToken for android', async () => {
      const row = await svc.upsertToken({
        userId: 'u1',
        deviceId: 'pixel-1',
        platform: 'android',
        fcmToken: 'fcm-xyz',
      });
      expect(row.fcmToken).toBe('fcm-xyz');
      expect(row.apnsToken).toBeNull();
    });

    it('rejects empty deviceId', async () => {
      await expect(
        svc.upsertToken({
          userId: 'u1',
          deviceId: '',
          platform: 'ios',
          apnsToken: 'apns',
        }),
      ).rejects.toThrow(ValidationError);
    });

    it('rejects empty token (neither fcm nor apns)', async () => {
      await expect(
        svc.upsertToken({
          userId: 'u1',
          deviceId: 'iphone-1',
          platform: 'ios',
        }),
      ).rejects.toThrow(ValidationError);
    });
  });

  describe('revoke', () => {
    it('revokes all active tokens for a (userId, deviceId)', async () => {
      await svc.upsertToken({
        userId: 'u1',
        deviceId: 'iphone-1',
        platform: 'ios',
        apnsToken: 'apns',
      });
      await svc.upsertToken({
        userId: 'u1',
        deviceId: 'iphone-1',
        platform: 'ios', // 同一端 upsert
        apnsToken: 'apns-2',
      });

      const count = await svc.revoke({ userId: 'u1', deviceId: 'iphone-1' });
      expect(count).toBeGreaterThanOrEqual(1);

      const active = await svc.listActive('u1');
      expect(active).toHaveLength(0);
    });

    it('is idempotent (revoking again is a no-op)', async () => {
      await svc.upsertToken({
        userId: 'u1',
        deviceId: 'iphone-1',
        platform: 'ios',
        apnsToken: 'apns',
      });
      await svc.revoke({ userId: 'u1', deviceId: 'iphone-1' });
      const second = await svc.revoke({ userId: 'u1', deviceId: 'iphone-1' });
      expect(second).toBe(0);
    });

    it('returns 0 (no-op) when no active tokens exist', async () => {
      const count = await svc.revoke({ userId: 'u-unknown', deviceId: 'x' });
      expect(count).toBe(0);
    });
  });

  describe('listActive', () => {
    it('returns only non-revoked tokens for the user', async () => {
      await svc.upsertToken({
        userId: 'u1',
        deviceId: 'iphone',
        platform: 'ios',
        apnsToken: 'apns-1',
      });
      await svc.upsertToken({
        userId: 'u1',
        deviceId: 'pixel',
        platform: 'android',
        fcmToken: 'fcm-1',
      });
      await svc.upsertToken({
        userId: 'u2', // 别人的
        deviceId: 'iphone',
        platform: 'ios',
        apnsToken: 'apns-2',
      });
      await svc.revoke({ userId: 'u1', deviceId: 'iphone' });

      const result = await svc.listActive('u1');
      expect(result).toHaveLength(1);
      expect(result[0]?.deviceId).toBe('pixel');
    });
  });

  describe('factory', () => {
    it('createDeviceService returns instance', () => {
      expect(createDeviceService()).toBeInstanceOf(DeviceService);
    });
  });
});