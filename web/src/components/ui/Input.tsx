import { InputHTMLAttributes, forwardRef } from 'react';
import clsx from 'clsx';

type Props = InputHTMLAttributes<HTMLInputElement> & {
  label?: string;
  error?: string;
  hint?: string;
};

export const Input = forwardRef<HTMLInputElement, Props>(function Input(
  { label, error, hint, className, id, ...rest },
  ref,
) {
  const inputId = id ?? `in_${Math.random().toString(36).slice(2, 8)}`;
  return (
    <label htmlFor={inputId} className="block">
      {label && <span className="mb-1 block text-sm font-medium text-slate-700">{label}</span>}
      <input
        ref={ref}
        id={inputId}
        className={clsx(
          'w-full rounded-xl border bg-white px-3 py-2.5 text-sm',
          'placeholder:text-slate-400',
          'focus:outline-none focus:ring-2 focus:ring-brand-500/20',
          'disabled:opacity-50',
          error ? 'border-rose-400 focus:border-rose-500' : 'border-slate-200 focus:border-brand-500',
          className,
        )}
        {...rest}
      />
      {error ? (
        <span className="mt-1 block text-xs text-rose-600">{error}</span>
      ) : hint ? (
        <span className="mt-1 block text-xs text-slate-500">{hint}</span>
      ) : null}
    </label>
  );
});
