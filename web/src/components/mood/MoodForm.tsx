import { useState } from 'react';
import { useCreateMood } from '@/hooks/useMood';
import { MOOD_LABELS, type MoodType } from '@/api/mood';
import { Button } from '@/components/ui/Button';
import { useUiStore } from '@/stores/uiStore';
import clsx from 'clsx';

const MOOD_TYPES: MoodType[] = ['happy', 'calm', 'grateful', 'excited', 'tired', 'sad', 'anxious', 'angry'];

export function MoodForm() {
  const [mood, setMood] = useState<MoodType | null>(null);
  const [score, setScore] = useState<number>(7);
  const [note, setNote] = useState<string>('');
  const create = useCreateMood();
  const pushToast = useUiStore((s) => s.pushToast);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!mood) return;
    try {
      await create.mutateAsync({ mood, score, note: note || undefined });
      pushToast('success', '已记录情绪');
      setMood(null);
      setScore(7);
      setNote('');
    } catch (err) {
      pushToast('error', (err as Error).message || '记录失败');
    }
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div>
        <label className="mb-2 block text-sm font-medium text-slate-700">现在感觉如何？</label>
        <div className="grid grid-cols-4 gap-2">
          {MOOD_TYPES.map((m) => (
            <button
              key={m}
              type="button"
              onClick={() => setMood(m)}
              className={clsx(
                'flex flex-col items-center gap-1 rounded-xl border px-2 py-2 text-xs transition-colors',
                mood === m
                  ? 'border-mood-500 bg-mood-50 text-mood-700'
                  : 'border-slate-200 bg-white text-slate-700 hover:border-slate-300',
              )}
            >
              <span className="text-2xl">{MOOD_LABELS[m].emoji}</span>
              <span>{MOOD_LABELS[m].zh}</span>
            </button>
          ))}
        </div>
      </div>

      <div>
        <label className="mb-2 flex items-baseline justify-between text-sm font-medium text-slate-700">
          <span>强度评分</span>
          <span className="text-brand-600">{score}/10</span>
        </label>
        <input
          type="range"
          min={1}
          max={10}
          value={score}
          onChange={(e) => setScore(Number(e.target.value))}
          className="w-full accent-mood-600"
        />
        <div className="flex justify-between text-[10px] text-slate-400">
          <span>低</span>
          <span>中</span>
          <span>高</span>
        </div>
      </div>

      <div>
        <label className="mb-1 block text-sm font-medium text-slate-700">备注（可选）</label>
        <textarea
          value={note}
          onChange={(e) => setNote(e.target.value)}
          rows={3}
          maxLength={2000}
          className="w-full rounded-xl border border-slate-200 bg-white px-3 py-2 text-sm placeholder:text-slate-400 focus:border-mood-500 focus:outline-none focus:ring-2 focus:ring-mood-500/20"
          placeholder="今天发生了什么？"
        />
      </div>

      <Button
        type="submit"
        size="lg"
        className="w-full bg-mood-600 hover:bg-mood-600/90"
        loading={create.isPending}
        disabled={!mood}
      >
        保存情绪
      </Button>
    </form>
  );
}
