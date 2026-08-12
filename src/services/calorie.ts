/**
 * 卡路里 / 距离计算 —— 纯函数，无副作用，便于单元测试。
 *
 * MET 公式（来源：Compendium of Physical Activities）：
 *   calories = MET × weight(kg) × duration(hour)
 *
 * 步数 → 距离估算（粗略，仅用于趋势展示，不替代运动记录）：
 *   stride_length(m) ≈ height(cm) × 0.414 / 100
 *   distance(km) = steps × stride_length / 1000
 */

import { ValidationError } from '../utils/errors';

export const DEFAULT_BODY_WEIGHT_KG = 65;

export interface CalorieInput {
  met: number;
  weightKg: number | undefined | null;
  durationSec: number;
}

export function calculateCalories(input: CalorieInput): number {
  const { met, weightKg, durationSec } = input;

  if (met < 0) {
    throw new ValidationError('MET must be non-negative', { met });
  }
  if (durationSec < 0) {
    throw new ValidationError('durationSec must be non-negative', { durationSec });
  }

  const weight = weightKg ?? DEFAULT_BODY_WEIGHT_KG;
  if (weight <= 0) {
    throw new ValidationError('weightKg must be positive when provided', { weightKg });
  }

  const durationHours = durationSec / 3600;
  const raw = met * weight * durationHours;
  // 保留 2 位小数（用 Number 防止字符串）
  return Math.round(raw * 100) / 100;
}

/**
 * 步数 → 距离（km）
 */
export function distanceFromSteps(steps: number, heightCm: number): number {
  if (steps <= 0) return 0;
  if (heightCm <= 0) {
    throw new ValidationError('heightCm must be positive', { heightCm });
  }
  const strideM = (heightCm * 0.414) / 100;
  const meters = steps * strideM;
  const km = meters / 1000;
  return Math.round(km * 100) / 100;
}

/**
 * 步数 → 卡路里（粗略估算）
 *
 * 经验值：每 1000 步 ≈ 0.04 × weightKg kcal
 * 仅用于趋势展示，不替代运动记录。
 */
export function caloriesFromSteps(steps: number, weightKg: number | undefined | null): number {
  if (steps <= 0) return 0;
  const weight = weightKg ?? DEFAULT_BODY_WEIGHT_KG;
  if (weight <= 0) {
    throw new ValidationError('weightKg must be positive when provided', { weightKg });
  }
  const raw = (steps / 1000) * 0.04 * weight;
  return Math.round(raw * 100) / 100;
}
