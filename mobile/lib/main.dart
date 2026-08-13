// main.dart —— App 启动入口
//
// 设计要点：
// 1. **WidgetsFlutterBinding.ensureInitialized()**：调 platform channel 前必须
// 2. **Firebase.initializeApp()**：FCM/APNs 前置；失败也不阻塞 UI 启动（仅 log）
// 3. **FCM 初始化**：拉 token + 监听 refresh + 后台 handler top-level 注册
// 4. **App 渲染**：ProviderScope + HealthHelperApp
// 5. **错误兜底**：runZonedGuarded 捕获所有异步异常并 log
//
// V0.1 简化：PushService.register/revoke 由 UI 层（auth provider）在登录/登出时调，
// 不在 main 阶段预构造（ApiClients 依赖 TokenHolder 异步初始化）

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:health_helper/app.dart';
import 'package:health_helper/services/fcm_service.dart';

/// 后台消息 handler（必须 top-level + @pragma('vm:entry-point')）
@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await fcmBackgroundHandler(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase + FCM 后台 handler
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  } catch (e, st) {
    debugPrint('[DEBUG] Firebase init failed: $e\n$st');
  }

  // FCMService 单例
  final fcmService = FCMService();
  try {
    await fcmService.init();
  } catch (e, st) {
    debugPrint('[DEBUG] FCM init failed: $e\n$st');
  }

  runZonedGuarded<void>(
    () => runApp(
      ProviderScope(
        overrides: [
          fcmServiceProvider.overrideWithValue(fcmService),
        ],
        child: const HealthHelperApp(),
      ),
    ),
    (error, stack) {
      debugPrint('[DEBUG] uncaught: $error\n$stack');
    },
  );
}