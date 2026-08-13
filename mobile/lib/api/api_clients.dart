// api_clients —— 9 个 generated API 类的聚合 + Dio 统一配置
//
// 设计要点：
// 1. **Dio 单例**：所有 9 个 generated API 类共享同一个 dio 实例，
//    401 refresh 拦截器只需装一次
// 2. **onRequest 注入 Authorization header**：从 TokenHolder 读 token，
//    没有就跳过（login/register/refresh 端点天然无 token）
// 3. **skipAuth 标记**：option.extra['skipAuth']=true 的请求不发 Authorization header
//    （用于 login/refresh 不应该被认证拦截的端点）
// 4. **DioException → ApiError 统一映射**：通过 onError 拦截器，
//    让上层永远只 catch ApiError 一种异常类型
// 5. **可注入**：测试可以注入自定义 holder / adapter

import 'package:dio/dio.dart';

import 'package:health_helper/api/dio_client.dart';
import 'package:health_helper/auth/token_holder.dart';
import 'package:health_helper/storage/secure_storage.dart';

// generated 代码（path dep 引用，import 'src' 在 Dart 中允许但 lint 提示）
// ignore: implementation_imports
import 'package:health_helper_api/src/api/auth_api.dart';
// ignore: implementation_imports
import 'package:health_helper_api/src/api/chat_api.dart';
// ignore: implementation_imports
import 'package:health_helper_api/src/api/devices_api.dart';
// ignore: implementation_imports
import 'package:health_helper_api/src/api/diet_api.dart';
// ignore: implementation_imports
import 'package:health_helper_api/src/api/exercises_api.dart';
// ignore: implementation_imports
import 'package:health_helper_api/src/api/health_api.dart';
// ignore: implementation_imports
import 'package:health_helper_api/src/api/mood_api.dart';
// ignore: implementation_imports
import 'package:health_helper_api/src/api/steps_api.dart';
// ignore: implementation_imports
import 'package:health_helper_api/src/api/users_api.dart';
// ignore: implementation_imports
import 'package:health_helper_api/src/serializers.dart' as gen;

/// ApiClients —— 9 个 generated API 类的容器
///
/// 持有 [Dio] 单例 + [TokenHolder] 引用 + 401 refresh 拦截器
/// 测试时可注入自定义 [adapter] / [holder]
class ApiClients {
  ApiClients({
    TokenHolder? holder,
    String baseUrl = 'http://localhost:3000',
    HttpClientAdapter? adapter,
  }) : holder = holder ?? TokenHolder(storage: PlatformSecureStorage()) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      contentType: 'application/json',
      // 关键：让 4xx/5xx 走 interceptor.onError（而不是直接 reject）
      validateStatus: (status) => status != null && status < 400,
    ));
    if (adapter != null) _dio.httpClientAdapter = adapter;

    _dio.interceptors.add(_authHeaderInterceptor());
    _dio.interceptors.add(_errorMapInterceptor());

    _wireApiClasses();
  }

  /// Token holder：用于 onRequest 拦截器读 access token
  final TokenHolder holder;

  /// Dio 实例：所有 9 个 generated API 类共用
  late final Dio _dio;
  Dio get dio => _dio;

  // ===== 9 个 generated API 实例 =====
  late final AuthApi auth;
  late final UsersApi users;
  late final ExercisesApi exercises;
  late final StepsApi steps;
  late final DietApi diet;
  late final MoodApi mood;
  late final ChatApi chat;
  late final HealthApi health;
  late final DevicesApi devices;

  void _wireApiClasses() {
    auth = AuthApi(_dio, gen.serializers);
    users = UsersApi(_dio, gen.serializers);
    exercises = ExercisesApi(_dio, gen.serializers);
    steps = StepsApi(_dio, gen.serializers);
    diet = DietApi(_dio, gen.serializers);
    mood = MoodApi(_dio, gen.serializers);
    chat = ChatApi(_dio, gen.serializers);
    health = HealthApi(_dio, gen.serializers);
    devices = DevicesApi(_dio, gen.serializers);
  }

  /// onRequest：注入 Authorization header（除非 skipAuth=true 或没有 token）
  Interceptor _authHeaderInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (options.extra['skipAuth'] != true) {
          final access = await holder.getAccessToken();
          if (access != null && access.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $access';
          }
        }
        handler.next(options);
      },
    );
  }

  /// onError：DioException → ApiError 统一映射
  ///
  /// refresh 401 是正常流程（在 dio_client.refreshInterceptor 处理），不映射成 ApiError；
  /// 这里只处理业务错误。直接抛 ApiError 而不是 DioException，
  /// 让上层只 catch 一种异常类型。
  Interceptor _errorMapInterceptor() {
    return InterceptorsWrapper(
      onError: (err, handler) {
        final mapped = mapDioErrorToApiError(err);
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            response: err.response,
            type: err.type,
            error: mapped,
            message: mapped.message,
            stackTrace: err.stackTrace,
          ),
        );
      },
    );
  }

  /// 关闭（注销场景）
  void close() {
    _dio.close(force: true);
  }
}
