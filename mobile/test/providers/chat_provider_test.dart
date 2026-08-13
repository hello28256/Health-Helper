// ChatProvider 单元测试 —— 验证：
// 1. history 成功 → 返回 List<ChatMessage>
// 2. history 网络失败 → 抛 ApiError
// 3. sendMessage 成功 → 返回 assistant content

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_helper/api/api_clients.dart';
import 'package:health_helper/api/api_error.dart';
import 'package:health_helper/auth/token_holder.dart';
import 'package:health_helper/providers/auth_provider.dart';
import 'package:health_helper/providers/chat_provider.dart';
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
    adapter = MockAdapter((req) async => _ok('{"history":[]}'));
  });

  ProviderContainer makeContainer() {
    final clients = ApiClients(holder: holder, adapter: adapter);
    return ProviderContainer(overrides: [
      apiClientsProvider.overrideWithValue(clients),
      tokenHolderProvider.overrideWithValue(holder),
    ]);
  }

  test('history 成功 → 返回 List<ChatMessage>', () async {
    final container = makeContainer();
    final list = await container.read(chatHistoryProvider.future);
    expect(list, isA<List<ChatMessage>>());
    expect(list.length, 0);
  });

  test('history 网络失败 → 抛 ApiError', () async {
    adapter = MockAdapter((req) async => _ok(
      '{"error":{"code":"SERVER_ERROR","message":"ai down"}}',
      status: 500,
    ));
    final container = makeContainer();
    await expectLater(
      container.read(chatHistoryProvider.future),
      throwsA(isA<ApiError>()),
    );
  });

  test('sendMessage 成功 → 返回 assistant content', () async {
    adapter = MockAdapter((req) async {
      if (req.method == 'POST') {
        return _ok(
          '{"userMessage":{"role":"user","content":"hi"},"assistantMessage":{"role":"assistant","content":"hello back"}}',
        );
      }
      return _ok('{"history":[]}');
    });
    final container = makeContainer();
    final reply = await container.read(sendMessageProvider)('hi');
    expect(reply, 'hello back');
  });

  test('sendMessage 失败 → 抛 ApiError', () async {
    adapter = MockAdapter((req) async {
      if (req.method == 'POST') {
        return _ok(
          '{"error":{"code":"AI_DISABLED","message":"ai not enabled"}}',
          status: 403,
        );
      }
      return _ok('{"history":[]}');
    });
    final container = makeContainer();
    await expectLater(
      container.read(sendMessageProvider)('hi'),
      throwsA(isA<ApiError>()),
    );
  });
}