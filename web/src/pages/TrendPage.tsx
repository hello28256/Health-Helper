import { useMemo, useState } from 'react';
import { Card } from '@/components/ui/Card';
import { Tabs, type TabItem } from '@/components/ui/Tabs';
import { Spinner } from '@/components/ui/Spinner';
import { MoodTrendChart } from '@/components/mood/MoodTrendChart';
import { StepsBarChart } from '@/components/steps/StepsBarChart';
import { ExerciseList } from '@/components/exercise/ExerciseList';
import { useMoodTrend, useMoodList } from '@/hooks/useMood';
import { useExercises } from '@/hooks/useExercises';
import { daysAgo, todayDateKey, formatDate } from '@/lib/format';

const RANGE_TABS: TabItem[] = [
  { id: '7', label: '近 7 天' },
  { id: '30', label: '近 30 天' },
];

export function TrendPage() {
  const [days, setDays] = useState(7);
  const { from, to } = useMemo(() => {
    const end = new Date();
    end.setHours(23, 59, 59, 999);
    return {
      from: daysAgo(days - 1).toISOString(),
      to: end.toISOString(),
    };
  }, [days]);

  const trendQ = useMoodTrend(
    daysAgo(days - 1).toISOString().slice(0, 10),
    todayDateKey(),
  );
  const exercisesQ = useExercises(from, to);
  const moodListQ = useMoodList(from, to);

  // 步数：从运动列表里统计每天的步数 + 没记录就 0
  const stepsByDay = useMemo(() => {
    const map = new Map<string, number>();
    for (let i = 0; i < days; i++) {
      const d = daysAgo(days - 1 - i);
      map.set(todayDateKey(d), 0);
    }
    // 步数实际来自 DailyStep 表，前端目前没单独拉 —— 简化：从 exerciseRecords 里取不到步数
    // 真实场景应拉 /api/exercises/steps?from&to，但目前没这接口，先留空
    return Array.from(map.entries()).map(([date, steps]) => ({ date, steps }));
  }, [days]);

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <h1 className="text-xl font-bold text-slate-800">趋势</h1>
        <Tabs
          tabs={RANGE_TABS}
          active={String(days)}
          onChange={(id) => setDays(Number(id))}
        />
      </div>

      <Card title="情绪评分" subtitle={`${formatDate(from)} ~ ${formatDate(to)}`}>
        {trendQ.isLoading ? (
          <div className="flex h-48 items-center justify-center">
            <Spinner />
          </div>
        ) : (
          <MoodTrendChart trend={trendQ.data?.trend ?? []} />
        )}
      </Card>

      <Card title="每日步数" subtitle="颜色 = 是否达成 10000 步目标">
        {stepsByDay.every((d) => d.steps === 0) ? (
          <p className="py-6 text-center text-sm text-slate-400">
            近 {days} 天没有步数记录，去 <a href="/record" className="text-brand-600 hover:underline">记录页</a> 补录吧
          </p>
        ) : (
          <StepsBarChart data={stepsByDay} />
        )}
      </Card>

      <Card title="运动历史" subtitle={`共 ${exercisesQ.data?.records.length ?? 0} 条`}>
        {exercisesQ.isLoading ? (
          <div className="flex h-16 items-center justify-center">
            <Spinner />
          </div>
        ) : (
          <ExerciseList
            records={exercisesQ.data?.records ?? []}
            emptyHint={`近 ${days} 天没有运动记录`}
          />
        )}
      </Card>

      <Card title="情绪记录" subtitle={`共 ${moodListQ.data?.records.length ?? 0} 条`}>
        {moodListQ.isLoading ? (
          <div className="flex h-16 items-center justify-center">
            <Spinner />
          </div>
        ) : (
          <div className="space-y-2">
            {(moodListQ.data?.records ?? []).slice(0, 10).map((r) => (
              <div key={r.id} className="flex items-center gap-3 text-sm">
                <span className="text-base">😊</span>
                <div className="flex-1">
                  <div className="text-slate-700">{r.mood}</div>
                  {r.note && <div className="text-xs text-slate-500">{r.note}</div>}
                </div>
                <span className="text-xs text-slate-400">
                  {formatDate(r.recordedAt)}
                </span>
              </div>
            ))}
          </div>
        )}
      </Card>
    </div>
  );
}
