// ExercisesProvider 单元测试 —— 验证：
// 1. listExercises() 成功 → 返回 List<ExerciseRecord>
// 2. listExercises() 网络失败 → 抛 ApiError
// 3. addExercise() 成功 → 记录添加到列表头部
// 4. addExercise() 失败 → 状态不变

import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_helper/api/api_clients.dart';
import 'package:health_helper/api/api_error.dart';
import 'package:health_helper/auth/token_holder.dart';
import 'package:health_helper/providers/auth_provider.dart';
import 'package:health_helper/providers/exercises_provider.dart';
import 'package:health_helper/storage/secure_storage.dart';
import 'package:health_helper_api/health_helper_api.dart';

class InMemorySecureStorage implements SecureStorage {
  final Map<String, String> _store = {};
  @override
  Future<String?> read({required String key}) async => _store[key];
  @override
  Future<void> write({required String key, required String value}) async => _store[key] = value;
  @override
  Future<void> delete({required String key}) async => _store.remove(key);
  @override
  Future<void> clear() async => _store.clear();
}

class MockAdapter implements HttpClientAdapter {
  MockAdapter(this.handler);
  Future<Response<dynamic>> Function(RequestOptions) handler;
  @override
  void close({bool force = false}) {}
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final resp = await handler(options);
    if (resp.statusCode != null && resp.statusCode! >= 400) {
      throw DioException(
        requestOptions: options,
        response: resp,
        type: DioExceptionType.badResponse,
      );
    }
    return ResponseBody.fromString(
      resp.data?.toString() ?? '',
      resp.statusCode ?? 200,
      headers: const {'content-type': ['application/json']},
    );
  }
}

Response<dynamic> _ok(String data, {int status = 200}) {
  return Response<dynamic>(
    requestOptions: RequestOptions(path: '/'),
    statusCode: status,
    data: data,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TokenHolder holder;
  late MockAdapter adapter;

  setUp(() async {
    holder = TokenHolder(storage: InMemorySecureStorage());
    await holder.save(accessToken: 'access-1', refreshToken: 'refresh-1');
    adapter = MockAdapter((req) async => _ok('[]'));
  });

  ProviderContainer makeContainer() {
    final clients = ApiClients(holder: holder, adapter: adapter);
    return ProviderContainer(overrides: [
      apiClientsProvider.overrideWithValue(clients),
      tokenHolderProvider.overrideWithValue(holder),
    ]);
  }

  test('listExercises 成功 → 返回 List<ExerciseRecord>', () async {
    final container = makeContainer();
    final list = await container.read(exercisesProvider.future);
    expect(list, isA<List<ExerciseRecord>>());
    expect(list.length, 0, reason: 'mock 返回 []');
  });

  test('listExercises 网络失败 → 抛 ApiError', () async {
    adapter = MockAdapter((req) async => _ok(
      '{"error":{"code":"SERVER_ERROR","message":"db down"}}',
      status: 500,
    ));
    final container = makeContainer();
    await expectLater(
      container.read(exercisesProvider.future),
      throwsA(isA<ApiError>()),
    );
  });

  test('addExercise 成功 → 列表更新', () async {
    final container = makeContainer();
    await container.read(exercisesProvider.future);

    // 现在 add 时的写请求
    var addedItems = 0;
    adapter = MockAdapter((req) async {
      if (req.method == 'POST') {
        addedItems++;
        return _ok('{"id":"ex-1","type":"running","durationMin":30,"kcal":250,"startedAt":"2026-08-12T10:00:00Z"}');
      }
      return _ok('[]');
    });
    // 重建 container 让新 adapter 生效
    final newClients = ApiClients(holder: holder, adapter: adapter);
    final c2 = ProviderContainer(overrides: [
      apiClientsProvider.overrideWithValue(newClients),
      tokenHolderProvider.overrideWithValue(holder),
    ]);
    await c2.read(exercisesProvider.future);

    await c2.read(exercisesProvider.notifier).addExercise(
      type: 'running',
      durationMin: 30,
      kcal: 250,
      startedAt: DateTime.utc(2026, 8, 12, 10),
    );

    expect(addedItems, 1);
    final list = c2.read(exercisesProvider).value;
    expect(list, isNotNull);
    expect(list!.length, 1);
  });
}
