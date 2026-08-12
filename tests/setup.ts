// Jest 全局 setup：注入测试环境变量、设置 NODE_ENV=test
// 集成测试需要真实 DB，所以优先用开发 .env 的 DATABASE_URL，再退到 test 占位
import * as fs from 'fs';
import * as path from 'path';

function loadDotEnv(): void {
  // 不引 dotenv 依赖，手写一个最小解析；只补 .env 里缺的 key，不覆盖已有 shell 环境
  const envPath = path.resolve(__dirname, '..', '.env');
  if (!fs.existsSync(envPath)) return;
  const content = fs.readFileSync(envPath, 'utf8');
  for (const line of content.split(/\r?\n/)) {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith('#')) continue;
    const eq = trimmed.indexOf('=');
    if (eq <= 0) continue;
    const key = trimmed.slice(0, eq).trim();
    let value = trimmed.slice(eq + 1).trim();
    if ((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'"))) {
      value = value.slice(1, -1);
    }
    if (process.env[key] === undefined) process.env[key] = value;
  }
}

loadDotEnv();

process.env.NODE_ENV = 'test';
// 集成测试需要真实 DB；只有当 .env 也没提供时才退到占位
if (!process.env.DATABASE_URL) {
  process.env.DATABASE_URL = 'postgresql://test:test@localhost:5432/test?schema=public';
}
process.env.JWT_ACCESS_SECRET = process.env.JWT_ACCESS_SECRET ?? 'test-access-secret-must-be-long';
process.env.JWT_REFRESH_SECRET = process.env.JWT_REFRESH_SECRET ?? 'test-refresh-secret-must-be-long';
// 测试时静默业务日志（CI 输出更干净）
process.env.LOG_LEVEL = 'error';
// 集成测试禁用 AI 实时调用（shell 环境里如果误设了真 key 会触发 HTTP 请求导致超时）
delete process.env.ANTHROPIC_API_KEY;
delete process.env.OPENAI_API_KEY;
