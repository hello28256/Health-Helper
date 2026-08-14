import { useState } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { useAuth } from '@/hooks/useAuth';
import { useUiStore } from '@/stores/uiStore';
import { Button } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';
import { Spinner } from '@/components/ui/Spinner';
import { ApiError } from '@/api/client';

type Mode = 'login' | 'register';

export function LoginPage() {
  const navigate = useNavigate();
  const location = useLocation();
  const { login, register } = useAuth();
  const pushToast = useUiStore((s) => s.pushToast);

  const [mode, setMode] = useState<Mode>('login');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [displayName, setDisplayName] = useState('');
  const [loading, setLoading] = useState(false);
  const [err, setErr] = useState<string | null>(null);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setErr(null);
    setLoading(true);
    try {
      if (mode === 'login') {
        await login({ email, password });
      } else {
        await register({
          email,
          password,
          displayName: displayName || undefined,
        });
      }
      pushToast('success', mode === 'login' ? '登录成功' : '注册成功');
      const from = (location.state as { from?: string } | null)?.from ?? '/dashboard';
      navigate(from, { replace: true });
    } catch (e) {
      setErr(humanize(e));
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="flex min-h-[100dvh] items-center justify-center bg-gradient-to-br from-brand-50 via-white to-mood-50 px-4 py-8">
      <div className="w-full max-w-sm">
        <div className="mb-6 text-center">
          <div className="mb-2 text-4xl">🌿</div>
          <h1 className="text-2xl font-bold text-slate-800">Health Helper</h1>
          <p className="mt-1 text-sm text-slate-500">身心健康的随身助手</p>
        </div>

        <div className="rounded-2xl border border-slate-100 bg-white p-5 shadow-sm">
          <div className="mb-4 flex rounded-xl bg-slate-100 p-1">
            {(['login', 'register'] as const).map((m) => (
              <button
                key={m}
                onClick={() => {
                  setMode(m);
                  setErr(null);
                }}
                className={`flex-1 rounded-lg py-1.5 text-sm font-medium transition-colors ${
                  mode === m ? 'bg-white text-slate-900 shadow-sm' : 'text-slate-500'
                }`}
              >
                {m === 'login' ? '登录' : '注册'}
              </button>
            ))}
          </div>

          <form onSubmit={handleSubmit} className="space-y-3">
            <Input
              label="邮箱"
              type="email"
              autoComplete="email"
              required
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="you@example.com"
            />
            <Input
              label="密码"
              type="password"
              autoComplete={mode === 'login' ? 'current-password' : 'new-password'}
              required
              minLength={8}
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="至少 8 位"
              hint={mode === 'register' ? '密码至少 8 位' : undefined}
            />
            {mode === 'register' && (
              <Input
                label="昵称（可选）"
                value={displayName}
                onChange={(e) => setDisplayName(e.target.value)}
                placeholder="给自己起个名字"
              />
            )}

            {err && (
              <div className="rounded-xl border border-rose-200 bg-rose-50 px-3 py-2 text-sm text-rose-700">
                {err}
              </div>
            )}

            <Button type="submit" size="lg" loading={loading} className="w-full">
              {loading ? <Spinner size="sm" /> : null}
              {mode === 'login' ? '登录' : '注册并登录'}
            </Button>
          </form>
        </div>

        <p className="mt-4 text-center text-xs text-slate-400">
          单一账号 · 多端同步 · 跨 iOS / Android / Web
        </p>
      </div>
    </div>
  );
}

function humanize(e: unknown): string {
  if (e instanceof ApiError) {
    if (e.code === 'UNAUTHORIZED') return '邮箱或密码错误';
    if (e.code === 'CONFLICT') return '该邮箱已注册';
    if (e.code === 'VALIDATION_ERROR') {
      const details = e.details as { fieldErrors?: Record<string, string[]> } | undefined;
      const first = details?.fieldErrors && Object.values(details.fieldErrors)[0]?.[0];
      return first ?? '请检查输入';
    }
    return e.message;
  }
  return '网络错误，请稍后重试';
}
