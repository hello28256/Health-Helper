import { useState } from 'react';
import { useReportSteps } from '@/hooks/useExercises';
import { Button } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';
import { useUiStore } from '@/stores/uiStore';

export function StepsForm() {
  const [steps, setSteps] = useState<number>(5000);
  const report = useReportSteps();
  const pushToast = useUiStore((s) => s.pushToast);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    try {
      const row = await report.mutateAsync({ steps, source: 'manual' });
      pushToast('success', `已记录 ${row.steps} 步`);
    } catch (err) {
      pushToast('error', (err as Error).message || '记录失败');
    }
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div className="rounded-xl bg-brand-50 px-3 py-2 text-xs text-brand-700">
        每日 10000 步是 WHO 通用建议。手机系统会自动累计，可手动补录。
      </div>
      <Input
        label="步数"
        type="number"
        min={0}
        max={200000}
        value={steps}
        onChange={(e) => setSteps(Number(e.target.value))}
        required
      />
      <div className="grid grid-cols-3 gap-2">
        {[3000, 8000, 12000].map((n) => (
          <button
            key={n}
            type="button"
            onClick={() => setSteps(n)}
            className="rounded-xl border border-slate-200 bg-white px-2 py-2 text-sm text-slate-700 hover:border-slate-300"
          >
            {n}
          </button>
        ))}
      </div>
      <Button type="submit" size="lg" className="w-full" loading={report.isPending}>
        保存步数
      </Button>
    </form>
  );
}
