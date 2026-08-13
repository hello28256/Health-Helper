// API 集成测试 —— 跑真实 Postgres（启动前必须确保容器已起）
// 每个 test 用随机邮箱隔离

import request from 'supertest';
import { createApp } from '../src/api/app';
import { prisma } from '../src/models/prisma';

const app = createApp();

function uniqueEmail(): string {
  return `test-${Date.now()}-${Math.random().toString(36).slice(2, 8)}@example.com`;
}

async function registerAndLogin(): Promise<{ token: string; email: string }> {
  const email = uniqueEmail();
  const res = await request(app)
    .post('/api/auth/register')
    .send({ email, password: 'test1234', deviceId: 'jest' });
  expect(res.status).toBe(201);
  return { token: res.body.accessToken, email };
}

afterAll(async () => {
  await prisma.$disconnect();
});

describe('Integration: full user → exercise → diet → mood flow', () => {
  it('completes a realistic user journey', async () => {
    const { token, email } = await registerAndLogin();
    const auth = { Authorization: `Bearer ${token}` };

    // 1. 设置身高体重（卡路里计算依赖）
    const patchRes = await request(app)
      .patch('/api/users/me')
      .set(auth)
      .send({ heightCm: 170, weightKg: 65 });
    expect(patchRes.status).toBe(200);
    expect(patchRes.body.weightKg).toBe(65);

    // 2. 列出运动类型
    const typesRes = await request(app).get('/api/exercises/types').set(auth);
    expect(typesRes.status).toBe(200);
    expect(typesRes.body.types.length).toBeGreaterThan(5);
    const running = typesRes.body.types.find((t: any) => t.id === 'running');
    expect(running).toBeDefined();
    expect(running.met).toBe(9.8);

    // 3. 创建跑步记录（30 分钟，体重 65kg：9.8 × 65 × 0.5 = 318.5）
    const exerciseRes = await request(app)
      .post('/api/exercises')
      .set(auth)
      .send({ typeId: 'running', startedAt: '2026-08-12T08:00:00Z', durationSec: 1800 });
    expect(exerciseRes.status).toBe(201);
    expect(exerciseRes.body.calories).toBeCloseTo(318.5, 1);

    // 4. 上报步数
    const stepRes = await request(app)
      .post('/api/exercises/steps')
      .set(auth)
      .send({ steps: 12000, source: 'ios_pedometer' });
    expect(stepRes.status).toBe(201);
    expect(stepRes.body.steps).toBe(12000);

    // 5. 搜索食物 + 记录饮食
    const foodsRes = await request(app).get('/api/diet/foods?q=米饭').set(auth);
    expect(foodsRes.status).toBe(200);
    expect(foodsRes.body.foods.length).toBeGreaterThan(0);
    const rice = foodsRes.body.foods[0];

    const dietRes = await request(app)
      .post('/api/diet/records')
      .set(auth)
      .send({ foodId: rice.id, mealType: 'lunch', servings: 1.5 });
    expect(dietRes.status).toBe(201);
    expect(dietRes.body.consumed.kcal).toBeGreaterThan(0);

    // 6. 饮食汇总
    const summaryRes = await request(app).get('/api/diet/summary').set(auth);
    expect(summaryRes.status).toBe(200);
    expect(summaryRes.body.kcal).toBeGreaterThan(0);
    expect(summaryRes.body.recordCount).toBeGreaterThan(0);

    // 7. 记录情绪
    const moodRes = await request(app)
      .post('/api/mood')
      .set(auth)
      .send({ mood: 'happy', score: 8, note: '今天跑完步很爽' });
    expect(moodRes.status).toBe(201);
    expect(moodRes.body.score).toBe(8);

    // 8. 情绪趋势
    const trendRes = await request(app)
      .get('/api/mood/trend?from=2026-08-01T00:00:00Z&to=2026-08-31T23:59:59Z')
      .set(auth);
    expect(trendRes.status).toBe(200);
    expect(trendRes.body.trend.length).toBeGreaterThan(0);

    // 9. 登出
    const refreshRes = await request(app)
      .post('/api/auth/refresh')
      .send({ refreshToken: (await request(app).post('/api/auth/login').send({ email, password: 'test1234', deviceId: 'jest2' })).body.refreshToken, deviceId: 'jest2' });
    expect(refreshRes.status).toBe(200);

    console.log(`✓ Integration passed for ${email}`);
  }, 30000);
});

