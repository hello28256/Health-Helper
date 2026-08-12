import { PrismaClient } from '@prisma/client';
import { logger } from '../utils/logger';

// 单例 Prisma client（开发热重载时避免连接数爆炸）
const globalForPrisma = globalThis as unknown as { prisma?: PrismaClient };

export const prisma =
  globalForPrisma.prisma ??
  new PrismaClient({
    log: [
      { emit: 'event', level: 'query' },
      { emit: 'event', level: 'error' },
      { emit: 'event', level: 'warn' },
    ],
  });

if (env_isDevelopment()) {
  globalForPrisma.prisma = prisma;
}

function env_isDevelopment(): boolean {
  return process.env.NODE_ENV === 'development';
}

prisma.$on('error', (e) => {
  logger.error('Prisma error', { message: e.message, target: e.target });
});

prisma.$on('warn', (e) => {
  logger.warn('Prisma warn', { message: e.message });
});

export async function disconnectPrisma(): Promise<void> {
  await prisma.$disconnect();
}
