import { createApp } from './api/app';
import { env } from './utils/env';
import { logger } from './utils/logger';
import { disconnectPrisma, prisma } from './models/prisma';

async function bootstrap(): Promise<void> {
  // 启动前检查数据库连通性
  try {
    await prisma.$connect();
    logger.info('Database connected');
  } catch (error) {
    logger.error('Database connection failed', {
      message: error instanceof Error ? error.message : String(error),
    });
    process.exit(1);
  }

  const app = createApp();
  const server = app.listen(env.PORT, () => {
    logger.info(`API server listening`, { port: env.PORT, env: env.NODE_ENV });
  });

  // ===== 优雅关闭 =====
  const shutdown = async (signal: string): Promise<void> => {
    logger.info(`Received ${signal}, shutting down gracefully`);
    server.close(() => {
      logger.info('HTTP server closed');
    });
    await disconnectPrisma();
    process.exit(0);
  };

  process.on('SIGINT', () => void shutdown('SIGINT'));
  process.on('SIGTERM', () => void shutdown('SIGTERM'));
  process.on('unhandledRejection', (reason) => {
    logger.error('Unhandled rejection', { reason: String(reason) });
  });
  process.on('uncaughtException', (error) => {
    logger.error('Uncaught exception', { message: error.message, stack: error.stack });
    process.exit(1);
  });
}

void bootstrap();