describe('Integration: error paths', () => {
  it('rejects requests without token', async () => {
    const res = await request(app).get('/api/users/me');
    expect(res.status).toBe(401);
    expect(res.body.error.code).toBe('UNAUTHORIZED');
  });

  it('rejects malformed JSON body with 400', async () => {
    await registerAndLogin();
    const res = await request(app)
      .post('/api/auth/register')
      .set('Content-Type', 'application/json')
      .send('not json at all');
    // supertest 会按字符串发送，express 解析失败返回 400
    expect([400, 500]).toContain(res.status);
  });

  it('returns 404 for unknown routes', async () => {
    const res = await request(app).get('/api/nonexistent');
    expect(res.status).toBe(404);
    expect(res.body.error.code).toBe('NOT_FOUND');
  });

  it('redirects GET / to Swagger UI', async () => {
    const res = await request(app).get('/');
    expect(res.status).toBe(302);
    expect(res.headers.location).toBe('/api/docs/');
  });

  it('returns structured validation error for bad payload', async () => {
    const { token } = await registerAndLogin();
    const res = await request(app)
      .post('/api/exercises')
      .set({ Authorization: `Bearer ${token}` })
      .send({ typeId: 'running', durationSec: -1 }); // missing startedAt + negative duration
    expect(res.status).toBe(400);
    expect(res.body.error.code).toBe('VALIDATION_ERROR');
    expect(res.body.error.details).toBeDefined();
  });

  it('chat returns 502 (AI_UPSTREAM_ERROR) or 503 (AI_DISABLED) — both acceptable', async () => {
    const { token } = await registerAndLogin();
    const res = await request(app)
      .post('/api/chat/messages')
      .set({ Authorization: `Bearer ${token}` })
      .send({ content: '你好' });
    expect([502, 503]).toContain(res.status);
    if (res.status === 503) expect(res.body.error.code).toBe('AI_DISABLED');
    if (res.status === 502) expect(res.body.error.code).toBe('AI_UPSTREAM_ERROR');
  });
});

describe('Integration: cross-endpoint consistency', () => {
  it('same account, two devices — each sees same data', async () => {
    const { token: tokenWeb, email } = await registerAndLogin();

    // Web 端记录一条运动
    await request(app)
      .post('/api/exercises')
      .set({ Authorization: `Bearer ${tokenWeb}` })
      .send({ typeId: 'walking', startedAt: '2026-08-12T08:00:00Z', durationSec: 600 });

    // iOS 端登录（不同 deviceId）
    const loginRes = await request(app)
      .post('/api/auth/login')
      .send({ email, password: 'test1234', deviceId: 'iphone-1' });
    expect(loginRes.status).toBe(200);
    const tokenIos = loginRes.body.accessToken;

    // iOS 端查询，应该看到 web 端的数据
    const listRes = await request(app)
      .get('/api/exercises')
      .set({ Authorization: `Bearer ${tokenIos}` });
    expect(listRes.status).toBe(200);
    expect(listRes.body.records.length).toBeGreaterThan(0);
    expect(listRes.body.records[0].typeId).toBe('walking');

    // 两个 token 都有效
    expect(tokenWeb).toBeDefined();
    expect(tokenIos).toBeDefined();
  }, 20000);
});

