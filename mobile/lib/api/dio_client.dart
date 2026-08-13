// dio_client —— 集中式 HTTP client 配置
//
// 关键设计：
// 1. **401 refresh Completer 单例锁**：并发多个 401 只触发一次 refresh；
//    后续 401 请求共享同一个 completer 的 promise，避免 token rotation 竞态
// 2. **retried 标记**：第一次重试后置 true，第二次 401 直接抛错
// 3. **onAuthFailed 回调**：refresh 失败时调用，由调用方决定跳登录页
// 4. **重放由调用方负责**：refreshInterceptor 只发 refresh 请求；用 caller
//    提供的 [retryWithNewToken] 把原请求重发，保持同一 dio 实例的拦截器链路
// 5. **DioException → ApiError**：让上层只 catch 一种异常类型
//
// ApiError 定义在 api_error.dart，本文件 re-export 给上层用

import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:health_helper/api/api_error.dart';

export 'package:health_helper/api/api_error.dart' show ApiError;

/// 全局单例的 refresh 锁（一个 App 只有一个）
Completer<void>? _refreshInFlight;

/// Leader 选举：原子检测 + 创建 completer
///
/// Dart 单线程，函数体内无 await，整段同步原子。
bool _tryBecomeLeader() {
  if (_refreshInFlight != null) return false;
  _refreshInFlight = Completer<void>();
  return true;
}

/// 401 refresh 拦截器
///
/// [refreshCall] 由调用方实现真正发请求的逻辑（含更新 token holder）
/// [retryWithNewToken] refresh 成功后由调用方用同一个 dio 实例重发原请求
/// [onAuthFailed] refresh 失败时调用，UI 层可跳登录页
Interceptor refreshInterceptor({
  required Future<Response<dynamic>> Function() refreshCall,
  required Future<Response<dynamic>> Function(RequestOptions) retryWithNewToken,
  required void Function() onAuthFailed,
}) {
  return InterceptorsWrapper(
    onError: (err, handler) async {
      final status = err.response?.statusCode;
      final retried = err.requestOptions.extra['retried'] == true;
      final skipAuth = err.requestOptions.extra['skipAuth'] == true;

      // 只对 401 走 refresh；非 401 直接抛 DioException（保留原 err 链路）
      if (status != 401 || retried || skipAuth) {
        return handler.next(err);
      }

      // ===== 原子 leader 选举 =====
      final isLeader = _tryBecomeLeader();
      final completer = _refreshInFlight!;

      try {
        if (isLeader) {
          // Leader：执行 refresh
          final resp = await refreshCall();
          if (resp.statusCode == null || resp.statusCode! >= 400) {
            throw DioException(
              requestOptions: err.requestOptions,
              response: resp,
              type: DioExceptionType.badResponse,
            );
          }
          completer.complete();
        } else {
          // Follower：等锁。异常被外层 catch 兜住
          await completer.future;
        }

        // ===== 用调用方提供的 retry 回调重放 =====
        err.requestOptions.extra['retried'] = true;
        final retriedResp = await retryWithNewToken(err.requestOptions);
        return handler.resolve(retriedResp);
      } catch (_) {
        if (isLeader && !completer.isCompleted) {
          completer.complete();
        }
        onAuthFailed();
        return handler.next(err);
      } finally {
        if (_refreshInFlight == completer) _refreshInFlight = null;
      }
    },
  );
}

/// DioException → ApiError 映射
///
/// 处理两种 data 格式：
/// 1. dio 已自动 JSON parse → Map
/// 2. data 还是 String（MockAdapter / responseType 非 json 时）
ApiError mapDioErrorToApiError(DioException err) {
  final res = err.response;
  final status = res?.statusCode;
  var data = res?.data;

  if (data is String && data.isNotEmpty) {
    try {
      data = json.decode(data);
    } catch (_) {
      data = null;
    }
  }

  if (data is Map && data['error'] is Map) {
    final errObj = data['error'] as Map;
    return ApiError(
      code: errObj['code']?.toString() ?? 'UNKNOWN',
      message: errObj['message']?.toString() ?? err.message ?? 'Unknown error',
      status: status,
      details: errObj['details'],
    );
  }
  return ApiError(
    code: status != null ? 'HTTP_$status' : 'NETWORK_ERROR',
    message: err.message ?? 'Network error',
    status: status,
  );
}
