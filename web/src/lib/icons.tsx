/**
 * 运动类型 → emoji 映射
 * 后端 DTO 不返回 iconKey，前端用 id 映射
 */
import type { ExerciseType } from '@/api/exercises';

const ICON_MAP: Record<string, string> = {
  walking: '🚶',
  running: '🏃',
  cycling: '🚴',
  swimming: '🏊',
  yoga: '🧘',
  hiit: '🔥',
  strength: '🏋️',
  basketball: '🏀',
  badminton: '🏸',
};

export function exerciseEmoji(type: ExerciseType | { id?: string } | string): string {
  const id = typeof type === 'string' ? type : (type as { id?: string }).id;
  return (id && ICON_MAP[id]) || '💪';
}

export const MEAL_EMOJI: Record<'breakfast' | 'lunch' | 'dinner' | 'snack', string> = {
  breakfast: '🌅',
  lunch: '🌞',
  dinner: '🌙',
  snack: '🍎',
};

export const MEAL_LABEL: Record<'breakfast' | 'lunch' | 'dinner' | 'snack', string> = {
  breakfast: '早餐',
  lunch: '午餐',
  dinner: '晚餐',
  snack: '加餐',
};
