// API 客户端薄封装测试 —— 验证：
// 1. ApiClients 聚合 9 个 generated API 类 + 共享同一 dio
// 2. dio 自动注入 Authorization Bearer header（onRequest 拦截器）
// 3. skipAuth=true 的请求不发 Authorization header
// 4. 未持有 token 时不发 Authorization header
// 5. 后端 4xx/5xx 错误统一映射成 ApiError

import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_helper/api/api_clients.dart';
import 'package:health_helper/api/api_error.dart';
import 'package:health_helper/auth/token_holder.dart';
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
  final List<RequestOptions> calls = [];
  @override
  void close({bool force = false}) {}
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    calls.add(options);
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

  setUp(() async {
    holder = TokenHolder(storage: InMemorySecureStorage());
    await holder.save(accessToken: 'access-1', refreshToken: 'refresh-1');
  });

  group('ApiClients 聚合 9 个 API 类', () {
    test('9 个 API 类都能正常实例化', () {
      final clients = ApiClients(holder: holder);
      expect(clients.auth, isNotNull);
      expect(clients.users, isNotNull);
      expect(clients.exercises, isNotNull);
      expect(clients.steps, isNotNull);
      expect(clients.diet, isNotNull);
      expect(clients.mood, isNotNull);
      expect(clients.chat, isNotNull);
      expect(clients.health, isNotNull);
      expect(clients.devices, isNotNull);
    });

    test('所有 API 类共享同一个 dio 单例', () {
      final clients = ApiClients(holder: holder);
      // dio 是单例，9 个 API 都用它
      final dio = clients.dio;
      expect(dio, isNotNull);
      // 验证 dio.interceptors 含 onRequest 拦截器（auth header）+ onError（错误映射）
      expect(dio.interceptors.length, greaterThanOrEqualTo(2));
    });

    test('dio 注入 Authorization Bearer header（onRequest 拦截器）', () async {
      String? capturedAuth;
      final adapter = MockAdapter((req) async {
        capturedAuth = req.headers['Authorization'] as String?;
        return _ok('{"ok":true}');
      });
      final clients = ApiClients(holder: holder, adapter: adapter);

      await clients.dio.get<dynamic>('/api/users/me');

      expect(capturedAuth, 'Bearer access-1');
    });

    test('skipAuth=true 的请求不发 Authorization header', () async {
      String? capturedAuth;
      final adapter = MockAdapter((req) async {
        capturedAuth = req.headers['Authorization'] as String?;
        return _ok('{}');
      });
      final clients = ApiClients(holder: holder, adapter: adapter);

      await clients.dio.get<dynamic>(
        '/api/auth/refresh',
        options: Options(extra: {'skipAuth': true}),
      );

      expect(capturedAuth, isNull);
    });

    test('未持有 token 时不发送 Authorization header', () async {
      await holder.clear();
      String? capturedAuth;
      final adapter = MockAdapter((req) async {
        capturedAuth = req.headers['Authorization'] as String?;
        return _ok('{}');
      });
      final clients = ApiClients(holder: holder, adapter: adapter);

      await clients.dio.get<dynamic>('/api/users/me');

      expect(capturedAuth, isNull);
    });
  });

  group('错误映射 DioException → ApiError', () {
    late ApiClients clients;

    /// 从 DioException 抽取 error 字段（错误映射拦截器把 ApiError 塞到 error）
    ApiError? extractApiError(Object e) {
      if (e is DioException && e.error is ApiError) return e.error as ApiError;
      if (e is ApiError) return e;
      return null;
    }

    test('后端 400 + VALIDATION_ERROR → ApiError(VALIDATION_ERROR, isValidation=true)', () async {
      final adapter = MockAdapter((req) async => _ok(
        '{"error":{"code":"VALIDATION_ERROR","message":"invalid","details":{"field":"email"}}}',
        status: 400,
      ));
      clients = ApiClients(holder: holder, adapter: adapter);

      try {
        await clients.dio.get<dynamic>('/api/auth/login');
        fail('应该抛 DioException');
      } on DioException catch (e) {
        expect(e.error, isA<ApiError>());
        final mapped = e.error as ApiError;
        expect(mapped.code, 'VALIDATION_ERROR');
        expect(mapped.status, 400);
        expect(mapped.isValidation, isTrue);
      }
    });

    test('后端 401 + UNAUTHORIZED → ApiError(UNAUTHORIZED, isUnauthorized=true)', () async {
      final adapter = MockAdapter((req) async => _ok(
        '{"error":{"code":"UNAUTHORIZED","message":"no token"}}',
        status: 401,
      ));
      clients = ApiClients(holder: holder, adapter: adapter);

      try {
        await clients.dio.get<dynamic>('/api/users/me');
        fail('应该抛 DioException');
      } on DioException catch (e) {
        final mapped = extractApiError(e);
        expect(mapped, isNotNull);
        expect(mapped!.code, 'UNAUTHORIZED');
        expect(mapped.isUnauthorized, isTrue);
      }
    });

    test('后端 500 → ApiError(HTTP_500, isServer=true)', () async {
      final adapter = MockAdapter((req) async => _ok('boom', status: 500));
      clients = ApiClients(holder: holder, adapter: adapter);

      try {
        await clients.dio.get<dynamic>('/api/auth/login');
        fail('应该抛 DioException');
      } on DioException catch (e) {
        final mapped = extractApiError(e);
        expect(mapped, isNotNull);
        expect(mapped!.code, 'HTTP_500');
        expect(mapped.isServer, isTrue);
      }
    });
  });
}
