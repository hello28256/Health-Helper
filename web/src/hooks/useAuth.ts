/**
 * useAuth —— 组合 authStore + React Query
 */
import { useEffect } from 'react';
import { useAuthStore, useIsAuthenticated } from '@/stores/authStore';

export function useAuth() {
  const status = useAuthStore((s) => s.status);
  const user = useAuthStore((s) => s.user);
  const isAuthenticated = useIsAuthenticated();
  const login = useAuthStore((s) => s.login);
  const register = useAuthStore((s) => s.register);
  const logout = useAuthStore((s) => s.logout);
  const error = useAuthStore((s) => s.error);

  return { status, user, isAuthenticated, login, register, logout, error };
}

/** 启动时调一次：拉 /me 验证 token 还活着 */
export function useAuthBootstrap() {
  const bootstrap = useAuthStore((s) => s.bootstrap);
  const status = useAuthStore((s) => s.status);
  useEffect(() => {
    if (status === 'idle') {
      bootstrap();
    }
  }, [bootstrap, status]);
}
