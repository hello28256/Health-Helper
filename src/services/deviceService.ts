import { prisma } from '../models/prisma';
import { NotFoundError, ValidationError } from '../utils/errors';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type PrismaLike = any;

/**
 * DevicePlatform —— 跟 Prisma 的 DevicePlatform 对齐。
 * 扩展时同步改 Prisma schema + openapi.ts。
 */
export const DEVICE_PLATFORMS = ['ios', 'android', 'web'] as const;
export type DevicePlatform = typeof DEVICE_PLATFORMS[number];

export interface UpsertDeviceTokenInput {
  userId: string;
  deviceId: string;
  platform: DevicePlatform;
  /** Android / Web 推送用 FCM */
  fcmToken?: string | null;
  /** iOS 推送用 APNs */
  apnsToken?: string | null;
  appVersion?: string | null;
  locale?: string | null;
}

export interface DeviceTokenDto {
  id: string;
  userId: string;
  deviceId: string;
  platform: string;
  fcmToken: string | null;
  apnsToken: string | null;
  appVersion: string | null;
  locale: string | null;
  createdAt: Date;
  lastSeenAt: Date;
  revokedAt: Date | null;
}

export interface RevokeDeviceInput {
  userId: string;
  deviceId: string;
}

/**
 * DeviceService —— 推送 token 注册（APNs / FCM）
 *
 * 设计要点：
 * - **按 (userId, deviceId, platform) upsert**：同一端 token 轮转时更新 lastSeenAt；
 *   token rotation（APNs 偶尔换 token）只需更新 fcmToken/apnsToken 字段
 * - **多端独立**：同一用户多个端各有自己的 token，分别推送
 * - **revoke 幂等**：再 revoke 一次返回 0，不抛错
 * - **只列 active**：listActive 自动过滤 revokedAt != null 的
 * - **不调用推送**：deviceService 只管 token 持久化；发送走 pushService
 */
export class DeviceService {
  constructor(private readonly prisma: PrismaLike) {}

  /**
   * 注册/更新推送 token。
   * - deviceId 空 → 400
   * - fcmToken + apnsToken 都为空 → 400（用户至少要推一个平台）
   */
  async upsertToken(input: UpsertDeviceTokenInput): Promise<DeviceTokenDto> {
    if (!input.deviceId || input.deviceId.length === 0) {
      throw new ValidationError('deviceId must not be empty');
    }
    if (!input.fcmToken && !input.apnsToken) {
      throw new ValidationError('either fcmToken or apnsToken must be provided');
    }
    if (!DEVICE_PLATFORMS.includes(input.platform as DevicePlatform)) {
      throw new ValidationError(`platform must be one of: ${DEVICE_PLATFORMS.join(', ')}`, {
        platform: input.platform,
      });
    }

    const row = await this.prisma.deviceToken.upsert({
      where: {
        userId_deviceId_platform: {
          userId: input.userId,
          deviceId: input.deviceId,
          platform: input.platform,
        },
      },
      create: {
        userId: input.userId,
        deviceId: input.deviceId,
        platform: input.platform,
        fcmToken: input.fcmToken ?? null,
        apnsToken: input.apnsToken ?? null,
        appVersion: input.appVersion ?? null,
        locale: input.locale ?? null,
      },
      update: {
        fcmToken: input.fcmToken ?? null,
        apnsToken: input.apnsToken ?? null,
        appVersion: input.appVersion ?? null,
        locale: input.locale ?? null,
        lastSeenAt: new Date(),
      },
    });

    return this.toDto(row);
  }

  /**
   * 撤销某 (userId, deviceId) 的所有 token。
   * 幂等：找不到活跃 token 时返回 0 而不抛错（mobile 端 token rotation 时反复 revoke 不报错）。
   */
  async revoke(input: RevokeDeviceInput): Promise<number> {
    const result = await this.prisma.deviceToken.updateMany({
      where: {
        userId: input.userId,
        deviceId: input.deviceId,
        revokedAt: null,
      },
      data: { revokedAt: new Date() },
    });
    return result.count;
  }

  /**
   * 列某用户所有未撤销的 token。
   * 推送时由 pushService 调用。
   */
  async listActive(userId: string): Promise<DeviceTokenDto[]> {
    const rows = await this.prisma.deviceToken.findMany({
      where: { userId, revokedAt: null },
      orderBy: { lastSeenAt: 'desc' },
    });
    return rows.map((r: any) => this.toDto(r));
  }

  // eslint-disable-next-line class-methods-use-this
  private toDto(r: any): DeviceTokenDto {
    return {
      id: r.id,
      userId: r.userId,
      deviceId: r.deviceId,
      platform: r.platform,
      fcmToken: r.fcmToken ?? null,
      apnsToken: r.apnsToken ?? null,
      appVersion: r.appVersion ?? null,
      locale: r.locale ?? null,
      createdAt: r.createdAt,
      lastSeenAt: r.lastSeenAt,
      revokedAt: r.revokedAt ?? null,
    };
  }
}

// ===== Factory =====

export function createDeviceService(): DeviceService {
  return new DeviceService(prisma);
}