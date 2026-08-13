// FCMService —— Firebase Cloud Messaging + flutter_local_notifications 集成
//
// 设计要点：
// 1. **前台 + 后台消息统一**：onMessage（前台）+ onBackgroundMessage（独立 top-level）
// 2. **Token 拉取**：FirebaseMessaging.instance.getToken()（Android）/APNs token 自动桥接（iOS）
// 3. **本地通知展示**：前台收到推送时 flutter_local_notifications 显示
// 4. **后台 handler 必须 `@pragma('vm:entry-point')` 且 top-level**，否则 AOT tree-shake 掉
// 5. **测试用 mock**：构造函数收抽象函数 getToken/onMessageListener，避免直接 import firebase
//
// 注意：本文件依赖 firebase_core/firebase_messaging/flutter_local_notifications；
// 真实初始化在 main.dart bootstrap 时 await FCMService.init()

// ignore_for_file: prefer_initializing_formals

import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 推送消息 DTO（统一前后台）
@immutable
class FCMMessage {
  const FCMMessage({
    this.id,
    this.title,
    this.body,
    this.data = const {},
  });
  final String? id;
  final String? title;
  final String? body;
  final Map<String, dynamic> data;
}

typedef FCMMessageListener = void Function(FCMMessage message);

abstract class FCMPlatform {
  Future<String?> getToken();
  Future<void> requestPermission();
  Stream<String> get onTokenRefresh;
  Stream<FCMMessage> get onMessage;
}

class _ProductionFCMPlatform implements FCMPlatform {
  _ProductionFCMPlatform() : _messaging = FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;

  @override
  Future<String?> getToken() => _messaging.getToken();

  @override
  Future<void> requestPermission() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);
  }

  @override
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  @override
  Stream<FCMMessage> get onMessage =>
      FirebaseMessaging.onMessage.map(_convert);
}

/// 把 RemoteMessage 转 FCMMessage
FCMMessage _convert(RemoteMessage m) => FCMMessage(
      id: m.messageId,
      title: m.notification?.title ?? m.data['title'] as String?,
      body: m.notification?.body ?? m.data['body'] as String?,
      data: m.data,
    );

class FCMService {
  FCMService({
    FCMPlatform? platform,
    FlutterLocalNotificationsPlugin? localNotifications,
  })  : _platform = platform ?? _ProductionFCMPlatform(),
        _local = localNotifications ?? FlutterLocalNotificationsPlugin();

  final FCMPlatform _platform;
  final FlutterLocalNotificationsPlugin _local;
  final List<FCMMessageListener> _listeners = [];
  StreamSubscription<String>? _tokenSub;
  StreamSubscription<FCMMessage>? _msgSub;

  /// 初始化：注册本地通知 channel + 拉 token + 监听刷新
  Future<void> init() async {
    // Android channel
    const channel = AndroidNotificationChannel(
      'health_helper_default',
      'Health Helper',
      description: 'General health reminders',
      importance: Importance.high,
    );
    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await _local.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );

    await _platform.requestPermission();

    _msgSub = _platform.onMessage.listen(_onForeground);
    _tokenSub = _platform.onTokenRefresh.listen((t) {
      // Token 刷新由 push_service.handleTokenRefresh() 统一处理
      // 这里只 log
      debugPrint('[DEBUG] FCM token refreshed: $t');
    });
  }

  Future<String?> fetchToken() => _platform.getToken();

  void onMessage(FCMMessageListener listener) => _listeners.add(listener);

  void removeOnMessage(FCMMessageListener listener) =>
      _listeners.remove(listener);

  /// 调试用：触发所有 listener（仅测试）
  @visibleForTesting
  void debugEmit(FCMMessage msg) {
    for (final l in List.of(_listeners)) {
      l(msg);
    }
  }

  /// 释放
  Future<void> dispose() async {
    await _tokenSub?.cancel();
    await _msgSub?.cancel();
  }

  // ===== 内部 =====

  void _onForeground(FCMMessage msg) {
    // 显示本地通知
    _local.show(
      msg.id.hashCode & 0x7fffffff,
      msg.title ?? '',
      msg.body ?? '',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'health_helper_default',
          'Health Helper',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: msg.data.toString(),
    );
    // 通知 listener（供 push_service 注册用）
    for (final l in List.of(_listeners)) {
      l(msg);
    }
  }
}

/// Riverpod provider
final fcmServiceProvider = Provider<FCMService>((ref) {
  return FCMService();
});

/// ===== 后台 handler（top-level 必须） =====
/// 必须在 main() 顶层 `FirebaseMessaging.onBackgroundMessage(_backgroundHandler)` 注册
@pragma('vm:entry-point')
Future<void> fcmBackgroundHandler(RemoteMessage message) async {
  // 收到后台消息时的处理（V0.1 仅 log；后续可在此触发本地通知）
  debugPrint('[DEBUG] background message: ${message.messageId}');
}