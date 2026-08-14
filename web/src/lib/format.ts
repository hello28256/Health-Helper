/**
 * 数字 / 日期 / 卡路里格式化（中文 locale）
 */
import type { MoodType } from '@/api/mood';

export function formatNumber(n: number | null | undefined, opts?: Intl.NumberFormatOptions): string {
  return new Intl.NumberFormat('zh-CN', opts).format(n ?? 0);
}

export function formatKcal(n: number | null | undefined): string {
  return `${formatNumber(Math.round(n ?? 0))} kcal`;
}

export function formatSteps(n: number | null | undefined): string {
  return formatNumber(n);
}

export function formatDate(iso: string | undefined, opts: Intl.DateTimeFormatOptions = {}): string {
  if (!iso) return '';
  return new Intl.DateTimeFormat('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    ...opts,
  }).format(new Date(iso));
}

export function formatTime(iso: string | undefined): string {
  if (!iso) return '';
  return new Intl.DateTimeFormat('zh-CN', {
    hour: '2-digit',
    minute: '2-digit',
  }).format(new Date(iso));
}

export function formatDateTime(iso: string): string {
  return new Intl.DateTimeFormat('zh-CN', {
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
  }).format(new Date(iso));
}

export function formatDuration(sec: number): string {
  if (sec < 60) return `${sec} 秒`;
  if (sec < 3600) return `${Math.round(sec / 60)} 分钟`;
  const h = Math.floor(sec / 3600);
  const m = Math.round((sec % 3600) / 60);
  return m > 0 ? `${h} 小时 ${m} 分` : `${h} 小时`;
}

export function todayDateKey(d: Date = new Date()): string {
  // 当地时区的 YYYY-MM-DD
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  return `${y}-${m}-${day}`;
}

export function daysAgo(n: number): Date {
  const d = new Date();
  d.setDate(d.getDate() - n);
  d.setHours(0, 0, 0, 0);
  return d;
}

export function moodEmoji(mood: MoodType | string): string {
  const map: Record<string, string> = {
    happy: '😊',
    calm: '😌',
    sad: '😢',
    anxious: '😰',
    angry: '😠',
    tired: '😴',
    grateful: '🙏',
    excited: '🤩',
  };
  return map[mood] ?? '🙂';
}

export function moodLabel(mood: MoodType | string): string {
  const map: Record<string, string> = {
    happy: '开心',
    calm: '平静',
    sad: '难过',
    anxious: '焦虑',
    angry: '生气',
    tired: '疲惫',
    grateful: '感恩',
    excited: '兴奋',
  };
  return map[mood] ?? mood;
}

/** 距离今天 N 天的日期键数组（倒序：今天、N-1、...、0） */
export function lastNDates(n: number, end: Date = new Date()): string[] {
  const out: string[] = [];
  for (let i = 0; i < n; i++) {
    const d = new Date(end);
    d.setDate(d.getDate() - i);
    out.push(todayDateKey(d));
  }
  return out.reverse();
}
