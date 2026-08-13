// HealthPlatform —— 健康数据平台抽象层
//
// 设计要点：
// 1. **抽象接口**：UI/业务层不直接依赖 `health` 包，便于在 F2/F3 之前先跑通 mock 测试
// 2. **HealthDataPoint**：业务友好的统一 DTO（type + value + unit + start/end + source）
// 3. **请求权限 / 读最近 7 天**：单一入口，平台分支在实现类里
// 4. **source 标识**：iOS "ios_healthkit" / Android "android_health_connect"，写入后端 HealthRecord.source

import 'package:health_helper/providers/health_provider.dart' show HealthRecordInput;
import 'package:health_helper_api/health_helper_api.dart';

/// 业务无关的健康数据点（与后端 HealthRecord 解耦）
class HealthDataPoint {
  const HealthDataPoint({
    required this.metric,
    required this.value,
    required this.unit,
    required this.startAt,
    this.endAt,
    required this.source,
  });

  final HealthMetric metric;
  final num value;
  final String unit;
  final DateTime startAt;
  final DateTime? endAt;
  final String source; // "ios_healthkit" | "android_health_connect" | "manual"

  /// 转成 HealthRecordInput（health_provider 提供）
  HealthRecordInput toInput() => HealthRecordInput(
        source: source,
        unit: unit,
        startAt: startAt,
        metric: metric,
        value: value,
        endAt: endAt,
      );
}

/// 健康数据平台接口（生产实现走 health 包的 HealthFactory；测试用 mock）
abstract class HealthPlatform {
  /// 请求权限（iOS HealthKit / Android Health Connect）
  /// 返回 true 表示全部授权成功
  Future<bool> requestAuthorization();

  /// 读取指定 metric 在 [start, end] 区间的全部数据点
  Future<List<HealthDataPoint>> readRange({
    required HealthMetric metric,
    required DateTime start,
    required DateTime end,
  });

  /// 平台名（iOS / Android / unsupported）
  String get platformName;
}

/// 默认实现占位（在 F2/F3 用 health 包替换）
/// 仅用于 web / 测试环境
class NoOpHealthPlatform implements HealthPlatform {
  @override
  Future<bool> requestAuthorization() async => false;

  @override
  Future<List<HealthDataPoint>> readRange({
    required HealthMetric metric,
    required DateTime start,
    required DateTime end,
  }) async =>
      const [];

  @override
  String get platformName => 'unsupported';
}