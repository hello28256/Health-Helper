import { apiClient } from './client';
import type { components } from '@/types/api';

export type ExerciseType = components['schemas']['ExerciseType'];
export type ExerciseRecord = components['schemas']['ExerciseRecord'];
export type DailyStep = components['schemas']['DailyStep'];

export const exercisesApi = {
  async types(): Promise<{ types: ExerciseType[] }> {
    const { data } = await apiClient.get('/api/exercises/types');
    return data;
  },

  async list(from?: string, to?: string): Promise<{ records: ExerciseRecord[] }> {
    const params: Record<string, string> = {};
    if (from) params.from = from;
    if (to) params.to = to;
    const { data } = await apiClient.get('/api/exercises', { params });
    return data;
  },

  async create(input: {
    typeId: string;
    startedAt: string;
    durationSec: number;
    distanceKm?: number;
    clientId?: string;
  }): Promise<ExerciseRecord> {
    const { data } = await apiClient.post<ExerciseRecord>('/api/exercises', input);
    return data;
  },

  // ===== 步数 =====

  async todaySteps(): Promise<DailyStep> {
    const { data } = await apiClient.get<DailyStep>('/api/exercises/steps/today');
    return data;
  },

  async reportSteps(input: { date?: string; steps: number; source?: string }): Promise<DailyStep> {
    const { data } = await apiClient.post<DailyStep>('/api/exercises/steps', input);
    return data;
  },
};
