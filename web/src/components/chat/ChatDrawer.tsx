import { useEffect, useRef, useState } from 'react';
import clsx from 'clsx';
import { useUiStore } from '@/stores/uiStore';
import { useChatHistory, useSendMessage } from '@/hooks/useChat';
import { ApiError } from '@/api/client';
import { Spinner } from '@/components/ui/Spinner';
import { formatTime } from '@/lib/format';
import { Button } from '@/components/ui/Button';

export function ChatDrawer() {
  const open = useUiStore((s) => s.chatDrawerOpen);
  const close = useUiStore((s) => s.closeChatDrawer);
  const historyQ = useChatHistory(50);
  const send = useSendMessage();

  const [input, setInput] = useState('');
  const [error, setError] = useState<string | null>(null);
  const scrollRef = useRef<HTMLDivElement>(null);

  // 自动滚到底
  useEffect(() => {
    if (open && scrollRef.current) {
      scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
    }
  }, [open, historyQ.data]);

  // 重置错误当打开
  useEffect(() => {
    if (open) setError(null);
  }, [open]);

  async function handleSend(e: React.FormEvent) {
    e.preventDefault();
    if (!input.trim() || send.isPending) return;
    const content = input.trim();
    setInput('');
    setError(null);
    try {
      await send.mutateAsync(content);
    } catch (e) {
      if (e instanceof ApiError) {
        if (e.code === 'AI_DISABLED') {
          setError('AI 助手暂未启用（后端未配置 ANTHROPIC_API_KEY / OPENAI_API_KEY）');
        } else if (e.code === 'AI_UPSTREAM_ERROR') {
          setError('AI 服务暂不可用，请稍后重试');
        } else {
          setError(e.message);
        }
      } else {
        setError('网络错误');
      }
    }
  }

  if (!open) return null;

  const messages = historyQ.data?.history ?? [];

  return (
    <div className="fixed inset-0 z-40 flex">
      <div className="flex-1 bg-black/30" onClick={close} aria-hidden />
      <aside className="flex w-full max-w-md flex-col bg-white shadow-2xl">
        {/* Header */}
        <header className="flex items-center justify-between border-b border-slate-200 px-4 py-3">
          <div>
            <h2 className="font-semibold text-slate-800">AI 健康助手</h2>
            <p className="text-[11px] text-slate-500">基于 Claude / GPT · 内容仅供参考</p>
          </div>
          <button
            onClick={close}
            className="flex h-8 w-8 items-center justify-center rounded-full text-slate-500 hover:bg-slate-100"
            aria-label="关闭"
          >
            ×
          </button>
        </header>

        {/* Messages */}
        <div ref={scrollRef} className="flex-1 space-y-3 overflow-y-auto px-4 py-3">
          {historyQ.isLoading ? (
            <div className="flex h-full items-center justify-center">
              <Spinner />
            </div>
          ) : messages.length === 0 ? (
            <div className="flex h-full flex-col items-center justify-center text-center text-sm text-slate-500">
              <div className="text-3xl">💬</div>
              <p className="mt-2 font-medium text-slate-700">有什么想问的？</p>
              <p className="mt-1 text-xs text-slate-400">
                例：最近心情低落怎么办？跑步后怎么拉伸？
              </p>
              <p className="mt-3 text-[11px] text-slate-400">
                ⚠️ AI 不提供医疗诊断，急症请就医
              </p>
            </div>
          ) : (
            messages.map((m) => (
              <div
                key={m.id}
                className={clsx(
                  'flex',
                  m.role === 'user' ? 'justify-end' : 'justify-start',
                )}
              >
                <div
                  className={clsx(
                    'max-w-[80%] rounded-2xl px-3 py-2 text-sm shadow-sm',
                    m.role === 'user'
                      ? 'bg-brand-600 text-white'
                      : 'bg-slate-100 text-slate-800',
                  )}
                >
                  <p className="whitespace-pre-wrap break-words">{m.content}</p>
                  <p
                    className={clsx(
                      'mt-1 text-[10px]',
                      m.role === 'user' ? 'text-white/70' : 'text-slate-400',
                    )}
                  >
                    {formatTime(m.createdAt)}
                  </p>
                </div>
              </div>
            ))
          )}
          {send.isPending && (
            <div className="flex justify-start">
              <div className="rounded-2xl bg-slate-100 px-3 py-2 text-sm text-slate-500">
                <span className="inline-block animate-pulse">AI 正在思考…</span>
              </div>
            </div>
          )}
        </div>

        {/* Error */}
        {error && (
          <div className="mx-4 mb-2 rounded-xl border border-amber-200 bg-amber-50 px-3 py-2 text-xs text-amber-800">
            {error}
          </div>
        )}

        {/* Input */}
        <form onSubmit={handleSend} className="border-t border-slate-200 p-3">
          <div className="flex items-end gap-2">
            <textarea
              value={input}
              onChange={(e) => setInput(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === 'Enter' && !e.shiftKey) {
                  e.preventDefault();
                  handleSend(e);
                }
              }}
              rows={2}
              maxLength={4000}
              placeholder="说点什么… (Enter 发送 / Shift+Enter 换行)"
              className="flex-1 resize-none rounded-xl border border-slate-200 px-3 py-2 text-sm placeholder:text-slate-400 focus:border-mood-500 focus:outline-none focus:ring-2 focus:ring-mood-500/20"
            />
            <Button
              type="submit"
              variant="primary"
              size="md"
              loading={send.isPending}
              disabled={!input.trim()}
              className="bg-mood-600 hover:bg-mood-600/90"
            >
              发送
            </Button>
          </div>
        </form>
      </aside>
    </div>
  );
}
