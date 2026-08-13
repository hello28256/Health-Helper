// HealthHelperApp —— 应用根 widget
//
// 设计要点：
// 1. **MaterialApp.router**：用 go_router
// 2. **AuthStateNotifier 实现**：包 Riverpod authProvider → Listenable adapter
// 3. **主题**：浅色 + 暗色（跟随系统 ThemeMode.system）
// 4. **V0.1 启动时 token 注册**：监听 auth 状态变化，登录后调 pushService.register()

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_helper/providers/auth_provider.dart';
import 'package:health_helper/providers/push_provider.dart';
import 'package:health_helper/router/app_router.dart';
import 'package:health_helper/theme/app_theme.dart';

/// 桥接 Riverpod authProvider → AppRouter 需要的 Listenable
class _RiverpodAuthNotifier extends ChangeNotifier
    implements AuthStateNotifier {
  _RiverpodAuthNotifier(WidgetRef ref) {
    _sub = ref.listenManual<AsyncValue<AuthState>>(
      authProvider,
      (_, _) => notifyListeners(),
    );
    _ref = ref;
  }
  late final ProviderSubscription<AsyncValue<AuthState>> _sub;
  late final WidgetRef _ref;

  @override
  bool get isAuthenticated => _ref.read(authProvider).value is Authenticated;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}

class HealthHelperApp extends ConsumerWidget {
  const HealthHelperApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = _RiverpodAuthNotifier(ref);

    // 登录成功 → 注册 push token（幂等）
    ref.listen<AsyncValue<AuthState>>(authProvider, (prev, next) {
      final wasAuth = prev?.value is Authenticated;
      final isAuth = next.value is Authenticated;
      if (!wasAuth && isAuth) {
        // 刚登录成功
        final push = ref.read(pushServiceProvider);
        // ignore: discarded_futures
        push.register().catchError((Object e) {
          debugPrint('[DEBUG] push register failed: $e');
          return null;
        });
      } else if (wasAuth && !isAuth) {
        // 登出 → 撤销
        final push = ref.read(pushServiceProvider);
        // ignore: discarded_futures
        push.revoke().catchError((Object e) {
          debugPrint('[DEBUG] push revoke failed: $e');
        });
      }
    });

    final router = AppRouter.build(auth);
    return MaterialApp.router(
      title: 'Health Helper',
      theme: AppTheme.buildLightTheme(),
      darkTheme: AppTheme.buildDarkTheme(),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}