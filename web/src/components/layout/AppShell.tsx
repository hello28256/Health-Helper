import { NavLink, Outlet, useNavigate } from 'react-router-dom';
import { useAuth } from '@/hooks/useAuth';
import { useUiStore } from '@/stores/uiStore';
import { Toaster } from '@/components/ui/Toast';
import { ChatDrawer } from '@/components/chat/ChatDrawer';
import clsx from 'clsx';

const NAV = [
  { to: '/dashboard', label: '主页', icon: '🏠' },
  { to: '/record', label: '记录', icon: '✍️' },
  { to: '/trend', label: '趋势', icon: '📈' },
];

export function AppShell() {
  const { user, logout } = useAuth();
  const openChat = useUiStore((s) => s.openChatDrawer);
  const navigate = useNavigate();

  async function handleLogout() {
    await logout();
    navigate('/login', { replace: true });
  }

  return (
    <div className="flex min-h-[100dvh] flex-col bg-slate-50 md:flex-row">
      {/* ===== 桌面侧栏 ===== */}
      <aside className="hidden w-56 flex-col border-r border-slate-200 bg-white p-4 md:flex">
        <div className="mb-6 flex items-center gap-2 px-2">
          <span className="text-2xl">🌿</span>
          <span className="font-semibold text-slate-800">Health Helper</span>
        </div>
        <nav className="flex flex-1 flex-col gap-1">
          {NAV.map((n) => (
            <NavLink
              key={n.to}
              to={n.to}
              className={({ isActive }) =>
                clsx(
                  'flex items-center gap-2 rounded-xl px-3 py-2 text-sm font-medium transition-colors',
                  isActive
                    ? 'bg-brand-50 text-brand-700'
                    : 'text-slate-600 hover:bg-slate-50 hover:text-slate-900',
                )
              }
            >
              <span>{n.icon}</span>
              <span>{n.label}</span>
            </NavLink>
          ))}
          <button
            onClick={openChat}
            className="mt-2 flex items-center gap-2 rounded-xl px-3 py-2 text-left text-sm font-medium text-mood-600 hover:bg-mood-50"
          >
            <span>💬</span>
            <span>AI 助手</span>
          </button>
        </nav>
        <div className="border-t border-slate-100 pt-3">
          <div className="px-2 text-xs text-slate-500">{user?.email}</div>
          <button
            onClick={handleLogout}
            className="mt-2 w-full rounded-xl px-3 py-2 text-left text-sm text-slate-600 hover:bg-slate-50"
          >
            登出
          </button>
        </div>
      </aside>

      {/* ===== 主区 ===== */}
      <div className="flex flex-1 flex-col">
        {/* 移动顶栏 */}
        <header className="flex items-center justify-between border-b border-slate-200 bg-white px-4 py-3 md:hidden">
          <div className="flex items-center gap-2">
            <span className="text-xl">🌿</span>
            <span className="font-semibold text-slate-800">Health Helper</span>
          </div>
          <button onClick={handleLogout} className="text-sm text-slate-500">
            登出
          </button>
        </header>

        <main className="flex-1 overflow-y-auto px-4 py-4 md:px-6 md:py-6">
          <div className="mx-auto max-w-3xl">
            <Outlet />
          </div>
        </main>

        {/* ===== 移动底部 tab + 中间 FAB ===== */}
        <nav className="relative flex items-end justify-around border-t border-slate-200 bg-white px-2 pb-[env(safe-area-inset-bottom)] pt-2 md:hidden">
          {NAV.map((n) => (
            <NavLink
              key={n.to}
              to={n.to}
              className={({ isActive }) =>
                clsx(
                  'flex flex-1 flex-col items-center gap-0.5 py-1 text-xs',
                  isActive ? 'text-brand-600' : 'text-slate-500',
                )
              }
            >
              <span className="text-xl">{n.icon}</span>
              <span>{n.label}</span>
            </NavLink>
          ))}
        </nav>

        {/* 中间 FAB（聊天）—— 移动 + 桌面都有 */}
        <button
          onClick={openChat}
          aria-label="AI 助手"
          className="fixed bottom-20 right-4 z-30 flex h-14 w-14 items-center justify-center rounded-full bg-mood-600 text-2xl text-white shadow-lg transition-transform hover:scale-105 active:scale-95 md:bottom-6 md:right-6"
        >
          💬
        </button>
      </div>

      <Toaster />
      <ChatDrawer />
    </div>
  );
}
