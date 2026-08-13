// steps_provider —— 步数上报与查询
//
// 设计要点：
// 1. **AsyncNotifier<List<DailyStep>>**：UI 层拿今日步数
// 2. **upsertToday**：C5+ 调 HealthKit / Health Connect 后批量上报
// 3. **错误透传**：ApiError 抛给 UI
// 4. **后端 max-value 策略**：服务端保留最大值

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_helper/api/api_error.dart';
import 'package:health_helper/providers/auth_provider.dart';

import 'package:health_helper_api/health_helper_api.dart';

final stepsProvider =
    AsyncNotifierProvider<StepsNotifier, List<DailyStep>>(StepsNotifier.new);

class StepsNotifier extends AsyncNotifier<List<DailyStep>> {
  @override
  Future<List<DailyStep>> build() async {
    final clients = ref.read(apiClientsProvider);
    try {
      final resp = await clients.dio.get<dynamic>('/api/exercises/steps');
      final raw = resp.data;
      if (raw is! List) return const [];
      return raw
          .map((e) => standardSerializers.deserializeWith(
                DailyStep.serializer,
                e as Map,
              ) as DailyStep)
          .toList();
    } on DioException catch (e) {
      final apiErr = e.error is ApiError ? e.error as ApiError : null;
      throw apiErr ??
          ApiError(code: 'NETWORK_ERROR', message: e.message ?? 'fetch failed');
    }
  }

  /// 上报今日步数（服务端 max-value 策略）
  Future<void> upsertToday({
    required int steps,
    DateTime? date,
  }) async {
    final clients = ref.read(apiClientsProvider);
    try {
      final resp = await clients.dio.post<dynamic>(
        '/api/exercises/steps',
        data: {
          'steps': steps,
          if (date != null) 'date': date.toIso8601String(),
        },
      );
      final raw = resp.data;
      if (raw is! Map) return;
      final record = standardSerializers.deserializeWith(
        DailyStep.serializer,
        raw,
      ) as DailyStep;

      // 替换/插入：按 date 去重
      final current = state.value ?? [];
      final filtered =
          current.where((s) => s.date != record.date).toList();
      state = AsyncData([record, ...filtered]);
    } on DioException catch (e) {
      final apiErr = e.error is ApiError ? e.error as ApiError : null;
      throw apiErr ??
          ApiError(code: 'NETWORK_ERROR', message: e.message ?? 'upsert failed');
    }
  }
}