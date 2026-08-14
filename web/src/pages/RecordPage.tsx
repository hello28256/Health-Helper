import { useState } from 'react';
import { Tabs, type TabItem } from '@/components/ui/Tabs';
import { Card } from '@/components/ui/Card';
import { ExerciseForm } from '@/components/exercise/ExerciseForm';
import { DietForm } from '@/components/diet/DietForm';
import { StepsForm } from '@/components/steps/StepsForm';
import { MoodForm } from '@/components/mood/MoodForm';

const TABS: TabItem[] = [
  { id: 'exercise', label: '运动', icon: '🏃' },
  { id: 'diet', label: '饮食', icon: '🍎' },
  { id: 'steps', label: '步数', icon: '👟' },
  { id: 'mood', label: '情绪', icon: '💗' },
];

export function RecordPage() {
  const [tab, setTab] = useState('exercise');
  return (
    <div className="space-y-4">
      <h1 className="text-xl font-bold text-slate-800">记录</h1>
      <Tabs tabs={TABS} active={tab} onChange={setTab} />
      <Card>
        {tab === 'exercise' && <ExerciseForm />}
        {tab === 'diet' && <DietForm />}
        {tab === 'steps' && <StepsForm />}
        {tab === 'mood' && <MoodForm />}
      </Card>
    </div>
  );
}
