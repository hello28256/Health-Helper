import { logger } from '../utils/logger';
import { env } from '../utils/env';
import type { DeviceTokenDto } from './deviceService';

/**
 * 推送 payload 标准结构 —— APNs 和 FCM 都接受类似的字段。
 * - title / body: 显示文案
 * - data: 自定义数据（mobile 端解析后跳路由）
 * - sound / badge: iOS 强提醒用
 */
export interface PushPayload {
  title: string;
  body: string;
  data?: Record<string, string>;
  sound?: string;
  badge?: number;
}

export interface ProviderSendResult {
  sent: number;
  failed: number;
}

/**
 * 推送 provider 抽象 —— 测试传 mock，生产用真实 apn/firebase-admin。
 * 真实实现见本文件末尾 createApnProvider / createFcmProvider。
 */
export interface PushProvider {
  sendBatch(tokens: string[], payload: PushPayload): Promise<{ sent: string[]; failed: Array<{ token: string; reason: string }> }>;
  shutdown?(): Promise<void>;
}

export interface PushServiceDeps {
  apnProvider: PushProvider | null;
  fcmProvider: PushProvider | null;
  logger?: (level: 'info' | 'warn' | 'error', message: string, ctx?: Record<string, unknown>) => void;
}

/**
 * PushService —— 推送编排层
 *
 * 设计要点：
 * - **Provider 抽象**：APNs 和 FCM 都通过 PushProvider 接口注入；
 *   测试用 mock，生产环境根据 .env 决定启不启用
 * - **按 platform 分发**：tokens 按 ios/android 分组，分别调对应 provider
 * - **永不抛**：provider 失败不抛错（不能让业务事务回滚），log 后继续
 * - **token rotation 兼容**：APNs 偶尔换 token，先 updateDeviceToken 再 push
 *
 * 业务钩子：
 * - notifyMoodTrend：mood 连续负向关怀（avg 7 天 score < 4 推送）
 * - notifyStepGoalHit：步数达标庆祝（>= 10000 推送）
 */
export class PushService {
  private readonly apnProvider: PushProvider | null;

  private readonly fcmProvider: PushProvider | null;

  private readonly log: NonNullable<PushServiceDeps['logger']>;

  constructor(deps: PushServiceDeps) {
    this.apnProvider = deps.apnProvider;
    this.fcmProvider = deps.fcmProvider;
    this.log =
      deps.logger ??
      ((level, message, ctx) => {
        if (level === 'error') logger.error(message, ctx);
        else if (level === 'warn') logger.warn(message, ctx);
        else logger.info(message, ctx);
      });
  }

  /**
   * 把 payload 推送到一组 token（已按 platform 分好）。
   * 单 provider 失败不影响另一个。
   */
  async pushToUser(tokens: DeviceTokenDto[], payload: PushPayload): Promise<ProviderSendResult> {
    if (tokens.length === 0) {
      return { sent: 0, failed: 0 };
    }

    const iosTokens = tokens.filter((t) => t.platform === 'ios' && t.apnsToken).map((t) => t.apnsToken!);
    const androidTokens = tokens
      .filter((t) => t.platform === 'android' && t.fcmToken)
      .map((t) => t.fcmToken!);
    const webTokens = tokens.filter((t) => t.platform === 'web' && t.fcmToken).map((t) => t.fcmToken!);

    let sent = 0;
    let failed = 0;

    if (this.apnProvider && iosTokens.length > 0) {
      try {
        const result = await this.apnProvider.sendBatch(iosTokens, payload);
        sent += result.sent.length;
        failed += result.failed.length;
        if (result.failed.length > 0) {
          this.log('warn', 'PushService APNs partial failure', {
            failed: result.failed.slice(0, 3),
          });
        }
      } catch (err) {
        this.log('error', 'PushService APNs send failed', {
          error: (err as Error).message,
          count: iosTokens.length,
        });
        failed += iosTokens.length;
      }
    }

    // Android 和 Web 都走 FCM
    const fcmTokens = [...androidTokens, ...webTokens];
    if (this.fcmProvider && fcmTokens.length > 0) {
      try {
        const result = await this.fcmProvider.sendBatch(fcmTokens, payload);
        sent += result.sent.length;
        failed += result.failed.length;
        if (result.failed.length > 0) {
          this.log('warn', 'PushService FCM partial failure', {
            failed: result.failed.slice(0, 3),
          });
        }
      } catch (err) {
        this.log('error', 'PushService FCM send failed', {
          error: (err as Error).message,
          count: fcmTokens.length,
        });
        failed += fcmTokens.length;
      }
    }

    return { sent, failed };
  }

  /**
   * 业务钩子：mood 连续负向关怀
   * 阈值：最近 7 天平均 score < 4 触发
   * 策略：D7 不做更复杂判定（连续 N 天 sad 主导），MVP 只用平均分
   */
  async notifyMoodTrend(args: {
    userId: string;
    tokens: DeviceTokenDto[];
    avgScore7d: number;
  }): Promise<void> {
    if (args.tokens.length === 0) return;
    if (args.avgScore7d >= 4) return; // 阈值之内不发

    await this.pushToUser(args.tokens, {
      title: '关心一下你 💙',
      body: '最近心情有点低落，要不要聊一聊？',
      data: { route: '/health/mood', reason: 'mood_negative_trend' },
    });
    this.log('info', 'PushService.notifyMoodTrend sent', {
      userId: args.userId,
      avgScore7d: args.avgScore7d,
    });
  }

