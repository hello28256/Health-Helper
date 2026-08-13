// ProfilePage —— 显示当前用户信息（PublicUser 字段）
//
// 设计要点：
// 1. **展示优先**：纯展示页面（V0.1），后续在 E9 完整版本可加编辑
// 2. **loading/error/data 三态**：watch authProvider
// 3. **空字段占位**：可选字段（身高/体重/出生日期）未填显示 "—"

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_helper/providers/auth_provider.dart';
import 'package:health_helper/theme/dimens.dart';
import 'package:health_helper/widgets/common/common.dart';
import 'package:health_helper_api/health_helper_api.dart';
import 'package:intl/intl.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    return AppScaffold(
      title: '个人资料',
      body: AsyncValueWidget(
        value: auth,
        data: (state) {
          if (state is! Authenticated) {
            return const EmptyView(message: '未登录');
          }
          return _ProfileBody(user: state.user);
        },
        onRetry: () => ref.invalidate(authProvider),
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({required this.user});
  final PublicUser user;

  String _fmtDate(DateTime? d) {
    if (d == null) return '—';
    return DateFormat('yyyy-MM-dd').format(d);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppDimens.space16),
      children: [
        // 头像 + 邮箱
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  (user.displayName ?? user.email ?? '?').characters.first.toUpperCase(),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(height: AppDimens.space12),
              Text(
                user.displayName ?? '未设置昵称',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppDimens.space4),
              Text(
                user.email ?? '-',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.space24),
        _InfoTile(label: '身高', value: user.heightCm != null ? '${user.heightCm} cm' : '—'),
        _InfoTile(label: '体重', value: user.weightKg != null ? '${user.weightKg} kg' : '—'),
        _InfoTile(label: '出生日期', value: _fmtDate(user.birthDate)),
        _InfoTile(label: '注册时间', value: _fmtDate(user.createdAt)),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.space8),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.space16,
        vertical: AppDimens.space12,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppDimens.radius12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}