import request from 'supertest';
import { createApp } from '../src/api/app';

describe('GET /health', () => {
  const app = createApp();

  it('returns ok status', async () => {
    const res = await request(app).get('/health');
    expect(res.status).toBe(200);
    expect(res.body).toMatchObject({ status: 'ok' });
    expect(typeof res.body.ts).toBe('string');
  });
});

describe('GET /api', () => {
  const app = createApp();

  it('returns API metadata', async () => {
    const res = await request(app).get('/api');
    expect(res.status).toBe(200);
    expect(res.body.name).toBe('health-helper-api');
  });
});

describe('404 handler', () => {
  const app = createApp();

  it('returns structured 404 JSON', async () => {
    const res = await request(app).get('/api/does-not-exist');
    expect(res.status).toBe(404);
    expect(res.body.error.code).toBe('NOT_FOUND');
  });
});
