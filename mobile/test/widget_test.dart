// Smoke test —— HealthHelperApp 启动 + 跳到登录页
//
// 设计要点：仅验证 bootstrap 不崩；具体页面跳转逻辑在 router 测试里覆盖

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_helper/app.dart';
import 'package:health_helper/providers/auth_provider.dart';
import 'package:health_helper/services/fcm_service.dart';
import 'package:health_helper/theme/app_theme.dart';

void main() {
  testWidgets('HealthHelperApp bootstrap 不崩', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(
            () => _FakeAuthNotifier(),
          ),
          fcmServiceProvider.overrideWithValue(_NoopFCM()),
        ],
        child: MaterialApp(
          theme: AppTheme.buildLightTheme(),
          home: const HealthHelperApp(),
        ),
      ),
    );
    await tester.pump();
    // app 渲染即可（router 跳到 /login 是 router test 范围）
    expect(find.byType(MaterialApp), findsWidgets);
  });
}

class _FakeAuthNotifier extends AuthNotifier {
  @override
  Future<AuthState> build() async => const Unauthenticated();
}

class _NoopFCM extends FCMService {
  @override
  Future<void> init() async {}
  @override
  Future<String?> fetchToken() async => null;
}