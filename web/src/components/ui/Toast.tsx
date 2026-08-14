import { useUiStore } from '@/stores/uiStore';
import clsx from 'clsx';

export function Toaster() {
  const toasts = useUiStore((s) => s.toasts);
  const dismiss = useUiStore((s) => s.dismissToast);

  return (
    <div className="pointer-events-none fixed inset-x-0 top-4 z-50 flex flex-col items-center gap-2 px-4">
      {toasts.map((t) => (
        <div
          key={t.id}
          role="status"
          onClick={() => dismiss(t.id)}
          className={clsx(
            'pointer-events-auto cursor-pointer rounded-xl px-4 py-2.5 text-sm shadow-lg',
            t.kind === 'success' && 'bg-brand-600 text-white',
            t.kind === 'error' && 'bg-rose-600 text-white',
            t.kind === 'info' && 'bg-slate-800 text-white',
          )}
        >
          {t.message}
        </div>
      ))}
    </div>
  );
}
