// ChatService 单元测试

import { ChatService, MEDICAL_DISCLAIMER } from '../src/services/chatService';
import { ValidationError, AppError } from '../src/utils/errors';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
function createPrismaMock() {
  const chatLogs: any[] = [];

  return {
    chatLog: {
      create: async ({ data }: any) => {
        const log = {
          id: `chat_${chatLogs.length + 1}`,
          createdAt: new Date(Date.now() + chatLogs.length), // 模拟递增时间戳
          ...data,
        };
        chatLogs.push(log);
        return log;
      },
      findMany: async ({ where, orderBy, take }: any) => {
        let rows = chatLogs.filter((l) => l.userId === where.userId);
        if (orderBy?.createdAt === 'desc') rows.sort((a, b) => b.createdAt.getTime() - a.createdAt.getTime());
        if (orderBy?.createdAt === 'asc') rows.sort((a, b) => a.createdAt.getTime() - b.createdAt.getTime());
        if (take) rows = rows.slice(0, take); // take = limit from start of sorted array
        return rows;
      },
    },
    __chatLogs: chatLogs,
  };
}

function createMockProvider(response = '我理解你的感受，建议你尝试深呼吸放松。') {
  return {
    enabled: true,
    name: 'mock',
    sendMessage: jest.fn(async () => ({
      content: response,
      model: 'mock-model',
      usage: { inputTokens: 10, outputTokens: 20 },
    })),
  };
}

describe('ChatService.sendMessage', () => {
  it('saves user message, calls provider, saves assistant reply', async () => {
    const prisma = createPrismaMock();
    const provider = createMockProvider('深呼吸有助放松。');
    const svc = new ChatService(prisma as any, provider as any);

    const result = await svc.sendMessage({
      userId: 'u1',
      content: '我今天感觉很焦虑',
    });

    expect(result.userMessage.role).toBe('user');
    expect(result.userMessage.content).toBe('我今天感觉很焦虑');
    expect(result.assistantMessage.role).toBe('assistant');
    expect(result.assistantMessage.content).toBe('深呼吸有助放松。');
    expect(provider.sendMessage).toHaveBeenCalledTimes(1);
    expect(prisma.__chatLogs.length).toBe(2);
  });

  it('prepends medical disclaimer to system prompt', async () => {
    const prisma = createPrismaMock();
    const provider = createMockProvider();
    const svc = new ChatService(prisma as any, provider as any);

    await svc.sendMessage({ userId: 'u1', content: 'hi' });

    const call = (provider.sendMessage as jest.Mock).mock.calls[0][0];
    expect(call.systemPrompt).toContain(MEDICAL_DISCLAIMER);
  });

  it('rejects empty message', async () => {
    const prisma = createPrismaMock();
    const provider = createMockProvider();
    const svc = new ChatService(prisma as any, provider as any);

    await expect(svc.sendMessage({ userId: 'u1', content: '' })).rejects.toBeInstanceOf(ValidationError);
    await expect(svc.sendMessage({ userId: 'u1', content: '   ' })).rejects.toBeInstanceOf(ValidationError);
  });

  it('rejects too-long message', async () => {
    const prisma = createPrismaMock();
    const provider = createMockProvider();
    const svc = new ChatService(prisma as any, provider as any);

    await expect(
      svc.sendMessage({ userId: 'u1', content: 'x'.repeat(4001) }),
    ).rejects.toBeInstanceOf(ValidationError);
  });

  it('throws AppError when provider is disabled', async () => {
    const prisma = createPrismaMock();
    const provider = { enabled: false, name: 'mock', sendMessage: jest.fn() };
    const svc = new ChatService(prisma as any, provider as any);

    await expect(svc.sendMessage({ userId: 'u1', content: 'hi' })).rejects.toBeInstanceOf(AppError);
  });

  it('passes recent history to provider', async () => {
    const prisma = createPrismaMock();
    const provider = createMockProvider();
    const svc = new ChatService(prisma as any, provider as any);

    // 预存 3 条历史
    await svc.sendMessage({ userId: 'u1', content: 'msg1' });
    await svc.sendMessage({ userId: 'u1', content: 'msg2' });
    await svc.sendMessage({ userId: 'u1', content: 'msg3' });

    const call = (provider.sendMessage as jest.Mock).mock.calls[2][0];
    // 第 3 次调用应传 5 条消息：user/assistant/user/assistant/user(当前)
    expect(call.messages.length).toBe(5);
    expect(call.messages[call.messages.length - 1].content).toBe('msg3');
  });
});

describe('ChatService.history', () => {
  it('returns chat logs newest first', async () => {
    const prisma = createPrismaMock();
    const provider = createMockProvider();
    const svc = new ChatService(prisma as any, provider as any);

    await svc.sendMessage({ userId: 'u1', content: 'first' });
    await svc.sendMessage({ userId: 'u1', content: 'second' });

    const history = await svc.history({ userId: 'u1', limit: 50 });
    expect(history.length).toBe(4);
    // 最新的是 second 的 assistant 回复（mock 都返回同一文本）
    expect(history[0].role).toBe('assistant');
    // 第二新是 second 的 user message
    expect(history[1].role).toBe('user');
    expect(history[1].content).toBe('second');
  });

  it('respects user isolation', async () => {
    const prisma = createPrismaMock();
    const provider = createMockProvider();
    const svc = new ChatService(prisma as any, provider as any);

    await svc.sendMessage({ userId: 'u1', content: 'u1 msg' });
    await svc.sendMessage({ userId: 'u2', content: 'u2 msg' });

    const u1History = await svc.history({ userId: 'u1' });
    const u2History = await svc.history({ userId: 'u2' });

    expect(u1History.length).toBe(2);
    expect(u2History.length).toBe(2);
    expect(u1History.every((m) => prisma.__chatLogs.find((l) => l.id === m.id)?.userId === 'u1')).toBe(true);
  });
});
