import { Router, Request, Response, NextFunction } from 'express';
import { z } from 'zod';

import { requireAuth } from './middlewares/auth';
import { validateBody } from './middlewares/validate';
import { UnauthorizedError } from '../utils/errors';
import { createDeviceService, DEVICE_PLATFORMS } from '../services/deviceService';

const upsertDeviceSchema = z.object({
  deviceId: z.string().min(1).max(128),
  platform: z.enum(DEVICE_PLATFORMS as unknown as [string, ...string[]]),
  fcmToken: z.string().min(1).max(256).optional(),
  apnsToken: z.string().min(1).max(256).optional(),
  appVersion: z.string().min(1).max(32).optional(),
  locale: z.string().min(2).max(16).optional(),
});

/**
 * /api/devices —— 推送 token 注册（APNs / FCM）
 *
 * 路由：
 * - POST   /            注册/更新当前 device 的推送 token（idempotent：APNs 换 token 重复发也能覆盖）
 * - DELETE /:deviceId   撤销当前 device 的所有 token（幂等：mobile 端反复 revoke 不报错）
 *
 * 设计要点：
 * - 同一 (userId, deviceId, platform) 三元组唯一，token rotation 时走 update 而非 insert
 * - 至少要有一个 token（fcmToken 或 apnsToken 二选一），否则 service 层抛 400
 */
export function buildDevicesRouter(): Router {
  const router = Router();
  const deviceService = createDeviceService();

  router.use(requireAuth);

  router.post('/', validateBody(upsertDeviceSchema), async (req: Request, res: Response, next: NextFunction) => {
    try {
      if (!req.user) throw new UnauthorizedError();
      const token = await deviceService.upsertToken({
        userId: req.user.id,
        deviceId: req.body.deviceId,
        platform: req.body.platform as any,
        fcmToken: req.body.fcmToken ?? null,
        apnsToken: req.body.apnsToken ?? null,
        appVersion: req.body.appVersion ?? null,
        locale: req.body.locale ?? null,
      });
      res.json(token);
    } catch (err) {
      next(err);
    }
  });

  router.delete('/:deviceId', async (req: Request, res: Response, next: NextFunction) => {
    try {
      if (!req.user) throw new UnauthorizedError();
      await deviceService.revoke({
        userId: req.user.id,
        deviceId: req.params.deviceId,
      });
      // 幂等：找不到时也返 204，让 mobile 端反复调不出错
      res.status(204).send();
    } catch (err) {
      next(err);
    }
  });

  return router;
}
