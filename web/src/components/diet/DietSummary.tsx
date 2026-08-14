/**
 * 今日饮食汇总卡
 */
import type { DailyNutritionSummary } from '@/api/diet';
import { formatKcal, formatNumber } from '@/lib/format';
import { MEAL_EMOJI, MEAL_LABEL } from '@/lib/icons';

type Props = { summary: DailyNutritionSummary | undefined };

export function DietSummary({ summary }: Props) {
  if (!summary) return <div className="text-sm text-slate-400">暂无数据</div>;

  const meals = (['breakfast', 'lunch', 'dinner', 'snack'] as const).map((m) => ({
    key: m,
    label: MEAL_LABEL[m],
    emoji: MEAL_EMOJI[m],
    kcal: summary.byMeal?.[m]?.kcal ?? 0,
    count: summary.byMeal?.[m]?.recordCount ?? 0,
  }));

  return (
    <div>
      <div className="flex items-end justify-between">
        <div>
          <div className="text-3xl font-bold text-slate-800">{formatKcal(summary.kcal)}</div>
          <div className="text-xs text-slate-500">
            蛋白质 {formatNumber(summary.proteinG)}g · 碳水 {formatNumber(summary.carbsG)}g · 脂肪{' '}
            {formatNumber(summary.fatG)}g
          </div>
        </div>
        <div className="text-xs text-slate-400">{summary.recordCount} 条记录</div>
      </div>
      <div className="mt-3 grid grid-cols-4 gap-2 text-center text-xs">
        {meals.map((m) => (
          <div key={m.key} className="rounded-xl bg-slate-50 px-1 py-2">
            <div className="text-base">{m.emoji}</div>
            <div className="mt-0.5 text-slate-500">{m.label}</div>
            <div className="mt-0.5 font-medium text-slate-700">
              {m.kcal > 0 ? formatKcal(m.kcal) : '—'}
            </div>
            <div className="text-[10px] text-slate-400">{m.count} 条</div>
          </div>
        ))}
      </div>
    </div>
  );
}
