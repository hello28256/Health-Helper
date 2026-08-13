// HealthSync —— 把 HealthPlatform 数据上报到后端 steps / health_records
//
// 设计要点：
// 1. **orchestrator 层**：permission → readRange → 转 HealthRecordInput → 调 health_records.recordBatch
// 2. **DI**：构造函数收 HealthPlatform + StepsNotifier + HealthRecordsNotifier（避免直接用 ref）
// 3. **错误透传**：health 包抛的异常 → 包装成 "PERMISSION_DENIED" ApiError
// 4. **幂等**：后端用 max-value 策略，重复上报 OK

// ignore_for_file: prefer_initializing_formals

import 'package:health_helper/providers/health_provider.dart';
import 'package:health_helper/providers/steps_provider.dart';
import 'package:health_helper_api/health_helper_api.dart';
import 'health_platform.dart';

/// 同步结果
class HealthSyncResult {
  const HealthSyncResult({
    required this.metric,
    required this.uploaded,
    this.permissionDenied = false,
    this.error,
  });
  final HealthMetric metric;
  final int uploaded;
  final bool permissionDenied;
  final String? error;
}

class HealthSync {
  HealthSync({
    required this.platform,
    required Future<void> Function(HealthRecordInput) uploadOne,
    required Future<void> Function(int steps, DateTime date) upsertSteps,
  })  : uploadOne = uploadOne,
        upsertSteps = upsertSteps;

  final HealthPlatform platform;
  final Future<void> Function(HealthRecordInput) uploadOne;
  final Future<void> Function(int steps, DateTime date) upsertSteps;

  /// 单 metric 同步：请求权限 → 读 7 天 → 上报
  Future<HealthSyncResult> syncMetric({
    required HealthMetric metric,
    Duration window = const Duration(days: 7),
  }) async {
    final granted = await platform.requestAuthorization();
    if (!granted) {
      return HealthSyncResult(
        metric: metric,
        uploaded: 0,
        permissionDenied: true,
      );
    }
    final now = DateTime.now();
    List<HealthDataPoint> points;
    try {
      points = await platform.readRange(
        metric: metric,
        start: now.subtract(window),
        end: now,
      );
    } catch (e) {
      return HealthSyncResult(
        metric: metric,
        uploaded: 0,
        error: e.toString(),
      );
    }
    var count = 0;
    try {
      // 步数走专用接口（后端 max-value 策略）
      if (metric == HealthMetric.steps) {
        for (final p in points) {
          await upsertSteps(p.value.toInt(), p.startAt);
          count++;
        }
      } else {
        for (final p in points) {
          await uploadOne(p.toInput());
          count++;
        }
      }
    } catch (e) {
      return HealthSyncResult(
        metric: metric,
        uploaded: count,
        error: e.toString(),
      );
    }
    return HealthSyncResult(metric: metric, uploaded: count);
  }
}

// ===== Provider 适配器（给 HealthSync 用） =====

/// 给 steps_provider 用：把 health sync 的 (int steps, DateTime date) 转成 notifier 调用
typedef UpsertStepsFn = Future<void> Function(int steps, DateTime date);

/// 给 health_provider 用：上传单条 HealthRecordInput
typedef UploadHealthFn = Future<void> Function(HealthRecordInput input);

UpsertStepsFn upsertStepsAdapter(StepsNotifier notifier) =>
    (int steps, DateTime date) => notifier.upsertToday(steps: steps, date: date);

UploadHealthFn uploadOneAdapter(HealthRecordsNotifier notifier) =>
    (HealthRecordInput input) async {
      await notifier.recordBatch([input]);
    };