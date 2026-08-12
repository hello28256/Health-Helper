import { env } from './env';

type Level = 'debug' | 'info' | 'warn' | 'error';

const levelPriority: Record<Level, number> = {
  debug: 0,
  info: 1,
  warn: 2,
  error: 3,
};

const minLevel = levelPriority[env.LOG_LEVEL];

function shouldLog(level: Level): boolean {
  return levelPriority[level] >= minLevel;
}

function format(level: Level, message: string, context?: Record<string, unknown>): string {
  const ts = new Date().toISOString();
  const prefix = `[${ts}] [${level.toUpperCase()}]`;
  const ctx = context ? ` ${JSON.stringify(context)}` : '';
  return `${prefix} ${message}${ctx}`;
}

export const logger = {
  debug(message: string, context?: Record<string, unknown>): void {
    if (shouldLog('debug')) {
      // eslint-disable-next-line no-console
      console.log(format('debug', message, context));
    }
  },
  info(message: string, context?: Record<string, unknown>): void {
    if (shouldLog('info')) {
      // eslint-disable-next-line no-console
      console.log(format('info', message, context));
    }
  },
  warn(message: string, context?: Record<string, unknown>): void {
    if (shouldLog('warn')) {
      // eslint-disable-next-line no-console
      console.warn(format('warn', message, context));
    }
  },
  error(message: string, context?: Record<string, unknown>): void {
    if (shouldLog('error')) {
      // eslint-disable-next-line no-console
      console.error(format('error', message, context));
    }
  },
};
