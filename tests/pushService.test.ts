// PushService 单元测试
// TDD：先写测试，再写实现

import { PushService, createPushService } from '../src/services/pushService';
import type { DeviceTokenDto } from '../src/services/deviceService';

// ===== 测试用 mock providers =====
//
// provider 接口：sendBatch(tokens, payload) → Promise<{ sent: string[]; failed: Array<{ token: string; reason: string }> }>

// eslint-disable-next-line @typescript-eslint/no-explicit-any
function makeToken(overrides: Partial<DeviceTokenDto> = {}): DeviceTokenDto {
  return {
    id: 'dt_1',
    userId: 'u1',
    deviceId: 'd1',
    platform: 'ios',
    fcmToken: null,
    apnsToken: 'apns-xxx',
    appVersion: '1.0.0',
    locale: 'zh-CN',
    createdAt: new Date(),
    lastSeenAt: new Date(),
    revokedAt: null,
    ...overrides,
  };
}

describe('PushService', () => {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  let apnProvider: any;
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  let fcmProvider: any;
  let svc: PushService;

  beforeEach(() => {
    apnProvider = {
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      sendBatch: jest.fn(async (tokens: string[], _payload: any) => ({
        sent: tokens,
        failed: [],
      })),
      shutdown: jest.fn(),
    };
    fcmProvider = {
      sendBatch: jest.fn(async (tokens: string[], _payload: any) => ({
        sent: tokens,
        failed: [],
      })),
    };
    svc = new PushService({ apnProvider, fcmProvider, logger: () => undefined });
  });

  describe('pushToUser', () => {
    it('groups tokens by platform and calls each provider once', async () => {
      const tokens: DeviceTokenDto[] = [
        makeToken({ platform: 'ios', apnsToken: 'a1' }),
        makeToken({ platform: 'ios', apnsToken: 'a2' }),
        makeToken({ platform: 'android', fcmToken: 'f1' }),
      ];
      const payload = { title: 'hi', body: 'hello', data: { route: '/dashboard' } };

      const result = await svc.pushToUser(tokens, payload);

      expect(apnProvider.sendBatch).toHaveBeenCalledTimes(1);
      expect(apnProvider.sendBatch).toHaveBeenCalledWith(['a1', 'a2'], payload);
      expect(fcmProvider.sendBatch).toHaveBeenCalledTimes(1);
      expect(fcmProvider.sendBatch).toHaveBeenCalledWith(['f1'], payload);
      expect(result).toEqual({ sent: 3, failed: 0 });
    });

    it('skips empty groups (no provider called for empty list)', async () => {
      const tokens: DeviceTokenDto[] = [makeToken({ platform: 'ios', apnsToken: 'a1' })];
      await svc.pushToUser(tokens, { title: 't', body: 'b' });
      expect(fcmProvider.sendBatch).not.toHaveBeenCalled();
    });

    it('skips tokens with no platform token (fcm/apns both null)', async () => {
      const tokens: DeviceTokenDto[] = [
        makeToken({ platform: 'ios', apnsToken: null, fcmToken: null }),
      ];
      const result = await svc.pushToUser(tokens, { title: 't', body: 'b' });
      expect(apnProvider.sendBatch).not.toHaveBeenCalled();
      expect(result.sent).toBe(0);
    });

    it('aggregates sent/failed across providers', async () => {
      apnProvider.sendBatch.mockResolvedValueOnce({ sent: ['a1'], failed: [] });
      fcmProvider.sendBatch.mockResolvedValueOnce({
        sent: [],
        failed: [{ token: 'f1', reason: 'Unregistered' }],
      });
      const tokens: DeviceTokenDto[] = [
        makeToken({ platform: 'ios', apnsToken: 'a1' }),
        makeToken({ platform: 'android', fcmToken: 'f1' }),
      ];
      const result = await svc.pushToUser(tokens, { title: 't', body: 'b' });
      expect(result).toEqual({ sent: 1, failed: 1 });
    });

    it('returns empty result for empty input', async () => {
      const result = await svc.pushToUser([], { title: 't', body: 'b' });
      expect(result).toEqual({ sent: 0, failed: 0 });
      expect(apnProvider.sendBatch).not.toHaveBeenCalled();
      expect(fcmProvider.sendBatch).not.toHaveBeenCalled();
    });
  });

  describe('notifyMoodTrend (business hook)', () => {
    it('triggers pushToUser with caring message when score threshold breached', async () => {
      await svc.notifyMoodTrend({
        userId: 'u1',
        tokens: [makeToken()],
        avgScore7d: 3.2,
      });
      expect(apnProvider.sendBatch).toHaveBeenCalledTimes(1);
      const [_tokens, payload] = apnProvider.sendBatch.mock.calls[0];
      expect(payload.title).toContain('关心');
      expect(payload.data).toMatchObject({ route: '/health/mood' });
    });

    it('skips push when avgScore7d >= 4 (wellness threshold)', async () => {
      await svc.notifyMoodTrend({
        userId: 'u1',
        tokens: [makeToken()],
        avgScore7d: 5.0,
      });
      expect(apnProvider.sendBatch).not.toHaveBeenCalled();
    });

    it('skips push when no tokens', async () => {
      await svc.notifyMoodTrend({ userId: 'u1', tokens: [], avgScore7d: 3.0 });
      expect(apnProvider.sendBatch).not.toHaveBeenCalled();
    });
  });

  describe('notifyStepGoalHit (business hook)', () => {
    it('celebrates when steps >= 10000', async () => {
      await svc.notifyStepGoalHit({
        userId: 'u1',
        tokens: [makeToken({ platform: 'android', fcmToken: 'f1', apnsToken: null })],
        steps: 10500,
      });
      expect(fcmProvider.sendBatch).toHaveBeenCalledTimes(1);
      const [_tokens, payload] = fcmProvider.sendBatch.mock.calls[0];
      expect(payload.title).toContain('达成');
      expect(payload.body).toMatch(/10[,]?500/);
    });

    it('does not push when steps < 10000', async () => {
      await svc.notifyStepGoalHit({
        userId: 'u1',
        tokens: [makeToken()],
        steps: 8000,
      });
      expect(apnProvider.sendBatch).not.toHaveBeenCalled();
    });
  });

  describe('shutdown', () => {
    it('closes APNs provider', async () => {
      await svc.shutdown();
      expect(apnProvider.shutdown).toHaveBeenCalled();
    });

    it('is a no-op when apnProvider has no shutdown method', async () => {
      const minimalSvc = new PushService({
        apnProvider: { sendBatch: jest.fn() },
        fcmProvider: { sendBatch: jest.fn() },
      });
      await expect(minimalSvc.shutdown()).resolves.toBeUndefined();
    });
  });

  describe('factory (real provider bootstrap)', () => {
    it('createPushService returns instance (provider may be no-op if no keys)', () => {
      const real = createPushService();
      expect(real).toBeInstanceOf(PushService);
    });
  });
});