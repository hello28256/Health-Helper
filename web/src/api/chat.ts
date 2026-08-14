import { apiClient } from './client';
import type { components } from '@/types/api';

export type ChatMessage = components['schemas']['ChatMessage'];
export type ChatSendResult = components['schemas']['ChatSendResult'];

export const chatApi = {
  async send(content: string): Promise<ChatSendResult> {
    const { data } = await apiClient.post<ChatSendResult>('/api/chat/messages', { content });
    return data;
  },

  async history(limit = 50): Promise<{ history: ChatMessage[] }> {
    const { data } = await apiClient.get('/api/chat/history', { params: { limit } });
    return data;
  },
};
