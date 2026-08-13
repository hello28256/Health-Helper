// exercises_provider —— 运动记录（跑步/健身/瑜伽 等）
//
// 设计要点：
// 1. **AsyncNotifier<List<ExerciseRecord>>**：UI 层用 ref.watch(exercisesProvider) 拿列表
// 2. **local-first**：成功添加后本地列表先更新（乐观更新），失败则回滚
// 3. **DTO 复用**：用 /api/exercises 的 GET /api/exercises/POST 端点
// 4. **错误透传**：ApiError 抛给 UI 层处理

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_helper/api/api_error.dart';
import 'package:health_helper/providers/auth_provider.dart';

import 'package:health_helper_api/health_helper_api.dart';

/// exercisesProvider —— 异步拉取运动记录列表
final exercisesProvider =
    AsyncNotifierProvider<ExercisesNotifier, List<ExerciseRecord>>(
  ExercisesNotifier.new,
);

class ExercisesNotifier extends AsyncNotifier<List<ExerciseRecord>> {
  @override
  Future<List<ExerciseRecord>> build() async {
    final clients = ref.read(apiClientsProvider);
    try {
      final resp = await clients.dio.get<dynamic>('/api/exercises');
      final raw = resp.data;
      if (raw is! List) return const [];
      return raw
          .map((e) => standardSerializers.deserializeWith(
                ExerciseRecord.serializer,
                e as Map,
              ) as ExerciseRecord)
          .toList();
    } on DioException catch (e) {
      final apiErr = e.error is ApiError ? e.error as ApiError : null;
      throw apiErr ?? ApiError(code: 'NETWORK_ERROR', message: e.message ?? 'fetch failed');
    }
  }

  /// 添加运动记录
  Future<void> addExercise({
    required String type,
    required int durationMin,
    required int kcal,
    DateTime? startedAt,
  }) async {
    final clients = ref.read(apiClientsProvider);
    try {
      final resp = await clients.dio.post<dynamic>(
        '/api/exercises',
        data: {
          'type': type,
          'durationMin': durationMin,
          'kcal': kcal,
          if (startedAt != null) 'startedAt': startedAt.toIso8601String(),
        },
      );
      final raw = resp.data;
      if (raw is! Map) return;
      final record = standardSerializers.deserializeWith(
        ExerciseRecord.serializer,
        raw,
      ) as ExerciseRecord;

      // 乐观更新：插到列表头部
      final current = state.value ?? [];
      state = AsyncData([record, ...current]);
    } on DioException catch (e) {
      final apiErr = e.error is ApiError ? e.error as ApiError : null;
      throw apiErr ?? ApiError(code: 'NETWORK_ERROR', message: e.message ?? 'add failed');
    }
  }
}
