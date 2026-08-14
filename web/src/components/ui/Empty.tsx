import { ReactNode } from 'react';

type Props = {
  title: string;
  hint?: string;
  icon?: ReactNode;
  action?: ReactNode;
};

export function Empty({ title, hint, icon, action }: Props) {
  return (
    <div className="flex flex-col items-center justify-center gap-2 py-8 text-center">
      <div className="text-3xl">{icon ?? '📋'}</div>
      <p className="text-sm font-medium text-slate-700">{title}</p>
      {hint && <p className="text-xs text-slate-500">{hint}</p>}
      {action}
    </div>
  );
}
