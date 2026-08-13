// push_provider —— APNs/FCM 推送集成
//
// 设计要点：
// 1. **PushService 是普通类（非 Notifier）**：push 没有响应式状态需要监听
// 2. **依赖注入**：getToken/getDeviceId 都是函数引用，生产环境用 FirebaseMessaging.instance.getToken() / DeviceIdStorage.getOrCreate()；测试用 mock
// 3. **幂等注册**：本地保存 lastRegisteredToken，token 没变就不重发请求
// 4. **onMessage listener 模式**：UI 注册回调，收到推送时统一通知
// 5. **登出撤销**：调 DELETE /api/devices/{deviceId} 让后端停止发推送
// 6. **错误透传**：ApiError 抛给调用方（auth 拦截器会处理 401 自动 refresh）

// ignore_for_file: sort_constructors_first, prefer_initializing_formals

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_helper/api/api_clients.dart';
import 'package:health_helper/api/api_error.dart';

import 'package:health_helper_api/health_helper_api.dart';

/// 推送消息 DTO（前台收到时使用）
@immutable
class PushMessage {
  final String? title;
  final String? body;
  final Map<String, dynamic>? data;

  const PushMessage({this.title, this.body, this.data});

  @override
  bool operator ==(Object other) =>
      other is PushMessage &&
      other.title == title &&
      other.body == body;

  @override
  int get hashCode => Object.hash(title, body);
}

/// 推送消息回调
typedef PushMessageListener = void Function(PushMessage message);

/// 推送服务（无状态：除 listener 列表 + lastToken 外）
class PushService {
  PushService({
    required ApiClients clients,
    required Future<String?> Function() getDeviceId,
    required Future<String?> Function() getToken,
    required DevicePlatform platform,
  })  : _clients = clients,
        _getDeviceId = getDeviceId,
        _getToken = getToken,
        _platform = platform;

  /// 最后一次注册的 token（用于幂等判断）
  String? _lastRegisteredToken;

  /// 监听器列表
  final List<PushMessageListener> _listeners = [];

  final ApiClients _clients;
  final Future<String?> Function() _getDeviceId;
  final Future<String?> Function() _getToken;
  final DevicePlatform _platform;

  /// 注册 token 到后端（幂等：相同 token 跳过）
  Future<String?> register() async {
    final token = await _getToken();
    if (token == null) {
      // 没拿到 token（用户未授权推送 / 模拟器）
      return null;
    }
    if (token == _lastRegisteredToken) {
      // 幂等：token 未变
      return token;
    }

    final deviceId = await _getDeviceId();
    try {
      final isApns = _platform == DevicePlatform.ios;
      await _clients.dio.post<dynamic>(
        '/api/devices',
        data: {
          'deviceId': deviceId,
          'platform': _platform.name,
          if (isApns) 'apnsToken': token,
          if (!isApns) 'fcmToken': token,
        },
      );
      _lastRegisteredToken = token;
      return token;
    } on DioException catch (e) {
      final apiErr = e.error is ApiError ? e.error as ApiError : null;
      throw apiErr ??
          ApiError(
            code: 'NETWORK_ERROR',
            message: e.message ?? 'register failed',
          );
    }
  }

  /// 撤销设备（登出时调用）
  Future<void> revoke() async {
    final deviceId = await _getDeviceId();
    try {
      await _clients.dio.delete<dynamic>('/api/devices/$deviceId');
      _lastRegisteredToken = null;
    } on DioException catch (e) {
      final apiErr = e.error is ApiError ? e.error as ApiError : null;
      throw apiErr ??
          ApiError(
            code: 'NETWORK_ERROR',
            message: e.message ?? 'revoke failed',
          );
    }
  }

  /// 注册前台消息回调
  void onMessage(PushMessageListener listener) {
    _listeners.add(listener);
  }

  /// 取消前台消息回调
  void removeOnMessage(PushMessageListener listener) {
    _listeners.remove(listener);
  }

  /// 处理 token 刷新事件（外部触发：FCM onTokenRefresh）
  Future<void> handleTokenRefresh() async {
    _lastRegisteredToken = null; // 强制重新注册
    await register();
  }

  /// 调试用：触发所有 listener（仅测试）
  @visibleForTesting
  void debugEmitMessage(PushMessage msg) {
    for (final l in List.of(_listeners)) {
      l(msg);
    }
  }
}

/// Riverpod provider（注入生产环境依赖）
final pushServiceProvider = Provider<PushService>((ref) {
  // 注意：调用方需在 main() 里 override 这个 provider，注入 Firebase + deviceId 实现
  // 默认实现仅供测试与 placeholder
  throw UnimplementedError(
    'pushServiceProvider must be overridden in main.dart with real impl',
  );
});