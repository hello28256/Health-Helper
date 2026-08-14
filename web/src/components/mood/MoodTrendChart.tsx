/**
 * 情绪趋势图（折线图 + 散点）
 */
import { LineChart, Line, XAxis, YAxis, Tooltip, ResponsiveContainer, ReferenceLine } from 'recharts';
import type { MoodTrendPoint } from '@/api/mood';
import { formatDate } from '@/lib/format';

type Props = { trend: MoodTrendPoint[] };

export function MoodTrendChart({ trend }: Props) {
  const data = trend
    .filter((t) => t.avgScore != null)
    .map((t) => ({
      date: t.date,
      label: formatDate(t.date, { month: '2-digit', day: '2-digit' }),
      score: t.avgScore,
    }));

  if (data.length === 0) {
    return (
      <p className="py-6 text-center text-sm text-slate-400">
        近 7 天没有情绪评分数据
      </p>
    );
  }

  return (
    <div className="h-48 w-full">
      <ResponsiveContainer width="100%" height="100%">
        <LineChart data={data} margin={{ top: 8, right: 8, left: -16, bottom: 0 }}>
          <XAxis dataKey="label" tickLine={false} axisLine={false} />
          <YAxis domain={[0, 10]} tickLine={false} axisLine={false} />
          <Tooltip
            contentStyle={{ borderRadius: 8, fontSize: 12, border: '1px solid #e2e8f0' }}
            formatter={(v: number) => [`${v.toFixed(1)}/10`, '平均评分']}
          />
          <ReferenceLine y={5} stroke="#cbd5e1" strokeDasharray="3 3" />
          <Line
            type="monotone"
            dataKey="score"
            stroke="#a855f7"
            strokeWidth={2.5}
            dot={{ r: 3, fill: '#a855f7' }}
            activeDot={{ r: 5 }}
          />
        </LineChart>
      </ResponsiveContainer>
    </div>
  );
}
