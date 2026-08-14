/**
 * 步数柱状图（最近 N 天）
 */
import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer, ReferenceLine, Cell } from 'recharts';
import { formatDate } from '@/lib/format';

type DayStep = { date: string; steps: number };

type Props = { data: DayStep[]; goal?: number };

export function StepsBarChart({ data, goal = 10_000 }: Props) {
  const chart = data.map((d) => ({
    date: d.date,
    label: formatDate(d.date, { month: '2-digit', day: '2-digit' }),
    steps: d.steps,
    hit: d.steps >= goal,
  }));

  if (chart.length === 0) {
    return <p className="py-6 text-center text-sm text-slate-400">近 7 天没有步数数据</p>;
  }

  return (
    <div className="h-48 w-full">
      <ResponsiveContainer width="100%" height="100%">
        <BarChart data={chart} margin={{ top: 8, right: 8, left: -16, bottom: 0 }}>
          <XAxis dataKey="label" tickLine={false} axisLine={false} />
          <YAxis tickLine={false} axisLine={false} />
          <Tooltip
            contentStyle={{ borderRadius: 8, fontSize: 12, border: '1px solid #e2e8f0' }}
            formatter={(v: number) => [v.toLocaleString(), '步数']}
          />
          <ReferenceLine y={goal} stroke="#16a34a" strokeDasharray="3 3" label={{ value: '目标', position: 'right', fontSize: 10, fill: '#16a34a' }} />
          <Bar dataKey="steps" radius={[4, 4, 0, 0]}>
            {chart.map((d, i) => (
              <Cell key={i} fill={d.hit ? '#16a34a' : '#cbd5e1'} />
            ))}
          </Bar>
        </BarChart>
      </ResponsiveContainer>
    </div>
  );
}
