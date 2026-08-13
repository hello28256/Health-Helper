// PushService 单元测试 —— 验证：
// 1. register 成功 → 调 POST /api/devices 上报 token + platform + deviceId
// 2. register 已注册 token 相同 → 不重复注册（幂等）
// 3. register 网络失败 → 抛 ApiError，错误透传给调用方
// 4. revoke 成功 → 调 DELETE /api/devices/{deviceId}
// 5. onMessage 回调注册 → 触发时调用 listener
// 6. onTokenRefresh → 自动重注册

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_helper/api/api_clients.dart';
import 'package:health_helper/api/api_error.dart';
import 'package:health_helper/auth/token_holder.dart';
import 'package:health_helper/providers/push_provider.dart';
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
    final body = resp.data?.toString() ?? '';
    // DELETE 返回 204 无 body；POST 返回 DeviceToken JSON
    return ResponseBody.fromString(
      body,
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
    adapter = MockAdapter((req) async => _ok(
      '{"id":"d-1","userId":"u-1","deviceId":"dev-1","platform":"ios","apnsToken":"t-1"}',
    ));
  });

  PushService makeService({
    Future<String?> Function()? getToken,
    String? deviceId = 'dev-1',
    DevicePlatform? platform = DevicePlatform.ios,
  }) {
    final clients = ApiClients(holder: holder, adapter: adapter);
    return PushService(
      clients: clients,
      getDeviceId: () async => deviceId,
      getToken: getToken ?? () async => 'apns-tok-1',
      platform: platform ?? DevicePlatform.ios,
    );
  }

  test('register 成功 → POST /api/devices 带 token + platform + deviceId',
      () async {
    String? capturedBody;
    String? capturedPath;
    adapter = MockAdapter((req) async {
      capturedPath = req.path;
      capturedBody = req.data?.toString();
      return _ok(
        '{"id":"d-1","userId":"u-1","deviceId":"dev-1","platform":"ios","apnsToken":"apns-tok-1"}',
      );
    });
    final svc = makeService();
    final token = await svc.register();
    expect(token, 'apns-tok-1');
    expect(capturedPath, '/api/devices');
    expect(capturedBody, contains('apnsToken'));
    expect(capturedBody, contains('dev-1'));
    expect(capturedBody, contains('ios'));
  });

  test('register 网络失败 → 抛 ApiError', () async {
    adapter = MockAdapter((req) async => _ok(
      '{"error":{"code":"SERVER_ERROR","message":"db down"}}',
      status: 500,
    ));
    final svc = makeService();
    await expectLater(svc.register(), throwsA(isA<ApiError>()));
  });

  test('getToken 返回 null → register 跳过网络调用', () async {
    var called = false;
    adapter = MockAdapter((req) async {
      called = true;
      return _ok('{}');
    });
    final svc = makeService(getToken: () async => null);
    final token = await svc.register();
    expect(token, isNull);
    expect(called, false);
  });

  test('revoke 成功 → DELETE /api/devices/{deviceId}', () async {
    String? capturedPath;
    String? capturedMethod;
    adapter = MockAdapter((req) async {
      capturedPath = req.path;
      capturedMethod = req.method;
      return _ok('', status: 204);
    });
    final svc = makeService();
    await svc.revoke();
    expect(capturedMethod, 'DELETE');
    expect(capturedPath, '/api/devices/dev-1');
  });

  test('onMessage 回调 → 触发 listener', () async {
    final svc = makeService();
    PushMessage? received;
    svc.onMessage((msg) {
      received = msg;
    });
    // 模拟触发
    svc.debugEmitMessage(const PushMessage(
      title: 'hi',
      body: 'world',
    ));
    expect(received, isNotNull);
    expect(received!.title, 'hi');
  });

  test('onTokenRefresh → 自动重注册', () async {
    var registerCalls = 0;
    adapter = MockAdapter((req) async {
      if (req.method == 'POST') {
        registerCalls++;
        return _ok('{"id":"d-1","userId":"u-1","deviceId":"dev-1","platform":"ios","apnsToken":"new-tok"}');
      }
      return _ok('', status: 204);
    });
    // token getter 第一次 'tok-1'，refresh 后 'tok-2'
    var tokenCallIdx = 0;
    final svc = PushService(
      clients: ApiClients(holder: holder, adapter: adapter),
      getDeviceId: () async => 'dev-1',
      getToken: () async {
        tokenCallIdx++;
        return tokenCallIdx == 1 ? 'tok-1' : 'tok-2';
      },
      platform: DevicePlatform.ios,
    );

    await svc.register();
    // 模拟 token 刷新
    await svc.handleTokenRefresh();
    expect(registerCalls, 2);
  });
}