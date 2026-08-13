// mood_provider —— 情绪记录
//
// AsyncNotifier<List<MoodRecord>>

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_helper/api/api_error.dart';
import 'package:health_helper/providers/auth_provider.dart';

import 'package:health_helper_api/health_helper_api.dart';

final moodProvider =
    AsyncNotifierProvider<MoodNotifier, List<MoodRecord>>(MoodNotifier.new);

class MoodNotifier extends AsyncNotifier<List<MoodRecord>> {
  @override
  Future<List<MoodRecord>> build() async {
    final clients = ref.read(apiClientsProvider);
    try {
      final resp = await clients.dio.get<dynamic>('/api/mood/records');
      final raw = resp.data;
      if (raw is! List) return const [];
      return raw
          .map((e) => standardSerializers.deserializeWith(
                MoodRecord.serializer,
                e as Map,
              ) as MoodRecord)
          .toList();
    } on DioException catch (e) {
      final apiErr = e.error is ApiError ? e.error as ApiError : null;
      throw apiErr ??
          ApiError(code: 'NETWORK_ERROR', message: e.message ?? 'fetch failed');
    }
  }

  Future<void> addMoodRecord({
    required int score,
    String? note,
    DateTime? recordedAt,
  }) async {
    final clients = ref.read(apiClientsProvider);
    try {
      final resp = await clients.dio.post<dynamic>(
        '/api/mood/records',
        data: {
          'score': score,
          'note': ?note,
          'recordedAt': ?recordedAt?.toIso8601String(),
        },
      );
      final raw = resp.data;
      if (raw is! Map) return;
      final record = standardSerializers.deserializeWith(
        MoodRecord.serializer,
        raw,
      ) as MoodRecord;

      final current = state.value ?? [];
      state = AsyncData([record, ...current]);
    } on DioException catch (e) {
      final apiErr = e.error is ApiError ? e.error as ApiError : null;
      throw apiErr ??
          ApiError(code: 'NETWORK_ERROR', message: e.message ?? 'add failed');
    }
  }
}

/// 7 天情绪趋势（dashboard 用）
final moodTrendProvider = FutureProvider<List<MoodTrendPoint>>((ref) async {
  final clients = ref.read(apiClientsProvider);
  try {
    final resp = await clients.dio.get<dynamic>('/api/mood/trend');
    final raw = resp.data;
    if (raw is! List) return const [];
    return raw
        .map((e) => standardSerializers.deserializeWith(
              MoodTrendPoint.serializer,
              e as Map,
            ) as MoodTrendPoint)
        .toList();
  } on DioException catch (e) {
    final apiErr = e.error is ApiError ? e.error as ApiError : null;
    throw apiErr ??
        ApiError(code: 'NETWORK_ERROR', message: e.message ?? 'trend failed');
  }
});
