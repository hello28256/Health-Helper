/**
 * Axios 实例 + 401 自动 refresh 队列
 *
 * 关键点：
 * 1. 每个请求带 Bearer accessToken
 * 2. 收到 401 自动用 refreshToken 换新 accessToken 后重放
 * 3. 多个请求同时 401 时只 refresh 一次（Promise 单例锁）
 * 4. refresh 失败 → 触发 onAuthFailed（让 store 清空 + 跳登录）
 */
import axios, { AxiosError, AxiosRequestConfig, InternalAxiosRequestConfig } from 'axios';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:3000';

// 扩展 AxiosRequestConfig 让标记 _retried / _skipAuth
declare module 'axios' {
  export interface InternalAxiosRequestConfig {
    _retried?: boolean;
    _skipAuth?: boolean;
  }
}

export const apiClient = axios.create({
  baseURL: API_BASE_URL,
  timeout: 15_000,
  headers: { 'Content-Type': 'application/json' },
});

// ===== Token 持有器（由 authStore 注入，避免循环依赖）=====
export type TokenHolder = {
  getAccessToken: () => string | null;
  getRefreshToken: () => string | null;
  setTokens: (access: string, refresh: string) => void;
  clear: () => void;
  onAuthFailed: () => void;
  getDeviceId: () => string;
};

let tokenHolder: TokenHolder | null = null;

/** 由 authStore 启动时调用一次，注册 token 操作回调 */
export function bindTokenHolder(holder: TokenHolder): void {
  tokenHolder = holder;
}

// ===== 把后端 { error: { code, message, details } } 规范成 Error =====
export class ApiError extends Error {
  constructor(
    public code: string,
    message: string,
    public status: number,
    public details?: unknown,
  ) {
    super(message);
    this.name = 'ApiError';
  }
}

// ===== 拦截器（拆成纯函数方便单测） =====

/** 请求拦截器：自动加 Bearer */
export function requestInterceptor(config: InternalAxiosRequestConfig): InternalAxiosRequestConfig {
  if (config._skipAuth) return config;
  const token = tokenHolder?.getAccessToken();
  if (token) {
    config.headers.set('Authorization', `Bearer ${token}`);
  }
  return config;
}

let refreshInFlight: Promise<void> | null = null;

async function doRefresh(): Promise<void> {
  const holder = tokenHolder;
  if (!holder) throw new Error('no token holder bound');
  const refreshToken = holder.getRefreshToken();
  if (!refreshToken) throw new Error('no refresh token');

  // 直接走底层 axios 避免再触发拦截器
  const res = await axios.post<{
    accessToken: string;
    refreshToken: string;
  }>(
    `${API_BASE_URL}/api/auth/refresh`,
    { refreshToken, deviceId: holder.getDeviceId() },
    { headers: { 'Content-Type': 'application/json' } },
  );
  holder.setTokens(res.data.accessToken, res.data.refreshToken);
}

/** 响应拦截器：401 → 自动 refresh → 重放 */
export async function responseErrorInterceptor(
  error: AxiosError,
): Promise<unknown> {
  const original = error.config as AxiosRequestConfig & { _retried?: boolean };
  const status = error.response?.status;

  // 不需要 refresh 的情况
  if (status !== 401 || !original || original._retried || (original as any)._skipAuth) {
    return Promise.reject(error);
  }
  if (!tokenHolder) return Promise.reject(error);

  try {
    if (!refreshInFlight) {
      refreshInFlight = doRefresh().finally(() => {
        refreshInFlight = null;
      });
    }
    await refreshInFlight;

    original._retried = true;
    const token = tokenHolder.getAccessToken();
    if (token) {
      original.headers = { ...(original.headers ?? {}), Authorization: `Bearer ${token}` };
    }
    return apiClient(original);
  } catch (refreshErr) {
    tokenHolder.onAuthFailed();
    return Promise.reject(refreshErr);
  }
}

/** 响应拦截器：把后端 {error:{...}} 转 ApiError */
export function apiErrorInterceptor(
  error: AxiosError<{ error?: { code: string; message: string; details?: unknown } }>,
): Promise<never> {
  const body = error.response?.data;
  if (body?.error) {
    return Promise.reject(
      new ApiError(body.error.code, body.error.message, error.response?.status ?? 500, body.error.details),
    );
  }
  return Promise.reject(error);
}

// 注册拦截器
apiClient.interceptors.request.use(requestInterceptor);
apiClient.interceptors.response.use(
  (r) => r,
  (err: AxiosError) => responseErrorInterceptor(err),
);
apiClient.interceptors.response.use(
  (r) => r,
  (err: AxiosError) => apiErrorInterceptor(err as AxiosError<{ error?: { code: string; message: string; details?: unknown } }>),
);

/** 暴露给单测的内部句柄 */
export const __test__ = {
  doRefresh,
  getRefreshInFlight: () => refreshInFlight,
};
