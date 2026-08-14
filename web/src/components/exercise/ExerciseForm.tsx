import { useState } from 'react';
import { useExerciseTypes, useCreateExercise } from '@/hooks/useExercises';
import { Button } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';
import { Spinner } from '@/components/ui/Spinner';
import { exerciseEmoji } from '@/lib/icons';
import { formatDuration, formatKcal } from '@/lib/format';
import { useUiStore } from '@/stores/uiStore';
import clsx from 'clsx';

export function ExerciseForm() {
  const typesQ = useExerciseTypes();
  const create = useCreateExercise();
  const pushToast = useUiStore((s) => s.pushToast);

  const [typeId, setTypeId] = useState<string>('');
  const [minutes, setMinutes] = useState<number>(30);
  const [distance, setDistance] = useState<string>('');
  const [startedAt, setStartedAt] = useState<string>(() => {
    const d = new Date();
    d.setSeconds(0, 0);
    return d.toISOString().slice(0, 16);
  });

  const types = typesQ.data?.types ?? [];
  const selected = types.find((t) => t.id === typeId);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!typeId || minutes <= 0) return;
    try {
      const rec = await create.mutateAsync({
        typeId,
        startedAt: new Date(startedAt).toISOString(),
        durationSec: minutes * 60,
        distanceKm: distance ? Number(distance) : undefined,
      });
      pushToast('success', `已记录 ${formatDuration(rec.durationSec ?? 0)} ${typeId}（${formatKcal(rec.calories)}）`);
      setMinutes(30);
      setDistance('');
    } catch (err) {
      pushToast('error', (err as Error).message || '记录失败');
    }
  }

  if (typesQ.isLoading) {
    return (
      <div className="flex h-40 items-center justify-center">
        <Spinner />
      </div>
    );
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      {/* 类型选择 */}
      <div>
        <label className="mb-2 block text-sm font-medium text-slate-700">运动类型</label>
        <div className="grid grid-cols-3 gap-2 sm:grid-cols-4">
          {types.map((t) => (
            <button
              key={t.id}
              type="button"
              onClick={() => t.id && setTypeId(t.id)}
              className={clsx(
                'flex flex-col items-center gap-1 rounded-xl border px-2 py-3 text-xs transition-colors',
                typeId === t.id
                  ? 'border-brand-500 bg-brand-50 text-brand-700'
                  : 'border-slate-200 bg-white text-slate-700 hover:border-slate-300',
              )}
            >
              <span className="text-2xl">{exerciseEmoji(t.id ?? '')}</span>
              <span className="font-medium">{t.displayNameZh}</span>
              <span className="text-[10px] text-slate-400">MET {t.met}</span>
            </button>
          ))}
        </div>
      </div>

      {selected?.notes && (
        <div className="rounded-xl bg-amber-50 px-3 py-2 text-xs text-amber-800">
          <strong>⚠️ 注意事项：</strong>
          <p className="mt-1 whitespace-pre-line">{selected.notes}</p>
        </div>
      )}

      <Input
        label="时长（分钟）"
        type="number"
        min={1}
        max={1440}
        value={minutes}
        onChange={(e) => setMinutes(Number(e.target.value))}
        required
      />

      <Input
        label="距离（公里，可选）"
        type="number"
        min={0}
        step="0.1"
        value={distance}
        onChange={(e) => setDistance(e.target.value)}
        placeholder="跑步/骑车可以填"
      />

      <Input
        label="开始时间"
        type="datetime-local"
        value={startedAt}
        onChange={(e) => setStartedAt(e.target.value)}
        required
      />

      <Button type="submit" size="lg" className="w-full" loading={create.isPending}>
        保存运动
      </Button>
    </form>
  );
}
