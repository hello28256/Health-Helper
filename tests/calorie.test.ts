// 卡路里计算器（MET 公式）单元测试
// 公式：calories = MET × weight(kg) × duration(hour)
// 详见 ARCHITECTURE.md §5.1

import { calculateCalories, DEFAULT_BODY_WEIGHT_KG } from '../src/services/calorie';

describe('calculateCalories', () => {
  it('computes correctly for known MET values', () => {
    // 跑步 MET=9.8，体重 70kg，30 分钟（0.5h）
    // 9.8 × 70 × 0.5 = 343
    expect(calculateCalories({ met: 9.8, weightKg: 70, durationSec: 30 * 60 })).toBeCloseTo(343, 1);
  });

  it('handles walking (MET=4.3) for 1 hour', () => {
    // 4.3 × 60 × 1 = 258
    expect(calculateCalories({ met: 4.3, weightKg: 60, durationSec: 3600 })).toBeCloseTo(258, 1);
  });

  it('returns 0 for 0 duration', () => {
    expect(calculateCalories({ met: 5, weightKg: 70, durationSec: 0 })).toBe(0);
  });

  it('uses default body weight when weightKg is undefined', () => {
    // 5 × DEFAULT × 0.5
    const expected = 5 * DEFAULT_BODY_WEIGHT_KG * 0.5;
    expect(calculateCalories({ met: 5, weightKg: undefined, durationSec: 1800 })).toBeCloseTo(expected, 1);
  });

  it('throws on negative duration', () => {
    expect(() => calculateCalories({ met: 5, weightKg: 70, durationSec: -10 })).toThrow();
  });

  it('throws on negative MET', () => {
    expect(() => calculateCalories({ met: -1, weightKg: 70, durationSec: 600 })).toThrow();
  });

  it('throws on negative or zero weight when provided', () => {
    expect(() => calculateCalories({ met: 5, weightKg: 0, durationSec: 600 })).toThrow();
    expect(() => calculateCalories({ met: 5, weightKg: -1, durationSec: 600 })).toThrow();
  });

  it('rounds to 2 decimal places', () => {
    // 3.7 × 65 × 0.25 = 60.125
    const result = calculateCalories({ met: 3.7, weightKg: 65, durationSec: 900 });
    expect(result).toBe(60.13); // banker's rounding might differ; we use toFixed 2
  });
});

describe('distanceFromSteps', () => {
  it('estimates distance using stride length from height', () => {
    // stride ≈ height_cm × 0.414 / 100 (m)
    // height 175 → stride ≈ 0.7245 m
    // 10000 steps → 7245 m ≈ 7.25 km
    const { distanceFromSteps } = require('../src/services/calorie');
    const km = distanceFromSteps(10000, 175);
    expect(km).toBeGreaterThan(7.0);
    expect(km).toBeLessThan(7.5);
  });

  it('returns 0 for 0 steps', () => {
    const { distanceFromSteps } = require('../src/services/calorie');
    expect(distanceFromSteps(0, 175)).toBe(0);
  });
});
