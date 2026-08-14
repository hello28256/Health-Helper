import { useMemo } from 'react';
import { Link } from 'react-router-dom';
import { Card } from '@/components/ui/Card';
import { Spinner } from '@/components/ui/Spinner';
import { StepsRing } from '@/components/steps/StepsRing';
import { DietSummary } from '@/components/diet/DietSummary';
import { ExerciseList } from '@/components/exercise/ExerciseList';
import { MoodList } from '@/components/mood/MoodList';
import { useTodaySteps } from '@/hooks/useExercises';
import { useDietSummary } from '@/hooks/useDiet';
import { useExercises } from '@/hooks/useExercises';
import { useMoodList } from '@/hooks/useMood';
import { useAuth } from '@/hooks/useAuth';
import { todayDateKey, formatDate } from '@/lib/format';

export function DashboardPage() {
  const { user } = useAuth();
  const today = useMemo(() => todayDateKey(), []);
  const todayStart = useMemo(() => {
    const d = new Date();
    d.setHours(0, 0, 0, 0);
    return d.toISOString();
  }, []);
  const todayEnd = useMemo(() => {
    const d = new Date();
    d.setHours(23, 59, 59, 999);
    return d.toISOString();
  }, []);

  const stepsQ = useTodaySteps();
  const dietQ = useDietSummary(today);
  const exerciseQ = useExercises(todayStart, todayEnd);
  const moodQ = useMoodList(todayStart, todayEnd);

  return (
    <div className="space-y-4">
      {/* 欢迎 */}
      <div className="flex items-baseline justify-between">
        <div>
          <h1 className="text-xl font-bold text-slate-800">
            {user?.displayName ? `你好，${user.displayName}` : '你好 👋'}
          </h1>
          <p className="text-xs text-slate-500">{formatDate(new Date().toISOString())}</p>
        </div>
        <Link to="/record" className="text-sm text-brand-600 hover:underline">
          + 记录
        </Link>
      </div>

      {/* 步数环 */}
      <Card title="今日步数">
        {stepsQ.isLoading ? (
          <div className="flex h-36 items-center justify-center">
            <Spinner />
          </div>
        ) : stepsQ.isError ? (
          <p className="text-sm text-rose-500">步数加载失败</p>
        ) : (
          <StepsRing steps={stepsQ.data?.steps ?? 0} />
        )}
      </Card>

      {/* 饮食汇总 */}
      <Card title="今日饮食" right={<Link to="/record" className="text-xs text-brand-600 hover:underline">添加</Link>}>
        {dietQ.isLoading ? (
          <div className="flex h-20 items-center justify-center">
            <Spinner />
          </div>
        ) : (
          <DietSummary summary={dietQ.data} />
        )}
      </Card>

      {/* 最近运动 */}
      <Card title="今天的运动" subtitle="按时间倒序">
        {exerciseQ.isLoading ? (
          <div className="flex h-16 items-center justify-center">
            <Spinner />
          </div>
        ) : (
          <ExerciseList records={exerciseQ.data?.records ?? []} />
        )}
      </Card>

      {/* 情绪打卡 */}
      <Card title="今天的情绪">
        {moodQ.isLoading ? (
          <div className="flex h-16 items-center justify-center">
            <Spinner />
          </div>
        ) : (
          <MoodList records={moodQ.data?.records ?? []} />
        )}
      </Card>
    </div>
  );
}
