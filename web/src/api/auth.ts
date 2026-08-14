import { apiClient } from './client';
import type { components } from '@/types/api';

export type PublicUser = components['schemas']['PublicUser'];
export type AuthResult = components['schemas']['AuthResult'];

export const authApi = {
  /** 注册新账号 */
  async register(input: {
    email: string;
    password: string;
    deviceId: string;
    displayName?: string;
  }): Promise<AuthResult> {
    const { data } = await apiClient.post<AuthResult>('/api/auth/register', input);
    return data;
  },

  /** 登录 */
  async login(input: { email: string; password: string; deviceId: string }): Promise<AuthResult> {
    const { data } = await apiClient.post<AuthResult>('/api/auth/login', input);
    return data;
  },

  /** 刷新 access token（rotation） */
  async refresh(input: { refreshToken: string; deviceId: string }): Promise<AuthResult> {
    // refresh 必须绕过 401 拦截器，否则递归 refresh 死锁
    const { data } = await apiClient.post<AuthResult>('/api/auth/refresh', input, {
      _skipAuth: true,
    } as never);
    return data;
  },

  /** 登出（撤销 refresh token） */
  async logout(input: { refreshToken: string; deviceId: string }): Promise<void> {
    await apiClient.post('/api/auth/logout', input, { _skipAuth: true } as never);
  },
};
