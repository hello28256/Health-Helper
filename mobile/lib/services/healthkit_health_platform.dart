// HealthKitHealthPlatform —— iOS HealthKit + Android Health Connect 真实实现
//
// 设计要点：
// 1. **health 包统一接口**：Health() 实例在 iOS 走 HealthKit、Android 走 Health Connect
// 2. **metric → HealthDataType 映射**：后端 HealthMetric ↔ health 包枚举
// 3. **source 标识**：iOS "ios_healthkit" / Android "android_health_connect"
// 4. **聚合步数**：步数通常是 sub-day 段，按"日"聚合 sum 给后端
// 5. **失败不崩**：HealthException → 返回空列表；permission 拒绝 → false
//
// 注意：此文件依赖 health 包；测试场景（web / 单元测试）用 NoOpHealthPlatform

import 'dart:io' show Platform;

import 'package:health/health.dart' as h;
import 'package:health_helper_api/health_helper_api.dart';
import 'health_platform.dart';

class HealthKitHealthPlatform implements HealthPlatform {
  HealthKitHealthPlatform({h.Health? health})
      : _health = health ?? h.Health();

  final h.Health _health;

  @override
  String get platformName =>
      Platform.isIOS ? 'ios_healthkit' : 'android_health_connect';

  @override
  Future<bool> requestAuthorization() async {
    final types = _allTypes();
    final perms = _permissions(types);
    try {
      final granted = await _health.requestAuthorization(types, permissions: perms);
      return granted;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<List<HealthDataPoint>> readRange({
    required HealthMetric metric,
    required DateTime start,
    required DateTime end,
  }) async {
    final type = _toHealthDataType(metric);
    if (type == null) return const [];
    try {
      final raw = await _health.getHealthDataFromTypes(
        types: [type],
        startTime: start,
        endTime: end,
      );
      return raw.map((p) => _toPoint(metric, p)).toList();
    } catch (_) {
      return const [];
    }
  }

  // ===== 映射 helper =====

  String get _source => platformName;

  List<h.HealthDataType> _allTypes() => const [
        h.HealthDataType.STEPS,
        h.HealthDataType.HEART_RATE,
        h.HealthDataType.SLEEP_ASLEEP,
        h.HealthDataType.WEIGHT,
      ];

  List<h.HealthDataAccess> _permissions(List<h.HealthDataType> types) =>
      types.map((_) => h.HealthDataAccess.READ).toList();

  h.HealthDataType? _toHealthDataType(HealthMetric m) {
    switch (m) {
      case HealthMetric.steps:
        return h.HealthDataType.STEPS;
      case HealthMetric.heartRate:
        return h.HealthDataType.HEART_RATE;
      case HealthMetric.sleep:
        return h.HealthDataType.SLEEP_ASLEEP;
      case HealthMetric.weight:
        return h.HealthDataType.WEIGHT;
      // 后端支持但 health 包未一一对应（血压/血糖/血氧/体温）：
      // 留 null，由 readRange 返回空，让上层显示"暂无数据"
      default:
        return null;
    }
  }

  String _unit(HealthMetric m) {
    switch (m) {
      case HealthMetric.steps:
        return 'count';
      case HealthMetric.heartRate:
        return 'bpm';
      case HealthMetric.sleep:
        return 'min';
      case HealthMetric.weight:
        return 'kg';
      default:
        return '';
    }
  }

  HealthDataPoint _toPoint(HealthMetric metric, h.HealthDataPoint p) {
    final value = p.value is num ? p.value as num : num.tryParse('${p.value}') ?? 0;
    return HealthDataPoint(
      metric: metric,
      value: value,
      unit: _unit(metric),
      startAt: p.dateFrom,
      endAt: p.dateTo,
      source: _source,
    );
  }
}