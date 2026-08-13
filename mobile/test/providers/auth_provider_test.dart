// AuthNotifier 单元测试 —— 验证：
// 1. bootstrap：无 token → Unauthenticated
// 2. bootstrap：有 token + /me 成功 → Authenticated(user)
// 3. bootstrap：有 token + /me 401 → 清 token + Unauthenticated
// 4. login 成功：保存 token + 状态变 Authenticated
// 5. login 失败：保持 Unauthenticated + 错误信息
// 6. logout：清 token + 状态变 Unauthenticated
// 7. onAuthFailed（被 401 拦截器调用）：清 token + 状态变 Unauthenticated

import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_helper/api/api_clients.dart';
import 'package:health_helper/auth/token_holder.dart';
import 'package:health_helper/providers/auth_provider.dart';
import 'package:health_helper/storage/secure_storage.dart';

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

  setUp(() {
    holder = TokenHolder(storage: InMemorySecureStorage());
    adapter = MockAdapter((req) async => _ok('{"ok":true}'));
  });

  ProviderContainer makeContainer() {
    final clients = ApiClients(holder: holder, adapter: adapter);
    return ProviderContainer(
      overrides: [
        apiClientsProvider.overrideWithValue(clients),
        tokenHolderProvider.overrideWithValue(holder),
      ],
    );
  }

  group('bootstrap', () {
    test('无 token → Unauthenticated', () async {
      final container = makeContainer();
      final state = await container.read(authProvider.future);
      expect(state, isA<Unauthenticated>());
      expect((state as Unauthenticated).error, isNull);
    });

    test('有 token + /me 成功 → Authenticated', () async {
      await holder.save(accessToken: 'access-1', refreshToken: 'refresh-1');
      adapter = MockAdapter((req) async => _ok(
        '{"id":"user-1","email":"test@example.com","displayName":"Tester","createdAt":"2026-01-01T00:00:00Z"}',
      ));
      final container = makeContainer();
      final state = await container.read(authProvider.future);
      expect(state, isA<Authenticated>());
      expect((state as Authenticated).user.email, 'test@example.com');
    });

    test('有 token + /me 401 → 清 token + Unauthenticated', () async {
      await holder.save(accessToken: 'access-1', refreshToken: 'refresh-1');
      adapter = MockAdapter((req) async => _ok(
        '{"error":{"code":"UNAUTHORIZED","message":"expired"}}',
        status: 401,
      ));
      final container = makeContainer();
      final state = await container.read(authProvider.future);
      expect(state, isA<Unauthenticated>());
      expect(await holder.getAccessToken(), isNull,
          reason: 'refresh 失败后清 token');
      expect(await holder.getRefreshToken(), isNull);
    });
  });

  group('login', () {
    test('成功 → 保存 token + Authenticated', () async {
      adapter = MockAdapter((req) async {
        if (req.path == '/api/auth/login') {
          return _ok(
            '{"user":{"id":"user-1","email":"test@example.com","displayName":"Tester","createdAt":"2026-01-01T00:00:00Z"},"accessToken":"new-access","refreshToken":"new-refresh"}',
          );
        }
        return _ok('{}');
      });
      final container = makeContainer();
      await container.read(authProvider.future); // bootstrap

      await container.read(authProvider.notifier).login(
        email: 'test@example.com',
        password: 'pw123',
      );

      final state = container.read(authProvider).value;
      expect(state, isA<Authenticated>());
      expect(await holder.getAccessToken(), 'new-access');
      expect(await holder.getRefreshToken(), 'new-refresh');
    });

    test('失败（401） → Unauthenticated + 错误信息', () async {
      adapter = MockAdapter((req) async => _ok(
        '{"error":{"code":"UNAUTHORIZED","message":"bad creds"}}',
        status: 401,
      ));
      final container = makeContainer();
      await container.read(authProvider.future);

      await container.read(authProvider.notifier).login(
        email: 'wrong@example.com',
        password: 'wrong',
      );

      final state = container.read(authProvider).value;
      expect(state, isA<Unauthenticated>());
      expect((state as Unauthenticated).error, contains('bad creds'));
    });
  });

  group('logout', () {
    test('清 token + Unauthenticated', () async {
      await holder.save(accessToken: 'access-1', refreshToken: 'refresh-1');
      adapter = MockAdapter((req) async {
        if (req.path == '/api/users/me') {
          return _ok(
            '{"id":"user-1","email":"test@example.com","displayName":"Tester","createdAt":"2026-01-01T00:00:00Z"}',
          );
        }
        // logout 端点
        return _ok('{}');
      });
      final container = makeContainer();
      await container.read(authProvider.future);
      expect(container.read(authProvider).value, isA<Authenticated>());

      await container.read(authProvider.notifier).logout();

      expect(container.read(authProvider).value, isA<Unauthenticated>());
      expect(await holder.getAccessToken(), isNull);
    });
  });

  group('onAuthFailed (C3 拦截器调用)', () {
    test('refresh 失败 → 清 token + 状态变 Unauthenticated', () async {
      await holder.save(accessToken: 'access-1', refreshToken: 'refresh-1');
      adapter = MockAdapter((req) async {
        if (req.path == '/api/users/me') {
          return _ok(
            '{"id":"user-1","email":"test@example.com","displayName":"Tester","createdAt":"2026-01-01T00:00:00Z"}',
          );
        }
        return _ok('{}');
      });
      final container = makeContainer();
      await container.read(authProvider.future);
      expect(container.read(authProvider).value, isA<Authenticated>());

      // 模拟 C3 拦截器在 refresh 失败时调用 onAuthFailed
      container.read(authProvider.notifier).onAuthFailed();
      // 状态变更可能异步
      await Future<void>.delayed(Duration.zero);

      expect(container.read(authProvider).value, isA<Unauthenticated>());
      expect(await holder.getAccessToken(), isNull);
    });
  });
}
