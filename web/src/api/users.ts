import { apiClient } from './client';
import type { components } from '@/types/api';

export type PublicUser = components['schemas']['PublicUser'];

export const usersApi = {
  async me(): Promise<PublicUser> {
    const { data } = await apiClient.get<PublicUser>('/api/users/me');
    return data;
  },

  async updateMe(patch: {
    displayName?: string;
    heightCm?: number;
    weightKg?: number;
    birthDate?: string;
  }): Promise<PublicUser> {
    const { data } = await apiClient.patch<PublicUser>('/api/users/me', patch);
    return data;
  },
};
