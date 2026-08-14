import clsx from 'clsx';

type Props = {
  size?: 'sm' | 'md' | 'lg';
  className?: string;
};

const SIZES = {
  sm: 'h-4 w-4 border-2',
  md: 'h-6 w-6 border-2',
  lg: 'h-10 w-10 border-4',
};

export function Spinner({ size = 'md', className }: Props) {
  return (
    <span
      role="status"
      aria-label="加载中"
      className={clsx(
        'inline-block animate-spin rounded-full border-current border-t-transparent text-slate-500',
        SIZES[size],
        className,
      )}
    />
  );
}

export function PageLoading() {
  return (
    <div className="flex h-[60vh] items-center justify-center">
      <Spinner size="lg" />
    </div>
  );
}
