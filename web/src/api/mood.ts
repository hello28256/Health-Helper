import { apiClient } from './client';
import type { components } from '@/types/api';

export type MoodRecord = components['schemas']['MoodRecord'];
export type MoodTrendPoint = components['schemas']['MoodTrendPoint'];

export type MoodType =
  | 'happy'
  | 'calm'
  | 'sad'
  | 'anxious'
  | 'angry'
  | 'tired'
  | 'grateful'
  | 'excited';

export const MOOD_LABELS: Record<MoodType, { emoji: string; zh: string; en: string }> = {
  happy: { emoji: '😊', zh: '开心', en: 'Happy' },
  calm: { emoji: '😌', zh: '平静', en: 'Calm' },
  sad: { emoji: '😢', zh: '难过', en: 'Sad' },
  anxious: { emoji: '😰', zh: '焦虑', en: 'Anxious' },
  angry: { emoji: '😠', zh: '生气', en: 'Angry' },
  tired: { emoji: '😴', zh: '疲惫', en: 'Tired' },
  grateful: { emoji: '🙏', zh: '感恩', en: 'Grateful' },
  excited: { emoji: '🤩', zh: '兴奋', en: 'Excited' },
};

export const moodApi = {
  async list(from?: string, to?: string): Promise<{ records: MoodRecord[] }> {
    const params: Record<string, string> = {};
    if (from) params.from = from;
    if (to) params.to = to;
    const { data } = await apiClient.get('/api/mood', { params });
    return data;
  },

  async create(input: {
    mood: MoodType;
    score?: number;
    note?: string;
    recordedAt?: string;
  }): Promise<MoodRecord> {
    const { data } = await apiClient.post<MoodRecord>('/api/mood', input);
    return data;
  },

  async trend(from: string, to: string): Promise<{ trend: MoodTrendPoint[] }> {
    const { data } = await apiClient.get('/api/mood/trend', { params: { from, to } });
    return data;
  },
};
