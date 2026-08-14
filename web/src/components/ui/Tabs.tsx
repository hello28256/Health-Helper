import { ReactNode } from 'react';
import clsx from 'clsx';

export type TabItem = { id: string; label: string; icon?: ReactNode };

type Props = {
  tabs: TabItem[];
  active: string;
  onChange: (id: string) => void;
  className?: string;
};

export function Tabs({ tabs, active, onChange, className }: Props) {
  return (
    <div
      role="tablist"
      className={clsx(
        'inline-flex items-center gap-1 rounded-2xl bg-slate-100 p-1',
        className,
      )}
    >
      {tabs.map((t) => (
        <button
          key={t.id}
          role="tab"
          aria-selected={t.id === active}
          onClick={() => onChange(t.id)}
          className={clsx(
            'flex items-center gap-1.5 rounded-xl px-3 py-1.5 text-sm font-medium transition-colors',
            t.id === active
              ? 'bg-white text-slate-900 shadow-sm'
              : 'text-slate-600 hover:text-slate-900',
          )}
        >
          {t.icon}
          {t.label}
        </button>
      ))}
    </div>
  );
}
