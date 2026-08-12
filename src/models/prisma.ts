import { PrismaClient, Prisma } from '@prisma/client';
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

if (process.env.NODE_ENV === 'development') {
  globalForPrisma.prisma = prisma;
}

prisma.$on('error' as never, (event: Prisma.LogEvent) => {
  logger.error('Prisma error', { message: event.message, target: event.target });
});

prisma.$on('warn' as never, (event: Prisma.LogEvent) => {
  logger.warn('Prisma warn', { message: event.message });
});

export async function disconnectPrisma(): Promise<void> {
  await prisma.$disconnect();
}