  /**
   * 业务钩子：步数达标庆祝
   * 阈值：单日 steps >= 10000
   */
  async notifyStepGoalHit(args: {
    userId: string;
    tokens: DeviceTokenDto[];
    steps: number;
  }): Promise<void> {
    if (args.tokens.length === 0) return;
    if (args.steps < 10_000) return;

    await this.pushToUser(args.tokens, {
      title: '🎉 今日步数已达成！',
      body: `${args.steps.toLocaleString()} 步，继续保持！`,
      data: { route: '/dashboard', reason: 'step_goal_hit' },
    });
    this.log('info', 'PushService.notifyStepGoalHit sent', {
      userId: args.userId,
      steps: args.steps,
    });
  }

  /**
   * 关闭底层 provider（APNs 持久连接、FCM SDK 资源）。
   * 测试中可放心调用（mock 的 shutdown 是 no-op）。
   */
  async shutdown(): Promise<void> {
    if (this.apnProvider?.shutdown) {
      try {
        await this.apnProvider.shutdown();
      } catch (err) {
        this.log('warn', 'PushService APNs shutdown failed', { error: (err as Error).message });
      }
    }
  }
}

// ===== 真实 provider 工厂 =====

/**
 * 创建 APNs provider（基于 @parse/node-apn）。
 * 没配齐 key/keyId/teamId 时返回 null，调用方视作"推送已禁用"。
 */
async function createApnProvider(): Promise<PushProvider | null> {
  if (!env.APNS_KEY_ID || !env.APNS_TEAM_ID || !env.APNS_KEY_PATH) {
    logger.warn('PushService APNs disabled: missing APNS_KEY_ID/APNS_TEAM_ID/APNS_KEY_PATH');
    return null;
  }

  // 延迟 import：避免 firebase-admin 加载副作用影响 jest
  // eslint-disable-next-line @typescript-eslint/no-var-requires, @typescript-eslint/no-explicit-any
  const apn = require('@parse/node-apn') as any;

  const provider = new apn.Provider({
    token: {
      key: env.APNS_KEY_PATH,
      keyId: env.APNS_KEY_ID,
      teamId: env.APNS_TEAM_ID,
    },
    production: env.APNS_PRODUCTION,
  });

  return {
    async sendBatch(tokens, payload) {
      const notif = new apn.Notification({
        alert: { title: payload.title, body: payload.body },
        sound: payload.sound ?? 'default',
        badge: payload.badge,
        topic: env.APNS_BUNDLE_ID,
        payload: payload.data ?? {},
      });
      const result = await provider.send(notif, tokens);
      return {
        sent: result.sent.map((s: any) => s.device),
        failed: result.failed.map((f: any) => ({
          token: f.device ?? '',
          reason: f.response?.reason ?? f.error?.message ?? 'unknown',
        })),
      };
    },
    async shutdown() {
      await provider.shutdown();
    },
  };
}

/**
 * 创建 FCM provider（基于 firebase-admin）。
 * 没配 service account 时返回 null。
 */
async function createFcmProvider(): Promise<PushProvider | null> {
  if (!env.FCM_SERVICE_ACCOUNT_PATH) {
    logger.warn('PushService FCM disabled: missing FCM_SERVICE_ACCOUNT_PATH');
    return null;
  }

  // eslint-disable-next-line @typescript-eslint/no-var-requires, @typescript-eslint/no-explicit-any
  const admin = require('firebase-admin') as any;

  try {
    admin.initializeApp({
      credential: admin.credential.cert(env.FCM_SERVICE_ACCOUNT_PATH),
    });
  } catch (err) {
    logger.warn('PushService FCM initializeApp failed', { error: (err as Error).message });
    return null;
  }

  const messaging = admin.messaging();

  return {
    async sendBatch(tokens, payload) {
      const message = {
        tokens,
        notification: { title: payload.title, body: payload.body },
        data: payload.data ?? {},
      };
      try {
        const resp = await messaging.sendEachForMulticast(message);
        return {
          sent: resp.responses.filter((r: any) => r.success).map((_: any, i: number) => tokens[i]),
          failed: resp.responses
            .map((r: any, i: number) => (r.success ? null : { token: tokens[i], reason: r.error?.message ?? 'unknown' }))
            .filter((x: any) => x !== null),
        };
      } catch (err) {
        return {
          sent: [],
          failed: tokens.map((t) => ({ token: t, reason: (err as Error).message })),
        };
      }
    },
  };
}

/**
 * 工厂：创建 PushService（懒加载真实 provider）。
 * 没配 key 时 pushToUser 是 no-op（return { sent: 0, failed: 0 }）。
 */
let _singleton: PushService | null = null;

export function createPushService(): PushService {
  if (_singleton) return _singleton;

  // 同步创建空 provider 壳，异步补齐真实 provider（不影响构造）
  const svc = new PushService({ apnProvider: null, fcmProvider: null });

  void (async () => {
    const [apnProvider, fcmProvider] = await Promise.all([createApnProvider(), createFcmProvider()]);
    // 把真实 provider 注入到已构造的实例（通过替换内部字段）
    (svc as any).apnProvider = apnProvider;
    (svc as any).fcmProvider = fcmProvider;
    logger.info('PushService providers initialized', {
      apns: apnProvider !== null,
      fcm: fcmProvider !== null,
    });
  })();

  _singleton = svc;
  return svc;
}