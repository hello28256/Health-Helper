// SettingsPage —— 设置入口集合
//
// 设计要点：
// 1. **分组**：个人资料 / 应用 / 关于
// 2. **登出**：二次确认对话框；调 authProvider.logout()
// 3. **主题切换占位**：V0.1 仅跟随系统；V0.2 加切换
// 4. **V0.1 范围**：纯前端，不调 settings API

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_helper/pages/settings/profile_page.dart';
import 'package:health_helper/providers/auth_provider.dart';
import 'package:health_helper/theme/dimens.dart';
import 'package:health_helper/widgets/common/common.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      title: '设置',
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.space8),
        children: [
          _Section(
            title: '账号',
            children: [
              _Item(
                icon: Icons.person_outline,
                title: '个人资料',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const ProfilePage(),
                  ),
                ),
              ),
            ],
          ),
          const _Section(
            title: '应用',
            children: [
              _Item(
                icon: Icons.palette_outlined,
                title: '主题',
                trailing: Text('跟随系统'),
              ),
              _Item(
                icon: Icons.language,
                title: '语言',
                trailing: Text('简体中文'),
              ),
            ],
          ),
          const _Section(
            title: '关于',
            children: [
              _Item(
                icon: Icons.info_outline,
                title: '版本',
                trailing: Text('v0.1.0'),
              ),
              _Item(
                icon: Icons.description_outlined,
                title: '用户协议',
              ),
              _Item(
                icon: Icons.privacy_tip_outlined,
                title: '隐私政策',
              ),
            ],
          ),
          const SizedBox(height: AppDimens.space24),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.space16,
            ),
            child: FilledButton.tonalIcon(
              onPressed: () => _confirmLogout(context, ref),
              icon: const Icon(Icons.logout),
              label: const Text('退出登录'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('退出登录'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('退出'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(authProvider.notifier).logout();
    }
  }
}

// ===== 内部组件 =====

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.space16,
            AppDimens.space16,
            AppDimens.space16,
            AppDimens.space8,
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        ...children,
      ],
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing ??
          (onTap != null
              ? const Icon(Icons.chevron_right)
              : null),
      onTap: onTap,
    );
  }
}