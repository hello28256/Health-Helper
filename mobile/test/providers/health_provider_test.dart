// HealthProvider 单元测试 —— 验证：
// 1. list 成功 → 返回 List<HealthRecord>
// 2. list 网络失败 → 抛 ApiError
// 3. recordBatch 成功 → 列表更新
// 4. latest 成功 → 返回 HealthRecord?

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_helper/api/api_clients.dart';
import 'package:health_helper/api/api_error.dart';
import 'package:health_helper/auth/token_holder.dart';
import 'package:health_helper/providers/auth_provider.dart';
import 'package:health_helper/providers/health_provider.dart';
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
    adapter = MockAdapter((req) async => _ok('{"records":[]}'));
  });

  ProviderContainer makeContainer() {
    final clients = ApiClients(holder: holder, adapter: adapter);
    return ProviderContainer(overrides: [
      apiClientsProvider.overrideWithValue(clients),
      tokenHolderProvider.overrideWithValue(holder),
    ]);
  }

  test('list 成功 → 返回 List<HealthRecord>', () async {
    final container = makeContainer();
    final list = await container.read(
      healthRecordsProvider(HealthMetric.heartRate).future,
    );
    expect(list, isA<List<HealthRecord>>());
    expect(list.length, 0);
  });

  test('list 网络失败 → 抛 ApiError', () async {
    adapter = MockAdapter((req) async => _ok(
      '{"error":{"code":"SERVER_ERROR","message":"db down"}}',
      status: 500,
    ));
    final container = makeContainer();
    await expectLater(
      container.read(
        healthRecordsProvider(HealthMetric.heartRate).future,
      ),
      throwsA(isA<ApiError>()),
    );
  });

  test('recordBatch 成功 → 列表更新', () async {
    adapter = MockAdapter((req) async {
      if (req.method == 'POST') {
        // 后端批量插入返回 {records: [...]} 含新分配 id
        return _ok(
          '{"records":[{"id":"hr-1","userId":"u-1","metric":"heart_rate","value":72,"unit":"bpm","startAt":"2026-08-12T10:00:00Z","source":"ios_healthkit"}]}',
        );
      }
      return _ok('{"records":[]}');
    });
    final container = makeContainer();
    await container.read(
      healthRecordsProvider(HealthMetric.heartRate).future,
    );

    await container
        .read(healthRecordsProvider(HealthMetric.heartRate).notifier)
        .recordBatch([
          HealthRecordInput(
            metric: HealthMetric.heartRate,
            value: 72,
            unit: 'bpm',
            startAt: DateTime.utc(2026, 8, 12, 10),
            source: 'ios_healthkit',
          ),
        ]);

    final list = container
        .read(healthRecordsProvider(HealthMetric.heartRate))
        .value;
    expect(list, isNotNull);
    expect(list!.length, 1);
    expect(list.first.metric, HealthMetric.heartRate);
  });

  test('latestRecord 成功 → 返回 HealthRecord?', () async {
    adapter = MockAdapter((req) async => _ok(
      '{"record":{"id":"hr-1","userId":"u-1","metric":"heart_rate","value":72,"unit":"bpm","startAt":"2026-08-12T10:00:00Z","source":"ios_healthkit"}}',
    ));
    final container = makeContainer();
    final latest = await container.read(
      latestRecordProvider(HealthMetric.heartRate).future,
    );
    expect(latest, isA<HealthRecord>());
    expect(latest!.value, 72);
  });
}