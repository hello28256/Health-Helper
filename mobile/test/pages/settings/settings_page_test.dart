// SettingsPage + ProfilePage widget 测试 —— 覆盖：
// SettingsPage:
// 1. 渲染：标题 + 3 个分组（账号/应用/关于）+ 退出登录按钮
// 2. 点击"个人资料" → 导航到 ProfilePage
// 3. 点击"退出登录" → 弹确认对话框
// 4. 确认退出 → 调 authProvider.logout()
// ProfilePage:
// 5. 渲染：头像首字母 + email + 4 个 info tile
// 6. loading 态：Loading
// 7. error 态：ErrorView
// 8. 未登录：EmptyView

import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_helper/api/api_clients.dart';
import 'package:health_helper/api/api_error.dart';
import 'package:health_helper/auth/token_holder.dart';
import 'package:health_helper/pages/settings/profile_page.dart';
import 'package:health_helper/pages/settings/settings_page.dart';
import 'package:health_helper/providers/auth_provider.dart';
import 'package:health_helper/storage/secure_storage.dart';
import 'package:health_helper/theme/app_theme.dart';
import 'package:health_helper/widgets/common/common.dart';
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

PublicUser _user() => PublicUser((b) => b
  ..id = 'u-1'
  ..email = 'alice@test.com'
  ..displayName = 'Alice'
  ..heightCm = 170
  ..weightKg = 60
  ..createdAt = DateTime(2026, 1, 1));

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TokenHolder holder;
  late _StubAdapter adapter;
  late ApiClients clients;

  setUp(() async {
    holder = TokenHolder(storage: InMemorySecureStorage());
    await holder.save(accessToken: 'a', refreshToken: 'r');
    adapter = _StubAdapter((req) async => _ok('{}'));
    clients = ApiClients(holder: holder, adapter: adapter);
  });

  /// 构造已登录场景：token 有 + /me 返回 user
  List<Override> loggedInOverrides() => [
        tokenHolderProvider.overrideWithValue(holder),
        apiClientsProvider.overrideWithValue(clients),
        authProvider.overrideWith(() => _FakeAuthNotifier(
          user: _user(),
        )),
      ];

  /// 构造未登录场景
  List<Override> loggedOutOverrides() => [
        tokenHolderProvider.overrideWithValue(holder),
        apiClientsProvider.overrideWithValue(clients),
        authProvider.overrideWith(() => _FakeAuthNotifier.unauthenticated()),
      ];

  Widget wrap(Widget child, {List<Override> overrides = const []}) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: AppTheme.buildLightTheme(),
        home: child,
      ),
    );
  }

  // ===== SettingsPage =====

  testWidgets('SettingsPage 渲染：3 个分组 + 退出登录', (tester) async {
    await tester.pumpWidget(wrap(
      const SettingsPage(),
      overrides: loggedInOverrides(),
    ));
    await tester.pumpAndSettle();
    expect(find.text('设置'), findsOneWidget);
    expect(find.text('账号'), findsOneWidget);
    expect(find.text('应用'), findsOneWidget);
    expect(find.text('关于'), findsOneWidget);
    expect(find.text('个人资料'), findsOneWidget);
    expect(find.text('退出登录'), findsOneWidget);
  });

  testWidgets('点击"个人资料" → 跳到 ProfilePage', (tester) async {
    await tester.pumpWidget(wrap(
      const SettingsPage(),
      overrides: loggedInOverrides(),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('个人资料'));
    await tester.pumpAndSettle();
    expect(find.text('个人资料'), findsWidgets); // settings + profile 都出现
    expect(find.text('Alice'), findsOneWidget); // profile 显示昵称
  });

  testWidgets('点击"退出登录" → 弹确认 → 确认 → 调 logout', (tester) async {
    await tester.pumpWidget(wrap(
      const SettingsPage(),
      overrides: loggedInOverrides(),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('退出登录'));
    await tester.pumpAndSettle();
    expect(find.text('确定要退出登录吗？'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, '退出'));
    await tester.pumpAndSettle();
    // FakeAuthNotifier.logout 把状态改为 Unauthenticated
    expect(find.text('确定要退出登录吗？'), findsNothing);
  });

  // ===== ProfilePage =====

  testWidgets('ProfilePage 已登录：头像首字母 + email + 4 tile', (tester) async {
    await tester.pumpWidget(wrap(
      const ProfilePage(),
      overrides: loggedInOverrides(),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('alice@test.com'), findsOneWidget);
    expect(find.text('身高'), findsOneWidget);
    expect(find.text('体重'), findsOneWidget);
    expect(find.text('出生日期'), findsOneWidget);
    expect(find.text('注册时间'), findsOneWidget);
    expect(find.text('170 cm'), findsOneWidget);
    expect(find.text('60 kg'), findsOneWidget);
  });

  testWidgets('ProfilePage 未登录：EmptyView', (tester) async {
    await tester.pumpWidget(wrap(
      const ProfilePage(),
      overrides: loggedOutOverrides(),
    ));
    await tester.pumpAndSettle();
    expect(find.text('未登录'), findsOneWidget);
  });

  testWidgets('ProfilePage loading：显示 Loading', (tester) async {
    await tester.pumpWidget(wrap(
      const ProfilePage(),
      overrides: [
        tokenHolderProvider.overrideWithValue(holder),
        apiClientsProvider.overrideWithValue(clients),
        authProvider.overrideWith(_LoadingAuthNotifier.new),
      ],
    ));
    await tester.pump();
    expect(find.byType(Loading), findsOneWidget);
  });

  testWidgets('ProfilePage error：ErrorView', (tester) async {
    await tester.pumpWidget(wrap(
      const ProfilePage(),
      overrides: [
        tokenHolderProvider.overrideWithValue(holder),
        apiClientsProvider.overrideWithValue(clients),
        authProvider.overrideWith(() => _FakeAuthNotifier(
          error: ApiError(code: 'NETWORK', message: 'boom'),
        )),
      ],
    ));
    await tester.pumpAndSettle();
    expect(find.text('boom'), findsOneWidget);
  });
}

// ===== Fake AuthNotifier =====

class _FakeAuthNotifier extends AuthNotifier {
  _FakeAuthNotifier({this.user, this.error})
      : _isLoading = false,
        _unauthenticated = user == null && error == null;
  _FakeAuthNotifier.unauthenticated()
      : user = null,
        error = null,
        _isLoading = false,
        _unauthenticated = true;

  final PublicUser? user;
  final ApiError? error;
  final bool _isLoading;
  final bool _unauthenticated;

  @override
  Future<AuthState> build() async {
    if (_isLoading) return const AuthLoading();
    if (error != null) {
      // throw 让 AsyncValue 进入 error 态
      throw error!;
    }
    if (_unauthenticated) return const Unauthenticated();
    return Authenticated(user!);
  }

  @override
  Future<void> logout() async {
    state = const AsyncData<AuthState>(Unauthenticated());
  }
}

class _LoadingAuthNotifier extends AuthNotifier {
  @override
  Future<AuthState> build() {
    // 永不完成 → 保持 loading
    return _neverAuth.future;
  }
}

final _neverAuth = Completer<AuthState>();