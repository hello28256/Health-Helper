/**
 * authStore 状态机单测
 */
import { describe, it, expect, vi, beforeEach } from 'vitest';

// mock api 模块
const mocks = vi.hoisted(() => ({
  login: vi.fn(),
  register: vi.fn(),
  logout: vi.fn(),
  me: vi.fn(),
}));

vi.mock('@/api/auth', () => ({
  authApi: {
    login: mocks.login,
    register: mocks.register,
    logout: mocks.logout,
  },
}));

vi.mock('@/api/users', () => ({
  usersApi: { me: mocks.me },
}));

import { useAuthStore } from '@/stores/authStore';

beforeEach(() => {
  vi.clearAllMocks();
  // 清 store
  useAuthStore.setState({
    status: 'idle',
    accessToken: null,
    refreshToken: null,
    user: null,
    error: null,
  });
  localStorage.clear();
});

describe('authStore.login', () => {
  it('sets tokens and user on success', async () => {
    mocks.login.mockResolvedValueOnce({
      accessToken: 'a1',
      refreshToken: 'r1',
      user: { id: 'u1', email: 'u@x.com' },
    });

    await useAuthStore.getState().login({ email: 'u@x.com', password: 'pw1234' });

    const s = useAuthStore.getState();
    expect(s.accessToken).toBe('a1');
    expect(s.refreshToken).toBe('r1');
    expect(s.user?.email).toBe('u@x.com');
    expect(s.status).toBe('authenticated');
  });

  it('sets error on failure', async () => {
    mocks.login.mockRejectedValueOnce(new Error('unauthorized'));

    await expect(
      useAuthStore.getState().login({ email: 'u@x.com', password: 'wrong' }),
    ).rejects.toThrow('unauthorized');

    const s = useAuthStore.getState();
    expect(s.status).toBe('unauthenticated');
    expect(s.error).toBe('unauthorized');
  });
});

describe('authStore.register', () => {
  it('sets tokens and user on success', async () => {
    mocks.register.mockResolvedValueOnce({
      accessToken: 'a2',
      refreshToken: 'r2',
      user: { id: 'u2', email: 'new@x.com' },
    });

    await useAuthStore.getState().register({ email: 'new@x.com', password: 'pw1234' });

    const s = useAuthStore.getState();
    expect(s.accessToken).toBe('a2');
    expect(s.user?.email).toBe('new@x.com');
  });
});

describe('authStore.logout', () => {
  it('clears local state and calls api.logout', async () => {
    mocks.logout.mockResolvedValueOnce(undefined);
    useAuthStore.setState({
      accessToken: 'a',
      refreshToken: 'r',
      user: { id: 'u', email: 'u@x.com' } as any,
      status: 'authenticated',
    });

    await useAuthStore.getState().logout();

    expect(mocks.logout).toHaveBeenCalledWith({ refreshToken: 'r', deviceId: expect.any(String) });
    const s = useAuthStore.getState();
    expect(s.accessToken).toBeNull();
    expect(s.user).toBeNull();
    expect(s.status).toBe('unauthenticated');
  });

  it('still clears local state when api.logout throws', async () => {
    mocks.logout.mockRejectedValueOnce(new Error('network'));
    useAuthStore.setState({ accessToken: 'a', refreshToken: 'r', status: 'authenticated' });

    await useAuthStore.getState().logout();

    expect(useAuthStore.getState().accessToken).toBeNull();
  });
});

describe('authStore.bootstrap', () => {
  it('does nothing when no tokens', async () => {
    await useAuthStore.getState().bootstrap();
    expect(mocks.me).not.toHaveBeenCalled();
    expect(useAuthStore.getState().status).toBe('unauthenticated');
  });

  it('fetches /me when tokens present', async () => {
    useAuthStore.setState({ accessToken: 'a', refreshToken: 'r' });
    mocks.me.mockResolvedValueOnce({ id: 'u1', email: 'me@x.com' });

    await useAuthStore.getState().bootstrap();

    const s = useAuthStore.getState();
    expect(s.user?.email).toBe('me@x.com');
    expect(s.status).toBe('authenticated');
  });

  it('clears tokens when /me fails', async () => {
    useAuthStore.setState({ accessToken: 'a', refreshToken: 'r' });
    mocks.me.mockRejectedValueOnce(new Error('expired'));

    await useAuthStore.getState().bootstrap();

    const s = useAuthStore.getState();
    expect(s.status).toBe('unauthenticated');
    expect(s.accessToken).toBeNull();
  });
});

describe('authStore.onAuthFailed', () => {
  it('clears all auth state', () => {
    useAuthStore.setState({
      accessToken: 'a',
      refreshToken: 'r',
      user: { id: 'u' } as any,
      status: 'authenticated',
    });

    useAuthStore.getState().onAuthFailed();

    const s = useAuthStore.getState();
    expect(s.accessToken).toBeNull();
    expect(s.refreshToken).toBeNull();
    expect(s.user).toBeNull();
    expect(s.status).toBe('unauthenticated');
  });
});

describe('authStore persistence', () => {
  it('persists tokens and deviceId, but not user', () => {
    useAuthStore.setState({
      accessToken: 'a',
      refreshToken: 'r',
      user: { id: 'u', email: 'u@x.com' } as any,
      deviceId: 'd-123',
    });

    // 模拟刷新：先持久化到 localStorage（zustand persist 自动做）
    // 检查 localStorage 里有 a/r/d，但没有 user
    const raw = localStorage.getItem('hh.auth');
    expect(raw).toBeTruthy();
    const parsed = JSON.parse(raw!);
    expect(parsed.state.accessToken).toBe('a');
    expect(parsed.state.refreshToken).toBe('r');
    expect(parsed.state.deviceId).toBe('d-123');
    expect(parsed.state.user).toBeUndefined();
  });
});
