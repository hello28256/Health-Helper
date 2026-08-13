// app_router —— go_router 集中配置 + auth redirect
//
// 设计要点：
// 1. **redirect**：未登录访问受保护路由 → /login；已登录访问 /login 或 /register → /dashboard
// 2. **refreshListenable**：监听 auth 状态变化，触发路由器重新评估 redirect
// 3. **公开路由白名单**：/login、/register 不需要认证
// 4. **受保护路由**：/dashboard、/record、/trend、/chat、/settings 等

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// AuthStateNotifier 接口 —— AppRouter 通过它判断登录状态
///
/// 实现 [Listenable] 让 router 能监听 auth 变化自动重新评估 redirect
/// 实际实现（D1）会用 Riverpod provider 包装 TokenHolder
abstract class AuthStateNotifier implements Listenable {
  bool get isAuthenticated;
}

/// AppRouter 静态工厂 + helper
class AppRouter {
  /// 构建 GoRouter 实例
  ///
  /// [auth] 必须实现 [Listenable] 且 [isAuthenticated] 返回当前登录状态
  static GoRouter build(AuthStateNotifier auth) {
    return GoRouter(
      initialLocation: '/',
      // 监听 auth 变化：状态变化触发 redirect 重新评估
      refreshListenable: auth,
      redirect: (context, state) {
        final isAuthed = auth.isAuthenticated;
        final loc = state.matchedLocation;

        // 公开路由白名单（任何时候都能访问）
        final isPublicRoute = loc == '/login' || loc == '/register';

        if (!isAuthed) {
          // 未登录 → 受保护路由跳 /login
          if (!isPublicRoute) return '/login';
        } else {
          // 已登录 → 访问登录/注册页时跳 /dashboard
          if (isPublicRoute) return '/dashboard';
        }
        return null; // 不重定向
      },
      routes: [
        GoRoute(path: '/', redirect: (_, _) => '/dashboard'),
        GoRoute(path: '/login', builder: (_, _) => const _LoginPlaceholder()),
        GoRoute(path: '/register', builder: (_, _) => const _RegisterPlaceholder()),
        GoRoute(path: '/dashboard', builder: (_, _) => const _DashboardPlaceholder()),
      ],
    );
  }
}

// ===== 测试占位 widget（真实页面在 E 阶段实现） =====

class _LoginPlaceholder extends StatelessWidget {
  const _LoginPlaceholder();
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Login Page')));
}

class _RegisterPlaceholder extends StatelessWidget {
  const _RegisterPlaceholder();
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Register Page')));
}

class _DashboardPlaceholder extends StatelessWidget {
  const _DashboardPlaceholder();
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Dashboard Page')));
}
