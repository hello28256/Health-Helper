// health_provider —— 健康数据记录（HealthKit / Health Connect 上报）
//
// 设计要点：
// 1. **按 metric 缓存**：每个 metric 独立 AsyncNotifier，心率/睡眠/步数互不干扰
// 2. **批量上报**：HealthKit 一次会拉 7 天数据，POST /api/health/records 一次性推上去
// 3. **latest 单点查询**：仪表盘拿"最近一次心率"等单值
// 4. **HealthRecordInput**：UI 友好的输入 DTO，与生成的 HealthRecord 解耦（避免 UI 直接依赖 wire 字段）

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_helper/api/api_error.dart';
import 'package:health_helper/providers/auth_provider.dart';

import 'package:health_helper_api/health_helper_api.dart';

/// 上报输入 DTO（UI 层友好接口）
class HealthRecordInput {
  const HealthRecordInput({
    required this.source,
    required this.unit,
    required this.startAt,
    required this.metric,
    required this.value,
    this.endAt,
    this.raw,
  });

  final HealthMetric metric;
  final num value;
  final String unit;
  final DateTime startAt;
  final DateTime? endAt;
  final String source; // "ios_healthkit" | "android_health_connect" | "manual"
  final Map<String, Object?>? raw; // 高血压含 systolic/diastolic

  /// 序列化为后端 wire 格式
  Map<String, dynamic> toJson() => {
        'metric': metric.name,
        'value': value,
        'unit': unit,
        'startAt': startAt.toIso8601String(),
        if (endAt != null) 'endAt': endAt!.toIso8601String(),
        'source': source,
        if (raw != null) 'raw': raw,
      };
}

/// 按 metric 分桶的健康记录列表
final healthRecordsProvider = AsyncNotifierProvider.family<
    HealthRecordsNotifier, List<HealthRecord>, HealthMetric>(
  HealthRecordsNotifier.new,
);

class HealthRecordsNotifier
    extends FamilyAsyncNotifier<List<HealthRecord>, HealthMetric> {
  @override
  Future<List<HealthRecord>> build(HealthMetric arg) async {
    final clients = ref.read(apiClientsProvider);
    try {
      final resp = await clients.dio.get<dynamic>(
        '/api/health/records',
        queryParameters: {'metric': arg.name},
      );
      final raw = resp.data;
      if (raw is! Map) return const [];
      final list = raw['records'];
      if (list is! List) return const [];
      return list
          .map((e) => standardSerializers.deserializeWith(
                HealthRecord.serializer,
                e as Map,
              ) as HealthRecord)
          .toList();
    } on DioException catch (e) {
      final apiErr = e.error is ApiError ? e.error as ApiError : null;
      throw apiErr ??
          ApiError(code: 'NETWORK_ERROR', message: e.message ?? 'fetch failed');
    }
  }

  /// 批量上报健康数据
  Future<void> recordBatch(List<HealthRecordInput> inputs) async {
    final clients = ref.read(apiClientsProvider);
    try {
      final resp = await clients.dio.post<dynamic>(
        '/api/health/records',
        data: {'records': inputs.map((i) => i.toJson()).toList()},
      );
      final raw = resp.data;
      if (raw is! Map) return;
      final list = raw['records'];
      if (list is! List) return;

      final created = list
          .map((e) => standardSerializers.deserializeWith(
                HealthRecord.serializer,
                e as Map,
              ) as HealthRecord)
          .toList();

      // 合并：替换同 metric 的现有项
      final current = state.value ?? [];
      final newIds = created.map((c) => c.id).toSet();
      final filtered = current.where((c) => !newIds.contains(c.id)).toList();
      state = AsyncData([...created, ...filtered]);
    } on DioException catch (e) {
      final apiErr = e.error is ApiError ? e.error as ApiError : null;
      throw apiErr ??
          ApiError(code: 'NETWORK_ERROR', message: e.message ?? 'upload failed');
    }
  }
}

/// 最近一条某 metric 记录（仪表盘用）
final latestRecordProvider =
    FutureProvider.family<HealthRecord?, HealthMetric>((ref, metric) async {
  final clients = ref.read(apiClientsProvider);
  try {
    final resp = await clients.dio.get<dynamic>(
      '/api/health/records/latest',
      queryParameters: {'metric': metric.name},
    );
    final raw = resp.data;
    if (raw is! Map) return null;
    final recordRaw = raw['record'];
    if (recordRaw is! Map) return null;
    return standardSerializers.deserializeWith(
      HealthRecord.serializer,
      recordRaw,
    ) as HealthRecord;
  } on DioException catch (e) {
    final apiErr = e.error is ApiError ? e.error as ApiError : null;
    throw apiErr ??
        ApiError(code: 'NETWORK_ERROR', message: e.message ?? 'fetch failed');
  }
});