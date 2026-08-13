// DioClient 单元测试 —— 重点验证 401 refresh 单例锁
//
// 关键场景：
// 1. 普通 401 → refresh 一次 → 用新 token 重放原请求
// 2. 并发多个 401 → 只触发一次 refresh（completer 共享 promise）
// 3. refresh 失败 → 触发 onAuthFailed → 不重试
// 4. 非 401 错误（如 500）→ 直接抛错，不走 refresh
// 5. retry=true 的请求不再二次 refresh（防止死循环）

import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_helper/api/dio_client.dart';
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

/// MockAdapter —— 直接抛/返 DioException 给上层
///
/// 用 [Response] 而不是 [ResponseBody] 因为 dio 处理 ResponseBody 的 stream 时
/// 经常误判成 unknown error。直接构造 Response + DioException 更可控。
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
    // 模拟 dio 的行为：validateStatus 失败 → 抛 badResponse
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
    await holder.save(accessToken: 'access-old', refreshToken: 'refresh-old');
  });

  Dio buildDio({
    required MockAdapter adapter,
    required Future<Response<dynamic>> Function() onRefresh,
    void Function()? onAuthFailed,
  }) {
    final dio = Dio(BaseOptions(baseUrl: 'http://test.local'));
    dio.httpClientAdapter = adapter;
    // ===== retryWithNewToken：用 caller 的同一个 dio 重发，自动注入新 token header =====
    Future<Response<dynamic>> retry(RequestOptions options) async {
      // 注入新 token（refreshCall 已更新 holder）
      final newAccess = await holder.getAccessToken();
      if (newAccess != null && newAccess.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $newAccess';
      }
      return dio.fetch<dynamic>(options);
    }

    dio.interceptors.add(refreshInterceptor(
      refreshCall: onRefresh,
      retryWithNewToken: retry,
      onAuthFailed: onAuthFailed ?? () {},
    ));
    return dio;
  }

  group('refreshInterceptor', () {
    test('普通 401 → refresh 一次 → 重放原请求', () async {
      var attempt = 0;
      final adapter = MockAdapter((req) async {
        attempt++;
        if (attempt == 1) return _ok('{"error":"x"}', status: 401);
        // 第二次同请求（重放）应该带新 accessToken
        final auth = req.headers['Authorization'];
        expect(auth, 'Bearer access-new');
        return _ok('{"ok":true}');
      });

      final dio = buildDio(
        adapter: adapter,
        onRefresh: () async {
          await holder.updateTokens(accessToken: 'access-new', refreshToken: 'refresh-new');
          return Response<dynamic>(requestOptions: RequestOptions(path: '/auth/refresh'), statusCode: 200);
        },
      );

      final res = await dio.get<Map<String, dynamic>>('/data');
      expect(res.data, {'ok': true});
      expect(attempt, 2);
    });

    test('并发 3 个 401 → refresh 只触发 1 次', () async {
      var refreshCalls = 0;
      final adapter = MockAdapter((req) async {
        // refresh 直接通过（adapter 不管，由 refreshCall 自己处理）
        if (req.path == '/auth/refresh') return _ok('{}');
        // 业务端点：检查 header；如果带新 token 则返 200，否则 401
        final auth = req.headers['Authorization'];
        if (auth == 'Bearer access-new') return _ok('{"ok":true}');
        return _ok('nope', status: 401);
      });

      final dio = buildDio(
        adapter: adapter,
        onRefresh: () async {
          refreshCalls++;
          // 故意慢一点，模拟真实 refresh 延迟
          await Future<void>.delayed(const Duration(milliseconds: 30));
          await holder.updateTokens(accessToken: 'access-new', refreshToken: 'refresh-new');
          return Response<dynamic>(
            requestOptions: RequestOptions(path: '/auth/refresh'),
            statusCode: 200,
          );
        },
      );

      final results = await Future.wait<dynamic>([
        dio.get<dynamic>('/a'),
        dio.get<dynamic>('/b'),
        dio.get<dynamic>('/c'),
      ]);

      expect(refreshCalls, 1, reason: 'completer 单例锁：并发 401 只触发一次 refresh');
      expect(results.length, 3);
    });

    test('refresh 自身 401 → onAuthFailed → 不重试', () async {
      var authFailed = 0;
      final adapter = MockAdapter((req) async {
        if (req.path == '/auth/refresh') return _ok('{}', status: 401);
        return _ok('nope', status: 401);
      });

      final dio = buildDio(
        adapter: adapter,
        onRefresh: () async => Response<dynamic>(
          requestOptions: RequestOptions(path: '/auth/refresh'),
          statusCode: 401,
        ),
        onAuthFailed: () => authFailed++,
      );

      await expectLater(dio.get<dynamic>('/data'), throwsA(isA<DioException>()));
      expect(authFailed, 1);
      expect(await holder.getAccessToken(), 'access-old', reason: 'refresh 失败不应改变 token');
    });

    test('非 401 错误 → 直接抛错，不走 refresh', () async {
      var refreshCalls = 0;
      final adapter = MockAdapter((req) async => _ok('boom', status: 500));

      final dio = buildDio(
        adapter: adapter,
        onRefresh: () async {
          refreshCalls++;
          return Response<dynamic>(requestOptions: RequestOptions(path: '/auth/refresh'), statusCode: 200);
        },
      );

      await expectLater(dio.get<dynamic>('/data'), throwsA(isA<DioException>()));
      expect(refreshCalls, 0);
    });

    test('refresh 已重试过的请求不再触发 refresh（防死循环）', () async {
      var refreshCalls = 0;
      final adapter = MockAdapter((req) async => _ok('nope', status: 401));

      final dio = buildDio(
        adapter: adapter,
        onRefresh: () async {
          refreshCalls++;
          return Response<dynamic>(requestOptions: RequestOptions(path: '/auth/refresh'), statusCode: 401);
        },
      );

      await expectLater(dio.get<dynamic>('/data'), throwsA(isA<DioException>()));
      expect(refreshCalls, 1, reason: 'refresh 失败 → onAuthFailed；后续重试不应该再 refresh');
    });
  });
}
