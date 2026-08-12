// Jest 全局 setup：注入测试环境变量、设置 NODE_ENV=test
process.env.NODE_ENV = 'test';
process.env.DATABASE_URL =
  process.env.DATABASE_URL ?? 'postgresql://test:test@localhost:5432/test?schema=public';
process.env.JWT_ACCESS_SECRET = process.env.JWT_ACCESS_SECRET ?? 'test-access-secret-must-be-long';
process.env.JWT_REFRESH_SECRET = process.env.JWT_REFRESH_SECRET ?? 'test-refresh-secret-must-be-long';
// 测试时静默业务日志（CI 输出更干净）
process.env.LOG_LEVEL = 'error';
