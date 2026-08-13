// auth_provider —— Riverpod 状态层：管理 AuthState（Authenticated / Unauthenticated）
//
// 设计要点：
// 1. **sealed AuthState**：UI 层能用 exhaustive switch 处理所有状态
// 2. **bootstrap 流程**：build() 启动时检查 token → 拉 /me 验证 → 决定 Authenticated/Unauthenticated
// 3. **onAuthFailed**：给 C3 401 拦截器调用，自动清 token + 状态切换
// 4. **login/logout 状态机**：UI 操作 → 状态变化 → router redirect 自动跳转
// 5. **错误处理**：用 ApiError 统一捕获业务错误（来自 C4 错误映射拦截器）

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_helper/api/api_clients.dart';
import 'package:health_helper/api/api_error.dart';
import 'package:health_helper/auth/token_holder.dart';
import 'package:health_helper/storage/secure_storage.dart';

import 'package:health_helper_api/health_helper_api.dart';

// ===== Sealed AuthState =====

sealed class AuthState {
  const AuthState();
}

/// 初始 / 加载中
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// 已登录
class Authenticated extends AuthState {
  const Authenticated(this.user);
  final PublicUser user;

  @override
  bool operator ==(Object other) =>
      other is Authenticated && other.user.id == user.id;
  @override
  int get hashCode => user.id?.hashCode ?? 0;
}

/// 未登录（可能带错误信息）
class Unauthenticated extends AuthState {
  const Unauthenticated([this.error]);
  final String? error;

  @override
  bool operator ==(Object other) =>
      other is Unauthenticated && other.error == error;
  @override
  int get hashCode => error?.hashCode ?? 0;
}

// ===== Providers（DAG 注入） =====

/// TokenHolder 单例（底层是 secure_storage）
final tokenHolderProvider = Provider<TokenHolder>((ref) {
  return TokenHolder(storage: PlatformSecureStorage());
});

/// ApiClients 单例（持有 dio + 9 个 API 类）
final apiClientsProvider = Provider<ApiClients>((ref) {
  final holder = ref.watch(tokenHolderProvider);
  return ApiClients(holder: holder);
});

/// AuthNotifier —— AsyncNotifier 持有 AuthState
final authProvider =
    AsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final clients = ref.read(apiClientsProvider);
    final holder = ref.read(tokenHolderProvider);

    // ===== bootstrap：检查 token 决定状态 =====
    if (!await holder.hasAny()) {
      return const Unauthenticated();
    }

    // 有 token → 拉 /me 验证（401 → 拦截器会自动 refresh；refresh 失败 → onAuthFailed）
    try {
      // 绕过 generated 反序列化 bug：自己 deserialize
      final resp = await clients.dio.get<dynamic>('/api/users/me');
      final rawData = resp.data;
      if (rawData is! Map) {
        await holder.clear();
        return const Unauthenticated('invalid response');
      }
      final user = standardSerializers.deserializeWith(
        PublicUser.serializer,
        rawData,
      ) as PublicUser;
      return Authenticated(user);
    } on DioException catch (e) {
      // 拦截器已经把 ApiError 塞到 e.error
      final apiErr = e.error is ApiError ? e.error as ApiError : null;
      await holder.clear();
      return Unauthenticated(apiErr?.message ?? 'session expired');
    }
  }

  Future<void> login({required String email, required String password}) async {
    final clients = ref.read(apiClientsProvider);
    final holder = ref.read(tokenHolderProvider);

    state = const AsyncData<AuthState>(AuthLoading());

    try {
      // 绕过 generated 反序列化 bug：直接走 dio + 自己 deserialize
      final resp = await clients.dio.post<dynamic>(
        '/api/auth/login',
        data: {'email': email, 'password': password},
      );
      final raw = resp.data;
      if (raw is! Map) {
        state = const AsyncData<AuthState>(Unauthenticated('empty response'));
        return;
      }
      final result = standardSerializers.deserializeWith(
        AuthResult.serializer,
        raw,
      ) as AuthResult;

      await holder.save(
        accessToken: result.accessToken!,
        refreshToken: result.refreshToken!,
      );
      state = AsyncData<AuthState>(Authenticated(result.user!));
    } on DioException catch (e) {
      final apiErr = e.error is ApiError ? e.error as ApiError : null;
      state = AsyncData<AuthState>(
        Unauthenticated(apiErr?.message ?? 'login failed'),
      );
    }
  }

  Future<void> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final clients = ref.read(apiClientsProvider);
    final holder = ref.read(tokenHolderProvider);

    state = const AsyncData<AuthState>(AuthLoading());

    try {
      final resp = await clients.dio.post<dynamic>(
        '/api/auth/register',
        data: {
          'email': email,
          'password': password,
          // ignore: use_null_aware_elements
          if (displayName != null) 'displayName': displayName,
        },
      );
      final raw = resp.data;
      if (raw is! Map) {
        state = const AsyncData<AuthState>(Unauthenticated('empty response'));
        return;
      }
      final result = standardSerializers.deserializeWith(
        AuthResult.serializer,
        raw,
      ) as AuthResult;

      await holder.save(
        accessToken: result.accessToken!,
        refreshToken: result.refreshToken!,
      );
      state = AsyncData<AuthState>(Authenticated(result.user!));
    } on DioException catch (e) {
      final apiErr = e.error is ApiError ? e.error as ApiError : null;
      state = AsyncData<AuthState>(
        Unauthenticated(apiErr?.message ?? 'register failed'),
      );
    }
  }

  Future<void> logout() async {
    final clients = ref.read(apiClientsProvider);
    final holder = ref.read(tokenHolderProvider);

    try {
      // logout 端点（带 refreshToken，fire-and-forget，失败也清 token）
      final refresh = await holder.getRefreshToken();
      if (refresh != null) {
        final req = ApiAuthRefreshPostRequest((b) => b
          ..refreshToken = refresh);
        await clients.auth.apiAuthLogoutPost(
          apiAuthRefreshPostRequest: req,
        );
      }
    } catch (_) {
      // ignore：清本地 token 优先
    }
    await holder.clear();
    state = const AsyncData<AuthState>(Unauthenticated());
  }

  /// C3 拦截器调用：refresh 失败时清 token + 状态变 Unauthenticated
  /// 让 router redirect 自动跳 /login
  void onAuthFailed() {
    final holder = ref.read(tokenHolderProvider);
    holder.clear();
    state = const AsyncData<AuthState>(Unauthenticated('session expired'));
  }

  /// C3 拦截器调用：refresh 成功后更新本地 token（rotation）
  Future<void> onRefreshSucceeded({
    required String accessToken,
    required String refreshToken,
  }) async {
    final holder = ref.read(tokenHolderProvider);
    await holder.save(accessToken: accessToken, refreshToken: refreshToken);
  }
}

