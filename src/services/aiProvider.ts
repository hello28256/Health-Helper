import { aiConfig, env } from '../utils/env';

export interface AIMessage {
  role: 'user' | 'assistant';
  content: string;
}

export interface AIRequest {
  systemPrompt: string;
  messages: AIMessage[];
  maxTokens?: number;
}

export interface AIResponse {
  content: string;
  model: string;
  usage?: { inputTokens: number; outputTokens: number };
}

/**
 * AI Provider 抽象接口
 *
 * 设计要点：
 * - 不在 service 层直接依赖具体 SDK（anthropic / openai），便于测试与切换
 * - 不在 SDK 调用处硬编码 API key，从 env 读
 * - enabled=false 表示未配置，向调用方返回明确错误（不是 500）
 */
export interface AIProvider {
  readonly enabled: boolean;
  readonly name: string;
  sendMessage(req: AIRequest): Promise<AIResponse>;
}

// ===== 禁用时的占位实现 =====

class DisabledProvider implements AIProvider {
  readonly enabled = false;

  readonly name = 'disabled';

  // eslint-disable-next-line class-methods-use-this
  async sendMessage(): Promise<AIResponse> {
    throw new Error('AI provider not configured');
  }
}

// ===== Anthropic 实现 =====
// 注：实际环境会通过 npm install @anthropic-ai/sdk 接入；这里为了不增加依赖，
// 使用 fetch 调用 Messages API。SDK 用法类似，便于后续切换。

class AnthropicProvider implements AIProvider {
  readonly enabled = true;

  readonly name = 'anthropic';

  private readonly apiKey: string;

  private readonly model: string;

  constructor(apiKey: string, model: string) {
    this.apiKey = apiKey;
    this.model = model;
  }

  async sendMessage(req: AIRequest): Promise<AIResponse> {
    const res = await fetch('https://api.anthropic.com/v1/messages', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': this.apiKey,
        'anthropic-version': '2023-06-01',
      },
      body: JSON.stringify({
        model: this.model,
        max_tokens: req.maxTokens ?? 1024,
        system: req.systemPrompt,
        messages: req.messages.map((m) => ({
          role: m.role,
          content: m.content,
        })),
      }),
    });

    if (!res.ok) {
      const body = await res.text();
      throw new Error(`Anthropic API error ${res.status}: ${body.slice(0, 200)}`);
    }

    const data = (await res.json()) as {
      content: Array<{ type: string; text: string }>;
      model: string;
      usage: { input_tokens: number; output_tokens: number };
    };

    const text = data.content.find((b) => b.type === 'text')?.text ?? '';
    return {
      content: text,
      model: data.model,
      usage: {
        inputTokens: data.usage?.input_tokens ?? 0,
        outputTokens: data.usage?.output_tokens ?? 0,
      },
    };
  }
}

// ===== 工厂 =====

export function createAIProvider(): AIProvider {
  if (aiConfig.anthropic.enabled) {
    return new AnthropicProvider(aiConfig.anthropic.apiKey, aiConfig.anthropic.model);
  }
  // OpenAI 留作后续 task 实现
  return new DisabledProvider();
}

// 调试用：暴露当前 env 中的 AI 配置摘要
export function aiProviderInfo(): string {
  if (aiConfig.anthropic.enabled) return `anthropic (${aiConfig.anthropic.model})`;
  if (aiConfig.openai.enabled) return `openai (${aiConfig.openai.model})`;
  return 'disabled (no API key configured)';
}

// 防止 env 在测试时未加载时报错
export const AI_DEBUG = env.NODE_ENV === 'development';
