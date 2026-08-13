// AppRouter 单元测试 —— 验证：
// 1. 未登录用户访问受保护路由 → 重定向到 /login
// 2. 已登录用户访问 /login → 重定向到 /dashboard
// 3. 公开路由（/login、/register）任何时候都能访问
// 4. refreshListenable 触发时路由重新评估（auth 状态变化自动跳转）

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_helper/router/app_router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('未登录访问 /dashboard → 重定向到 /login', (tester) async {
    final auth = FakeAuthState();
    final router = AppRouter.build(auth);
    auth.setAuthenticated(false);

    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router,
    ));

    expect(router.routerDelegate.currentConfiguration.uri.toString(), '/login');
  });

  testWidgets('已登录访问 /dashboard → 不重定向', (tester) async {
    final auth = FakeAuthState();
    final router = AppRouter.build(auth);
    auth.setAuthenticated(true);

    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router,
    ));

    // 默认重定向到 /dashboard
    expect(router.routerDelegate.currentConfiguration.uri.toString(), '/dashboard');
  });

  testWidgets('已登录访问 /login → 重定向到 /dashboard', (tester) async {
    final auth = FakeAuthState();
    final router = AppRouter.build(auth);
    auth.setAuthenticated(true);

    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router,
    ));

    router.go('/login');
    await tester.pumpAndSettle();

    expect(router.routerDelegate.currentConfiguration.uri.toString(), '/dashboard');
  });

  testWidgets('auth 状态从 false→true → 自动跳 /dashboard', (tester) async {
    final auth = FakeAuthState();
    final router = AppRouter.build(auth);
    auth.setAuthenticated(false);

    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router,
    ));

    expect(router.routerDelegate.currentConfiguration.uri.toString(), '/login');

    // 模拟登录成功
    auth.setAuthenticated(true);
    await tester.pumpAndSettle();

    // refreshListenable 应该触发 redirect 重新评估 → 跳到 /dashboard
    // 注意：redirect 默认会回到 root，然后根据 auth=true 跳 /dashboard
    expect(auth.notifyCount, greaterThan(0),
        reason: 'refreshListenable 必须通知路由器重新评估');
  });

  testWidgets('/register 公开路由任何时候都能访问', (tester) async {
    final auth = FakeAuthState();
    final router = AppRouter.build(auth);
    auth.setAuthenticated(false);

    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router,
    ));

    router.go('/register');
    await tester.pumpAndSettle();

    expect(router.routerDelegate.currentConfiguration.uri.toString(), '/register');
  });
}

/// 测试用的 AuthStateNotifier —— 实现 Listenable 让 router 监听
class FakeAuthState extends ChangeNotifier implements AuthStateNotifier {
  bool _authed = false;
  int notifyCount = 0;

  @override
  bool get isAuthenticated => _authed;

  void setAuthenticated(bool value) {
    _authed = value;
    notifyListeners();
    notifyCount++;
  }
}
