/**
 * StepsRing —— 今日步数圆环
 * 目标 10000 步（WHO 通用建议）
 */
import { formatSteps } from '@/lib/format';

type Props = {
  steps: number;
  goal?: number;
};

export function StepsRing({ steps, goal = 10_000 }: Props) {
  const pct = Math.min(100, (steps / goal) * 100);
  const r = 60;
  const c = 2 * Math.PI * r;
  const offset = c * (1 - pct / 100);

  return (
    <div className="flex items-center gap-4">
      <div className="relative h-36 w-36 shrink-0">
        <svg viewBox="0 0 150 150" className="h-full w-full -rotate-90">
          <circle
            cx="75"
            cy="75"
            r={r}
            stroke="#e2e8f0"
            strokeWidth="12"
            fill="none"
          />
          <circle
            cx="75"
            cy="75"
            r={r}
            stroke="#16a34a"
            strokeWidth="12"
            fill="none"
            strokeDasharray={c}
            strokeDashoffset={offset}
            strokeLinecap="round"
            className="transition-all duration-500"
          />
        </svg>
        <div className="absolute inset-0 flex flex-col items-center justify-center">
          <span className="text-2xl font-bold text-slate-800">{formatSteps(steps)}</span>
          <span className="text-xs text-slate-500">/ {formatSteps(goal)}</span>
        </div>
      </div>
      <div className="flex-1 text-sm text-slate-600">
        <p className="font-medium text-slate-700">今日步数</p>
        <p className="mt-1 text-xs text-slate-500">
          还差 <span className="font-semibold text-brand-600">{formatSteps(Math.max(0, goal - steps))}</span> 步
        </p>
        <p className="mt-1 text-xs text-slate-500">步行是最简单的运动</p>
      </div>
    </div>
  );
}
