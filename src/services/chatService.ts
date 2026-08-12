import { prisma } from '../models/prisma';
import { AppError, ValidationError } from '../utils/errors';
import { AIProvider, AIMessage, createAIProvider } from './aiProvider';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type PrismaLike = any;

/**
 * 医疗免责声明 —— 必须出现在所有 AI 对话的系统 prompt 顶部。
 * 这是健康类应用的合规底线。
 */
export const MEDICAL_DISCLAIMER = `你是「健康助手」的 AI 心理对话伙伴。

【重要免责声明】
- 你不是医生、心理咨询师或医疗专业人员。
- 你的回答仅用于情绪支持和日常心理健康陪伴，**不能替代专业医疗诊断和治疗**。
- 如果用户表达了自伤、自杀、严重抑郁或有紧急危机，请明确建议他们拨打当地急救电话（中国大陆：120 / 北京心理危机研究与干预中心：010-82951332）或联系专业医生。
- 不要开具处方药、不要做诊断、不要承诺疗效。
- 用温暖、不评判的语言倾听；不夸大、不恐吓。

【对话风格】
- 简短、共情、以提问引导用户自我探索
- 每次回答 2-4 句话为主，避免长篇大论
- 如用户沉默或重复提问，温柔询问「今天最想聊聊什么？」`;

export interface SendMessageInput {
  userId: string;
  content: string;
}

export interface SendMessageResult {
  userMessage: ChatLogDto;
  assistantMessage: ChatLogDto;
}

export interface ChatLogDto {
  id: string;
  userId: string;
  role: 'user' | 'assistant';
  content: string;
  createdAt: Date;
}

export interface HistoryInput {
  userId: string;
  limit?: number;
}

const MAX_MESSAGE_LENGTH = 4000;
const HISTORY_WINDOW = 20; // 传给 AI 的最近 N 条消息

/**
 * ChatService —— 心理健康 · AI 对话
 *
 * 流程：
 * 1. 校验消息内容（非空、长度）
 * 2. 存用户消息到 chat_logs
 * 3. 查最近 HISTORY_WINDOW 条历史 → 拼 messages
 * 4. 调 AI provider（带医疗免责声明的 systemPrompt）
 * 5. 存 AI 回复到 chat_logs
 * 6. 返回两条记录
 */
export class ChatService {
  constructor(
    private readonly prisma: PrismaLike,
    private readonly provider: AIProvider,
  ) {}

  async sendMessage(input: SendMessageInput): Promise<SendMessageResult> {
    const trimmed = input.content?.trim() ?? '';
    if (trimmed.length === 0) {
      throw new ValidationError('content must not be empty');
    }
    if (trimmed.length > MAX_MESSAGE_LENGTH) {
      throw new ValidationError(`content too long (max ${MAX_MESSAGE_LENGTH})`, {
        length: trimmed.length,
      });
    }
    if (!this.provider.enabled) {
      throw new AppError(
        'AI 对话功能未启用。请在服务端配置 ANTHROPIC_API_KEY 或 OPENAI_API_KEY 环境变量。',
        503,
        'AI_DISABLED',
      );
    }

    // 1. 存用户消息
    const userLog = await this.prisma.chatLog.create({
      data: { userId: input.userId, role: 'user', content: trimmed },
    });

    // 2. 拉最近历史（不含本条，因为本条已存但还未取回）
    const history = await this.prisma.chatLog.findMany({
      where: { userId: input.userId },
      orderBy: { createdAt: 'asc' },
      take: HISTORY_WINDOW,
    });

    const messages: AIMessage[] = history
      .filter((h: any) => h.id !== userLog.id)
      .map((h: any) => ({ role: h.role, content: h.content }))
      .concat([{ role: 'user', content: trimmed }]);

    // 3. 调 AI
    let response;
    try {
      response = await this.provider.sendMessage({
        systemPrompt: MEDICAL_DISCLAIMER,
        messages,
      });
    } catch (err) {
      // provider 错误（网络/鉴权/限流）转 AppError，状态码 502 Bad Gateway
      throw new AppError(
        `AI 服务调用失败：${err instanceof Error ? err.message : String(err)}`,
        502,
        'AI_UPSTREAM_ERROR',
      );
    }

    // 4. 存 AI 回复
    const assistantLog = await this.prisma.chatLog.create({
      data: { userId: input.userId, role: 'assistant', content: response.content },
    });

    return {
      userMessage: this.toDto(userLog),
      assistantMessage: this.toDto(assistantLog),
    };
  }

  async history(input: HistoryInput): Promise<ChatLogDto[]> {
    const rows = await this.prisma.chatLog.findMany({
      where: { userId: input.userId },
      orderBy: { createdAt: 'desc' },
      take: input.limit ?? 50,
    });
    return rows.map((r: any) => this.toDto(r));
  }

  // eslint-disable-next-line class-methods-use-this
  private toDto(r: any): ChatLogDto {
    return {
      id: r.id,
      userId: r.userId,
      role: r.role,
      content: r.content,
      createdAt: r.createdAt,
    };
  }
}

// ===== Factory =====

export function createChatService(): ChatService {
  return new ChatService(prisma, createAIProvider());
}
