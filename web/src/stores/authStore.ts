/**
 * authStore —— 全局 auth 状态
 *
 * 数据流：
 *   bootstrap() —— 启动时如果有 token，try refresh → 拿到 user
 *   login() / register() —— 登录/注册成功自动 setTokens + setUser
 *   logout() —— 调后端 logout（撤销 refresh） + 清本地
 *   setTokens() —— 由 api client 401 拦截器在 refresh 成功后调用
 *
 * 持久化：只持久化 {accessToken, refreshToken}，user 每次启动从 /me 拉
 */
import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';
import { authApi, type PublicUser } from '@/api/auth';
import { usersApi } from '@/api/users';
import { getDeviceId } from '@/lib/deviceId';
import { bindTokenHolder, type TokenHolder } from '@/api/client';

type Status = 'idle' | 'loading' | 'authenticated' | 'unauthenticated';

type AuthState = {
  status: Status;
  accessToken: string | null;
  refreshToken: string | null;
  user: PublicUser | null;
  deviceId: string;
  error: string | null;

  // 动作
  login: (input: { email: string; password: string }) => Promise<void>;
  register: (input: { email: string; password: string; displayName?: string }) => Promise<void>;
  logout: () => Promise<void>;
  bootstrap: () => Promise<void>;
  /** 由 api client 401 拦截器调用 */
  setTokens: (access: string, refresh: string) => void;
  setUser: (user: PublicUser) => void;
  onAuthFailed: () => void;
};

const initial: Pick<AuthState, 'status' | 'accessToken' | 'refreshToken' | 'user' | 'error'> = {
  status: 'idle',
  accessToken: null,
  refreshToken: null,
  user: null,
  error: null,
};

export const useAuthStore = create<AuthState>()(
  persist(
    (set, get) => {
      // 同步注册 token holder
      const holder: TokenHolder = {
        getAccessToken: () => get().accessToken,
        getRefreshToken: () => get().refreshToken,
        setTokens: (a, r) => set({ accessToken: a, refreshToken: r }),
        clear: () => set({ accessToken: null, refreshToken: null, user: null }),
        onAuthFailed: () => {
          get().onAuthFailed();
        },
        getDeviceId: () => get().deviceId,
      };
      bindTokenHolder(holder);

      return {
        ...initial,
        deviceId: getDeviceId(),

        async login({ email, password }) {
          set({ status: 'loading', error: null });
          try {
            const res = await authApi.login({
              email,
              password,
              deviceId: get().deviceId,
            });
            set({
              accessToken: res.accessToken,
              refreshToken: res.refreshToken,
              user: res.user,
              status: 'authenticated',
              error: null,
            });
          } catch (e) {
            set({ status: 'unauthenticated', error: (e as Error).message });
            throw e;
          }
        },

        async register({ email, password, displayName }) {
          set({ status: 'loading', error: null });
          try {
            const res = await authApi.register({
              email,
              password,
              deviceId: get().deviceId,
              displayName,
            });
            set({
              accessToken: res.accessToken,
              refreshToken: res.refreshToken,
              user: res.user,
              status: 'authenticated',
              error: null,
            });
          } catch (e) {
            set({ status: 'unauthenticated', error: (e as Error).message });
            throw e;
          }
        },

        async logout() {
          const { refreshToken, deviceId } = get();
          // 后端 logout 撤销 refresh（幂等，失败也无所谓）
          if (refreshToken) {
            try {
              await authApi.logout({ refreshToken, deviceId });
            } catch {
              // 忽略网络错误，本地清掉
            }
          }
          set({ ...initial, status: 'unauthenticated', deviceId: get().deviceId });
        },

        async bootstrap() {
          const { accessToken, refreshToken } = get();
          if (!accessToken && !refreshToken) {
            set({ status: 'unauthenticated' });
            return;
          }
          set({ status: 'loading' });
          // 尝试拉 /me 验证 token 还活着
          try {
            const me = await usersApi.me();
            set({ user: me, status: 'authenticated', error: null });
          } catch {
            set({ status: 'unauthenticated' });
            set({ accessToken: null, refreshToken: null, user: null });
          }
        },

        setTokens(access, refresh) {
          set({ accessToken: access, refreshToken: refresh });
        },

        setUser(user) {
          set({ user });
        },

        onAuthFailed() {
          set({ ...initial, status: 'unauthenticated', deviceId: get().deviceId });
        },
      };
    },
    {
      name: 'hh.auth',
      storage: createJSONStorage(() => localStorage),
      partialize: (state) => ({
        accessToken: state.accessToken,
        refreshToken: state.refreshToken,
        deviceId: state.deviceId,
      }),
    },
  ),
);

/** 派生：是否已认证 */
export function useIsAuthenticated(): boolean {
  return useAuthStore((s) => s.status === 'authenticated');
}
