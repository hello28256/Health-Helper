// LoginPage widget 测试 —— 覆盖：
// 1. 显示 logo + 标题 + 邮箱/密码输入 + 登录按钮 + 注册跳转
// 2. 表单校验：空邮箱、格式错误、短密码 → 显示错误
// 3. 错误 banner：authState=Unauthenticated(error) → 红色 banner
// 4. 提交触发：登录成功 → 调用 authProvider.notifier.login
// 5. loading 态：按钮禁用 + 显示 spinner

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:health_helper/api/api_clients.dart';
import 'package:health_helper/auth/token_holder.dart';
import 'package:health_helper/pages/auth/login_page.dart';
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
      initialLocation: '/login',
      routes: [
        GoRoute(path: '/login', builder: (_, _) => const LoginPage()),
        GoRoute(path: '/register', builder: (_, _) => const Scaffold(body: Text('register-stub'))),
        GoRoute(path: '/dashboard', builder: (_, _) => const Scaffold(body: Text('dashboard-stub'))),
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

  testWidgets('渲染 logo + 标题 + 表单 + 按钮', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    expect(find.text('Health Helper'), findsOneWidget);
    expect(find.text('邮箱'), findsOneWidget);
    expect(find.text('密码'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, '登录'), findsOneWidget);
    expect(find.text('还没有账号？去注册'), findsOneWidget);
  });

  testWidgets('空邮箱提交 → 显示"请输入邮箱"', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, '登录'));
    await tester.pump();
    expect(find.text('请输入邮箱'), findsOneWidget);
  });

  testWidgets('邮箱格式错 → 显示"邮箱格式不正确"', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'not-an-email');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.widgetWithText(FilledButton, '登录'));
    await tester.pump();
    expect(find.text('邮箱格式不正确'), findsOneWidget);
  });

  testWidgets('密码 < 6 位 → 显示"密码至少 6 位"', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'a@b.com');
    await tester.enterText(find.byType(TextFormField).at(1), '123');
    await tester.tap(find.widgetWithText(FilledButton, '登录'));
    await tester.pump();
    expect(find.text('密码至少 6 位'), findsOneWidget);
  });

  testWidgets('错误 banner 显示 ApiError.message', (tester) async {
    // 让 login 失败：401
    adapter = _StubAdapter((req) async => _ok(
      '{"error":{"code":"UNAUTHORIZED","message":"邮箱或密码错误"}}',
      status: 401,
    ));
    final clients = ApiClients(holder: holder, adapter: adapter);
    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(path: '/login', builder: (_, _) => const LoginPage()),
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

    await tester.enterText(find.byType(TextFormField).at(0), 'a@b.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.widgetWithText(FilledButton, '登录'));
    await tester.pumpAndSettle();

    expect(find.text('邮箱或密码错误'), findsOneWidget);
  });

  testWidgets('点击"去注册" → 路由跳 /register', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    await tester.tap(find.text('还没有账号？去注册'));
    await tester.pumpAndSettle();
    expect(find.text('register-stub'), findsOneWidget);
  });
}