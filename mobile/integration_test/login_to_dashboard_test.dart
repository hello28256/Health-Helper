// Integration smoke test —— 启动 → 注册 → Dashboard
//
// 设计要点：
// 1. **真后端**：需要在本地跑 backend on http://localhost:3000
// 2. **运行命令**：
//    - iOS: `flutter test integration_test -d "iPhone 15 Pro"`
//    - Android: `flutter test integration_test -d emulator-5554`
// 3. **不依赖 Firebase/HealthKit**：用 noop FCM/Push 跳过 push 路径
//    - _NoopPush.getToken() 返回 null ⇒ PushService.register() 直接 return，不会发请求
// 4. **可重复**：用时间戳邮箱确保每次注册都是新用户

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_helper/api/api_clients.dart';
import 'package:health_helper/app.dart';
import 'package:health_helper/providers/push_provider.dart';
import 'package:health_helper/services/fcm_service.dart';
import 'package:health_helper_api/health_helper_api.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('端到端冒烟：注册 → Dashboard', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          fcmServiceProvider.overrideWithValue(_NoopFCM()),
          pushServiceProvider.overrideWithValue(_NoopPush()),
        ],
        child: const HealthHelperApp(),
      ),
    );

    // 等待 splash + bootstrap
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // 1. 应该跳到 /login
    expect(find.text('登录'), findsWidgets);
    expect(find.text('邮箱'), findsOneWidget);

    // 2. 去注册
    await tester.tap(find.text('去注册'));
    await tester.pumpAndSettle();
    expect(find.text('注册'), findsWidgets);

    // 3. 填表（用时间戳邮箱避免重复）
    final ts = DateTime.now().millisecondsSinceEpoch;
    final email = 'smoke+$ts@test.com';
    final password = 'smoke123456';

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), email);
    await tester.enterText(fields.at(1), 'Smoke');
    await tester.enterText(fields.at(2), password);
    await tester.enterText(fields.at(3), password);
    await tester.pumpAndSettle();

    // 4. 提交
    await tester.tap(find.widgetWithText(FilledButton, '注册'));
    // 注册请求可能要 1-2s
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // 5. 期望跳到 /dashboard
    expect(find.text('今日步数'), findsOneWidget);
    expect(find.text('AI 心理对话'), findsWidgets);
  });
}

// ===== Mocks =====

class _NoopFCMPlatform implements FCMPlatform {
  @override
  Future<String?> getToken() async => null;
  @override
  Future<void> requestPermission() async {}
  @override
  Stream<String> get onTokenRefresh => const Stream.empty();
  @override
  Stream<FCMMessage> get onMessage => const Stream.empty();
}

class _NoopFCM extends FCMService {
  _NoopFCM() : super(platform: _NoopFCMPlatform());
}

/// Noop PushService —— getToken 返回 null，所以 register() 不会触发网络请求
/// （仅 ApiClients 实例化以满足构造签名）
class _NoopPush extends PushService {
  _NoopPush()
      : super(
          clients: ApiClients(),
          getDeviceId: () async => 'fake-device',
          getToken: () async => null,
          platform: DevicePlatform.ios,
        );
}