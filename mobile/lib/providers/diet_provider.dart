// diet_provider —— 饮食记录（餐食 + 食物搜索）
//
// AsyncNotifier<List<DietRecord>> + foods 搜索

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_helper/api/api_error.dart';
import 'package:health_helper/providers/auth_provider.dart';

import 'package:health_helper_api/health_helper_api.dart';

final dietProvider =
    AsyncNotifierProvider<DietNotifier, List<DietRecord>>(DietNotifier.new);

class DietNotifier extends AsyncNotifier<List<DietRecord>> {
  @override
  Future<List<DietRecord>> build() async {
    final clients = ref.read(apiClientsProvider);
    try {
      final resp = await clients.dio.get<dynamic>('/api/diet/records');
      final raw = resp.data;
      if (raw is! List) return const [];
      return raw
          .map((e) => standardSerializers.deserializeWith(
                DietRecord.serializer,
                e as Map,
              ) as DietRecord)
          .toList();
    } on DioException catch (e) {
      final apiErr = e.error is ApiError ? e.error as ApiError : null;
      throw apiErr ??
          ApiError(code: 'NETWORK_ERROR', message: e.message ?? 'fetch failed');
    }
  }

  /// 添加饮食记录
  Future<void> addDietRecord({
    required String foodName,
    required int kcal,
    DateTime? consumedAt,
    String? mealType,
  }) async {
    final clients = ref.read(apiClientsProvider);
    try {
      final resp = await clients.dio.post<dynamic>(
        '/api/diet/records',
        data: {
          'foodName': foodName,
          'kcal': kcal,
          'consumedAt': ?consumedAt?.toIso8601String(),
          'mealType': ?mealType,
        },
      );
      final raw = resp.data;
      if (raw is! Map) return;
      final record = standardSerializers.deserializeWith(
        DietRecord.serializer,
        raw,
      ) as DietRecord;

      final current = state.value ?? [];
      state = AsyncData([record, ...current]);
    } on DioException catch (e) {
      final apiErr = e.error is ApiError ? e.error as ApiError : null;
      throw apiErr ??
          ApiError(code: 'NETWORK_ERROR', message: e.message ?? 'add failed');
    }
  }
}

/// 食物搜索（FutureProvider.family）
final foodSearchProvider =
    FutureProvider.family<List<Food>, String>((ref, query) async {
  final clients = ref.read(apiClientsProvider);
  if (query.isEmpty) return const [];
  try {
    final resp = await clients.dio.get<dynamic>(
      '/api/diet/foods',
      queryParameters: {'q': query},
    );
    final raw = resp.data;
    if (raw is! List) return const [];
    return raw
        .map((e) => standardSerializers.deserializeWith(
              Food.serializer,
              e as Map,
            ) as Food)
        .toList();
  } on DioException catch (e) {
    final apiErr = e.error is ApiError ? e.error as ApiError : null;
    throw apiErr ??
        ApiError(code: 'NETWORK_ERROR', message: e.message ?? 'search failed');
  }
});
