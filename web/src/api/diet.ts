import { apiClient } from './client';
import type { components } from '@/types/api';

export type Food = components['schemas']['Food'];
export type DietRecord = components['schemas']['DietRecord'];
export type DailyNutritionSummary = components['schemas']['DailyNutritionSummary'];

export const dietApi = {
  async searchFoods(params: { q?: string; category?: string; limit?: number; offset?: number } = {}): Promise<{
    foods: Food[];
  }> {
    const { data } = await apiClient.get('/api/diet/foods', { params });
    return data;
  },

  async createRecord(input: {
    foodId: number;
    mealType: 'breakfast' | 'lunch' | 'dinner' | 'snack';
    consumedAt?: string;
    servings: number;
  }): Promise<DietRecord> {
    const { data } = await apiClient.post<DietRecord>('/api/diet/records', input);
    return data;
  },

  async listRecords(from: string, to: string): Promise<{ records: DietRecord[] }> {
    const { data } = await apiClient.get('/api/diet/records', { params: { from, to } });
    return data;
  },

  async summary(date?: string): Promise<DailyNutritionSummary> {
    const { data } = await apiClient.get('/api/diet/summary', { params: date ? { date } : {} });
    return data;
  },
};
