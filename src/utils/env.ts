import dotenv from 'dotenv';
import { z } from 'zod';

dotenv.config();

const envSchema = z.object({
  NODE_ENV: z.enum(['development', 'production', 'test']).default('development'),
  PORT: z.coerce.number().int().positive().default(3000),
  DATABASE_URL: z.string().url(),
  JWT_ACCESS_SECRET: z.string().min(16),
  JWT_REFRESH_SECRET: z.string().min(16),
  JWT_ACCESS_TTL: z.string().default('15m'),
  JWT_REFRESH_TTL: z.string().default('7d'),
  BCRYPT_ROUNDS: z.coerce.number().int().min(8).max(15).default(12),
  CORS_ORIGINS: z.string().default(''),
  ANTHROPIC_API_KEY: z.string().optional(),
  ANTHROPIC_MODEL: z.string().default('claude-sonnet-5'),
  OPENAI_API_KEY: z.string().optional(),
  OPENAI_MODEL: z.string().default('gpt-4o'),
  RATE_LIMIT_WINDOW_MS: z.coerce.number().int().positive().default(60000),
  RATE_LIMIT_MAX_REQUESTS: z.coerce.number().int().positive().default(100),
  LOG_LEVEL: z.enum(['debug', 'info', 'warn', 'error']).default('info'),
  // APNs (iOS push)
  APNS_KEY_ID: z.string().optional(),
  APNS_TEAM_ID: z.string().optional(),
  APNS_KEY_PATH: z.string().optional(),
  APNS_BUNDLE_ID: z.string().default('com.healthhelper.app'),
  APNS_PRODUCTION: z
    .union([z.boolean(), z.enum(['true', 'false'])])
    .transform((v) => v === true || v === 'true')
    .default(false),
  // FCM (Android / Web push)
  FCM_SERVICE_ACCOUNT_PATH: z.string().optional(),
});

const parsed = envSchema.safeParse(process.env);

if (!parsed.success) {
  // 启动期错误：直接打日志退出，不抛 Error 链路以免被 logger 吞掉
  // eslint-disable-next-line no-console
  console.error('[DEBUG] Invalid environment variables:', parsed.error.flatten().fieldErrors);
  process.exit(1);
}

export const env = parsed.data;

export const corsOrigins = env.CORS_ORIGINS.split(',')
  .map((o) => o.trim())
  .filter(Boolean);

export const aiConfig = {
  anthropic: {
    apiKey: env.ANTHROPIC_API_KEY ?? '',
    model: env.ANTHROPIC_MODEL,
    enabled: Boolean(env.ANTHROPIC_API_KEY),
  },
  openai: {
    apiKey: env.OPENAI_API_KEY ?? '',
    model: env.OPENAI_MODEL,
    enabled: Boolean(env.OPENAI_API_KEY),
  },
};
