/**
 * 情绪记录列表
 */
import type { MoodRecord } from '@/api/mood';
import { moodEmoji, moodLabel, formatTime } from '@/lib/format';

type Props = { records: MoodRecord[]; emptyHint?: string };

export function MoodList({ records, emptyHint = '今天还没记录情绪' }: Props) {
  if (records.length === 0) {
    return <p className="py-4 text-center text-sm text-slate-400">{emptyHint}</p>;
  }
  return (
    <ul className="space-y-2">
      {records.map((r) => (
        <li key={r.id} className="flex items-start gap-3 rounded-xl bg-slate-50 px-3 py-2 text-sm">
          <span className="text-xl">{moodEmoji(r.mood ?? '')}</span>
          <div className="flex-1">
            <div className="flex items-baseline gap-2">
              <span className="font-medium text-slate-800">{moodLabel(r.mood ?? '')}</span>
              {r.score != null && (
                <span className="text-xs text-slate-500">{r.score}/10</span>
              )}
            </div>
            {r.note && <p className="mt-0.5 text-xs text-slate-600">{r.note}</p>}
          </div>
          <span className="text-xs text-slate-400">{formatTime(r.recordedAt)}</span>
        </li>
      ))}
    </ul>
  );
}
