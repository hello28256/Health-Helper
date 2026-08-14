/**
 * 运动记录列表
 */
import type { ExerciseRecord } from '@/api/exercises';
import { formatKcal, formatTime, formatDuration } from '@/lib/format';
import { exerciseEmoji } from '@/lib/icons';

type Props = { records: ExerciseRecord[]; emptyHint?: string };

export function ExerciseList({ records, emptyHint = '今天还没有运动记录' }: Props) {
  if (records.length === 0) {
    return <p className="py-4 text-center text-sm text-slate-400">{emptyHint}</p>;
  }
  return (
    <ul className="divide-y divide-slate-100">
      {records.map((r) => (
        <li key={r.id} className="flex items-center gap-3 py-2.5 text-sm">
          <span className="text-xl">{exerciseEmoji(r.typeId ?? '')}</span>
          <div className="flex-1">
            <div className="font-medium text-slate-800">{r.typeId}</div>
            <div className="text-xs text-slate-500">
              {formatTime(r.startedAt)} · {formatDuration(r.durationSec ?? 0)}
              {r.distanceKm ? ` · ${r.distanceKm} km` : ''}
            </div>
          </div>
          <div className="text-right text-sm font-semibold text-brand-600">
            {formatKcal(r.calories)}
          </div>
        </li>
      ))}
    </ul>
  );
}
