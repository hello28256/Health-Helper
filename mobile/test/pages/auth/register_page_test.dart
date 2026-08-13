// RegisterPage widget 测试 —— 覆盖：
// 1. 渲染：3 个输入（昵称/邮箱/密码）+ 注册按钮 + 跳转登录链接
// 2. 表单校验：空邮箱、邮箱格式错、短密码
// 3. 错误 banner：显示 ApiError.message
// 4. 点击"去登录" → 路由跳 /login
// 5. 可选昵称：空昵称也能提交

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:health_helper/api/api_clients.dart';
import 'package:health_helper/auth/token_holder.dart';
import 'package:health_helper/pages/auth/register_page.dart';
import 'package:health_helper/providers/auth_provider.dart';
import 'package:health_helper/storage/secure_storage.dart';
import 'package:health_helper/theme/app_theme.dart';

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

class _StubAdapter implements HttpClientAdapter {
  _StubAdapter(this.handler);
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
  late _StubAdapter adapter;

  setUp(() async {
    holder = TokenHolder(storage: InMemorySecureStorage());
    adapter = _StubAdapter((req) async => _ok('[]'));
  });

  Widget wrap() {
    final clients = ApiClients(holder: holder, adapter: adapter);
    final router = GoRouter(
      initialLocation: '/register',
      routes: [
        GoRoute(path: '/register', builder: (_, _) => const RegisterPage()),
        GoRoute(path: '/login', builder: (_, _) => const Scaffold(body: Text('login-stub'))),
      ],
    );
    return ProviderScope(
      overrides: [
        tokenHolderProvider.overrideWithValue(holder),
        apiClientsProvider.overrideWithValue(clients),
      ],
      child: MaterialApp.router(
        theme: AppTheme.buildLightTheme(),
        routerConfig: router,
      ),
    );
  }

  testWidgets('渲染昵称/邮箱/密码 + 注册按钮 + 跳登录链接', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    expect(find.text('昵称（可选）'), findsOneWidget);
    expect(find.text('邮箱'), findsOneWidget);
    expect(find.text('密码（至少 6 位）'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, '注册'), findsOneWidget);
    expect(find.text('已有账号？去登录'), findsOneWidget);
  });

  testWidgets('空邮箱 → "请输入邮箱"', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, '注册'));
    await tester.pump();
    expect(find.text('请输入邮箱'), findsOneWidget);
  });

  testWidgets('邮箱格式错 → "邮箱格式不正确"', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(1), 'bad');
    await tester.enterText(find.byType(TextFormField).at(2), 'pwd1234');
    await tester.tap(find.widgetWithText(FilledButton, '注册'));
    await tester.pump();
    expect(find.text('邮箱格式不正确'), findsOneWidget);
  });

  testWidgets('密码 < 6 位 → "密码至少 6 位"', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(1), 'a@b.com');
    await tester.enterText(find.byType(TextFormField).at(2), '123');
    await tester.tap(find.widgetWithText(FilledButton, '注册'));
    await tester.pump();
    expect(find.text('密码至少 6 位'), findsOneWidget);
  });

  testWidgets('错误 banner 显示 ApiError.message', (tester) async {
    adapter = _StubAdapter((req) async => _ok(
      '{"error":{"code":"VALIDATION_ERROR","message":"邮箱已被注册"}}',
      status: 400,
    ));
    final clients = ApiClients(holder: holder, adapter: adapter);
    final router = GoRouter(
      initialLocation: '/register',
      routes: [
        GoRoute(path: '/register', builder: (_, _) => const RegisterPage()),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tokenHolderProvider.overrideWithValue(holder),
          apiClientsProvider.overrideWithValue(clients),
        ],
        child: MaterialApp.router(
          theme: AppTheme.buildLightTheme(),
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(1), 'a@b.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'password123');
    await tester.tap(find.widgetWithText(FilledButton, '注册'));
    await tester.pumpAndSettle();

    expect(find.text('邮箱已被注册'), findsOneWidget);
  });

  testWidgets('点击"去登录" → 路由跳 /login', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    await tester.tap(find.text('已有账号？去登录'));
    await tester.pumpAndSettle();
    expect(find.text('login-stub'), findsOneWidget);
  });
}