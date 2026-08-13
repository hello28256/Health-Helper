// LoginPage —— 邮箱密码登录
//
// 设计要点：
// 1. **ConsumerStatefulWidget**：表单状态用 local state，不污染 Riverpod
// 2. **authProvider 不直接 listen**：用 `ref.read` 触发 action，从 state 派生 UI（loading button / error banner）
// 3. **表单校验**：邮箱格式 + 密码 ≥ 6 位
// 4. **错误展示**：state.error 是 ApiError.message，醒目红色显示

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:health_helper/providers/auth_provider.dart';
import 'package:health_helper/theme/dimens.dart';
import 'package:health_helper/widgets/common/common.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authProvider.notifier).login(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    // 监听 authProvider 状态：成功后 router 自动跳 dashboard
    ref.listen(authProvider, (prev, next) {
      // 登录失败已通过 Unauthenticated.error 表达；成功由 router redirect 接管
      // 这里只用来 focus password 等副作用，目前无操作
    });

    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;
    // 失败时把 ApiError.message 显示在表单上方
    final errorText =
        authState.valueOrNull is Unauthenticated
            ? (authState.valueOrNull as Unauthenticated).error
            : null;

    return AppScaffold(
      title: '登录',
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimens.space24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // logo / 标题
                  Icon(
                    Icons.favorite,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: AppDimens.space16),
                  Text(
                    'Health Helper',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppDimens.space32),
                  // 错误 banner
                  if (errorText != null)
                    Container(
                      padding: const EdgeInsets.all(AppDimens.space12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius:
                            BorderRadius.circular(AppDimens.radius8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Theme.of(context).colorScheme.onErrorContainer,
                          ),
                          const SizedBox(width: AppDimens.space8),
                          Expanded(
                            child: Text(
                              errorText,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onErrorContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (errorText != null)
                    const SizedBox(height: AppDimens.space16),
                  TextFormField(
                    controller: _emailCtrl,
                    enabled: !isLoading,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      labelText: '邮箱',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return '请输入邮箱';
                      if (!v.contains('@')) return '邮箱格式不正确';
                      return null;
                    },
                  ),
                  const SizedBox(height: AppDimens.space16),
                  TextFormField(
                    controller: _passwordCtrl,
                    enabled: !isLoading,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: '密码',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.length < 6) return '密码至少 6 位';
                      return null;
                    },
                  ),
                  const SizedBox(height: AppDimens.space24),
                  FilledButton(
                    onPressed: isLoading ? null : _submit,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('登录'),
                  ),
                  const SizedBox(height: AppDimens.space16),
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () => context.go('/register'),
                    child: const Text('还没有账号？去注册'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}