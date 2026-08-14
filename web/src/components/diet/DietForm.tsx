import { useState, useMemo } from 'react';
import { useSearchFoods, useCreateDietRecord } from '@/hooks/useDiet';
import { Button } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';
import { Spinner } from '@/components/ui/Spinner';
import { MEAL_LABEL, MEAL_EMOJI } from '@/lib/icons';
import { useUiStore } from '@/stores/uiStore';
import clsx from 'clsx';

const MEAL_TYPES = ['breakfast', 'lunch', 'dinner', 'snack'] as const;

export function DietForm() {
  const [q, setQ] = useState('');
  const [debounced, setDebounced] = useState('');
  const [mealType, setMealType] = useState<typeof MEAL_TYPES[number]>('lunch');
  const [foodId, setFoodId] = useState<number | null>(null);
  const [servings, setServings] = useState<number>(1);
  const create = useCreateDietRecord();
  const pushToast = useUiStore((s) => s.pushToast);

  // 简单 debounce
  useMemo(() => {
    const t = setTimeout(() => setDebounced(q), 300);
    return () => clearTimeout(t);
  }, [q]);

  const foodsQ = useSearchFoods(debounced);
  const foods = foodsQ.data?.foods ?? [];
  const selected = foods.find((f) => f.id === foodId);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!foodId || servings <= 0) return;
    try {
      const rec = await create.mutateAsync({
        foodId,
        mealType,
        servings,
      });
      pushToast('success', `已记录 ${MEAL_LABEL[mealType]}：${(rec.consumed?.kcal ?? 0).toFixed(0)} kcal`);
      setFoodId(null);
      setServings(1);
    } catch (err) {
      pushToast('error', (err as Error).message || '记录失败');
    }
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      {/* 餐别 */}
      <div>
        <label className="mb-2 block text-sm font-medium text-slate-700">餐别</label>
        <div className="grid grid-cols-4 gap-2">
          {MEAL_TYPES.map((m) => (
            <button
              key={m}
              type="button"
              onClick={() => setMealType(m)}
              className={clsx(
                'flex flex-col items-center gap-1 rounded-xl border px-2 py-2 text-xs transition-colors',
                mealType === m
                  ? 'border-brand-500 bg-brand-50 text-brand-700'
                  : 'border-slate-200 bg-white text-slate-700 hover:border-slate-300',
              )}
            >
              <span className="text-lg">{MEAL_EMOJI[m]}</span>
              <span>{MEAL_LABEL[m]}</span>
            </button>
          ))}
        </div>
      </div>

      {/* 搜索食物 */}
      <div>
        <label className="mb-2 block text-sm font-medium text-slate-700">搜索食物</label>
        <Input
          type="search"
          value={q}
          onChange={(e) => setQ(e.target.value)}
          placeholder="米饭 / 鸡胸肉 / 苹果"
        />
        {debounced && (
          <div className="mt-2 max-h-56 overflow-y-auto rounded-xl border border-slate-100 bg-white">
            {foodsQ.isFetching ? (
              <div className="flex items-center justify-center py-4">
                <Spinner size="sm" />
              </div>
            ) : foods.length === 0 ? (
              <p className="px-3 py-4 text-center text-sm text-slate-400">未找到食物</p>
            ) : (
              <ul className="divide-y divide-slate-100">
                {foods.map((f) => (
                  <li key={f.id}>
                    <button
                      type="button"
                      onClick={() => f.id != null && setFoodId(f.id)}
                      className={clsx(
                        'flex w-full items-center justify-between gap-2 px-3 py-2 text-left text-sm hover:bg-slate-50',
                        foodId === f.id && 'bg-brand-50',
                      )}
                    >
                      <div>
                        <div className="font-medium text-slate-800">
                          {f.nameZh ?? f.name}
                        </div>
                        {f.category && (
                          <div className="text-xs text-slate-500">{f.category}</div>
                        )}
                      </div>
                      <div className="text-right text-xs text-slate-500">
                        <div>{f.kcalPer100g?.toFixed(0)} kcal/100g</div>
                      </div>
                    </button>
                  </li>
                ))}
              </ul>
            )}
          </div>
        )}
      </div>

      {selected && (
        <div className="rounded-xl bg-slate-50 px-3 py-2 text-xs text-slate-600">
          <div className="font-medium text-slate-800">{selected.nameZh ?? selected.name}</div>
          <div className="mt-1">
            蛋白质 {selected.proteinG?.toFixed(1) ?? 0}g · 碳水 {selected.carbsG?.toFixed(1) ?? 0}g · 脂肪{' '}
            {selected.fatG?.toFixed(1) ?? 0}g
          </div>
        </div>
      )}

      <Input
        label="份数（1 份 = 100g）"
        type="number"
        min={0.1}
        max={20}
        step="0.1"
        value={servings}
        onChange={(e) => setServings(Number(e.target.value))}
        required
      />

      <Button type="submit" size="lg" className="w-full" loading={create.isPending} disabled={!foodId}>
        保存饮食
      </Button>
    </form>
  );
}