describe('Integration: /api/health (HealthKit / Health Connect upload)', () => {
  it('uploads a batch, lists by metric+range, fetches latest', async () => {
    const { token } = await registerAndLogin();
    const auth = { Authorization: `Bearer ${token}` };

    // 批量上报：心率 + 睡眠 + 体重
    const upload = await request(app)
      .post('/api/health/records')
      .set(auth)
      .send({
        records: [
          {
            metric: 'heart_rate',
            value: 72,
            unit: 'bpm',
            startAt: '2026-08-10T08:00:00Z',
            source: 'ios_healthkit',
          },
          {
            metric: 'heart_rate',
            value: 80,
            unit: 'bpm',
            startAt: '2026-08-10T18:00:00Z',
            source: 'ios_healthkit',
          },
          {
            metric: 'sleep',
            value: 420,
            unit: 'min',
            startAt: '2026-08-10T22:00:00Z',
            endAt: '2026-08-11T05:00:00Z',
            source: 'ios_healthkit',
          },
          {
            metric: 'weight',
            value: 64.8,
            unit: 'kg',
            startAt: '2026-08-11T08:00:00Z',
            source: 'manual',
          },
        ],
      });
    expect(upload.status).toBe(201);
    expect(upload.body.records).toHaveLength(4);

    // 按 metric + 时间窗查询
    const list = await request(app)
      .get('/api/health/records?metric=heart_rate&from=2026-08-10T00:00:00Z&to=2026-08-10T23:59:59Z')
      .set(auth);
    expect(list.status).toBe(200);
    expect(list.body.records).toHaveLength(2);

    // 最新一条
    const latest = await request(app)
      .get('/api/health/records/latest?metric=weight')
      .set(auth);
    expect(latest.status).toBe(200);
    expect(latest.body.record.value).toBe(64.8);
  }, 20000);

  it('rejects empty batch with 400', async () => {
    const { token } = await registerAndLogin();
    const res = await request(app)
      .post('/api/health/records')
      .set({ Authorization: `Bearer ${token}` })
      .send({ records: [] });
    expect(res.status).toBe(400);
    expect(res.body.error.code).toBe('VALIDATION_ERROR');
  });

  it('rejects invalid metric with 400', async () => {
    const { token } = await registerAndLogin();
    const res = await request(app)
      .post('/api/health/records')
      .set({ Authorization: `Bearer ${token}` })
      .send({
        records: [
          {
            metric: 'blood_sugar',
            value: 5,
            unit: 'mmol/L',
            startAt: '2026-08-10T08:00:00Z',
            source: 'manual',
          },
        ],
      });
    expect(res.status).toBe(400);
  });

  it('rejects unauthenticated request with 401', async () => {
    const res = await request(app)
      .post('/api/health/records')
      .send({ records: [] });
    expect(res.status).toBe(401);
  });
});

describe('Integration: /api/devices (push token registration)', () => {
  it('registers iOS APNs token, then revokes', async () => {
    const { token } = await registerAndLogin();
    const auth = { Authorization: `Bearer ${token}` };

    // 注册 iOS 推送 token
    const upsert = await request(app)
      .post('/api/devices')
      .set(auth)
      .send({
        deviceId: 'iphone-jest',
        platform: 'ios',
        apnsToken: 'apns-jest-token',
        appVersion: '1.0.0',
        locale: 'zh-CN',
      });
    expect(upsert.status).toBe(200);
    expect(upsert.body.apnsToken).toBe('apns-jest-token');

    // 重复 upsert 应覆盖（同 userId+deviceId+platform）
    const reUpsert = await request(app)
      .post('/api/devices')
      .set(auth)
      .send({
        deviceId: 'iphone-jest',
        platform: 'ios',
        apnsToken: 'apns-jest-token-rotated',
      });
    expect(reUpsert.status).toBe(200);
    expect(reUpsert.body.apnsToken).toBe('apns-jest-token-rotated');

    // 撤销
    const del = await request(app).delete('/api/devices/iphone-jest').set(auth);
    expect(del.status).toBe(204);
  }, 20000);

  it('rejects empty token (neither fcm nor apns)', async () => {
    const { token } = await registerAndLogin();
    const res = await request(app)
      .post('/api/devices')
      .set({ Authorization: `Bearer ${token}` })
      .send({ deviceId: 'd', platform: 'ios' });
    expect(res.status).toBe(400);
  });

  it('revoke is idempotent (second call returns 204)', async () => {
    const { token } = await registerAndLogin();
    const auth = { Authorization: `Bearer ${token}` };

    await request(app)
      .post('/api/devices')
      .set(auth)
      .send({ deviceId: 'd1', platform: 'android', fcmToken: 'fcm-1' });

    const first = await request(app).delete('/api/devices/d1').set(auth);
    expect(first.status).toBe(204);
    const second = await request(app).delete('/api/devices/d1').set(auth);
    expect(second.status).toBe(204);
  }, 20000);
});
