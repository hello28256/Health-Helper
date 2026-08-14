import { ReactNode } from 'react';
import clsx from 'clsx';

type Props = {
  title?: ReactNode;
  subtitle?: ReactNode;
  right?: ReactNode;
  children: ReactNode;
  className?: string;
  /** 移动端紧凑，桌面端留白大些 */
  compact?: boolean;
};

export function Card({ title, subtitle, right, children, className, compact }: Props) {
  return (
    <section
      className={clsx(
        'rounded-2xl border border-slate-100 bg-white shadow-sm',
        compact ? 'p-3' : 'p-4',
        className,
      )}
    >
      {(title || right) && (
        <header className="mb-3 flex items-center justify-between">
          <div>
            {title && <h3 className="text-base font-semibold text-slate-800">{title}</h3>}
            {subtitle && <p className="text-xs text-slate-500">{subtitle}</p>}
          </div>
          {right}
        </header>
      )}
      {children}
    </section>
  );
}
