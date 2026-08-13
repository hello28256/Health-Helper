// DashboardPage —— 核心数据汇总页
//
// 设计要点：
// 1. **5 个数据卡片**：今日步数 / 今日运动卡路里 / 今日饮食卡路里 / 今日情绪 / 最近一次心率
// 2. **下拉刷新**：RefreshIndicator 触发重新拉所有 provider
// 3. **AsyncValueWidget 统一三态**：每个卡片独立 loading/error/data
// 4. **步数环进度**：用 Stack + 圆环展示今日步数 / 10000 目标
// 5. **空数据降级**：列表为空显示 EmptyView，文案按 metric 定制

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_helper/providers/auth_provider.dart';
import 'package:health_helper/providers/diet_provider.dart';
import 'package:health_helper/providers/exercises_provider.dart';
import 'package:health_helper/providers/health_provider.dart';
import 'package:health_helper/providers/mood_provider.dart';
import 'package:health_helper/providers/steps_provider.dart';
import 'package:health_helper/theme/colors.dart';
import 'package:health_helper/theme/dimens.dart';
import 'package:health_helper/widgets/common/common.dart';
import 'package:health_helper_api/health_helper_api.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final displayName = auth.valueOrNull is Authenticated
        ? (auth.valueOrNull as Authenticated).user.displayName
        : null;

    return AppScaffold(
      title: 'Health Helper',
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(stepsProvider);
          ref.invalidate(exercisesProvider);
          ref.invalidate(dietProvider);
          ref.invalidate(moodProvider);
          ref.invalidate(latestRecordProvider(HealthMetric.heartRate));
        },
        child: ListView(
          padding: const EdgeInsets.all(AppDimens.space16),
          children: [
            // ===== 欢迎语 =====
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimens.space8,
              ),
              child: Text(
                displayName == null ? '你好 👋' : '你好，$displayName 👋',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: AppDimens.space16),
            // ===== 步数环（大卡）=====
            _StepsCard(),
            const SizedBox(height: AppDimens.space16),
            // ===== 4 个小卡 =====
            const Row(
              children: [
                Expanded(child: _KcalCard(metric: '运动')),
                SizedBox(width: AppDimens.space12),
                Expanded(child: _KcalCard(metric: '饮食')),
              ],
            ),
            const SizedBox(height: AppDimens.space12),
            const Row(
              children: [
                Expanded(child: _MoodCard()),
                SizedBox(width: AppDimens.space12),
                Expanded(child: _HeartRateCard()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ===== 今日步数（大卡：圆环进度）=====

class _StepsCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stepsAsync = ref.watch(stepsProvider);
    return AsyncValueWidget(
      value: stepsAsync,
      data: (records) {
        // 找今日（最近一条）
        if (records.isEmpty) {
          return const _BigCard(
            title: '今日步数',
            icon: Icons.directions_walk,
            color: AppColors.chartSteps,
            child: _EmptyData('今日暂无步数数据'),
          );
        }
        final today = records.first;
        final steps = today.steps ?? 0;
        final goal = 10000;
        final ratio = (steps / goal).clamp(0.0, 1.0);
        return _BigCard(
          title: '今日步数',
          icon: Icons.directions_walk,
          color: AppColors.chartSteps,
          child: Column(
            children: [
              SizedBox(
                height: 120,
                width: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: CircularProgressIndicator(
                        value: ratio,
                        strokeWidth: 8,
                        backgroundColor: AppColors.neutral200,
                        valueColor: const AlwaysStoppedAnimation(
                          AppColors.chartSteps,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$steps',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          '/ $goal',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.space12),
              Text(
                '${(ratio * 100).toStringAsFixed(0)}% 完成',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        );
      },
      onRetry: () => ref.invalidate(stepsProvider),
    );
  }
}

// ===== 卡路里卡（运动 or 饮食）=====

class _KcalCard extends ConsumerWidget {
  const _KcalCard({required this.metric});
  final String metric; // "运动" | "饮食"

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (metric == '运动') {
      final exAsync = ref.watch(exercisesProvider);
      return AsyncValueWidget(
        value: exAsync,
        data: (list) {
          // 计算今日总 kcal
          final today = DateTime.now();
          final startOfDay = DateTime(today.year, today.month, today.day);
          final total = list
              .where((e) =>
                  e.startedAt != null && e.startedAt!.isAfter(startOfDay))
              .fold<num>(0, (sum, e) => sum + (e.calories ?? 0));
          return _SmallCard(
            title: '运动消耗',
            icon: Icons.local_fire_department,
            color: AppColors.chartKcal,
            value: '$total',
            unit: 'kcal',
          );
        },
        onRetry: () => ref.invalidate(exercisesProvider),
      );
    } else {
      final dietAsync = ref.watch(dietProvider);
      return AsyncValueWidget(
        value: dietAsync,
        data: (list) {
          // 简化：显示总记录数（diet_record 没 kcal 字段，需要 food 关联；先用 count 占位）
          final count = list.length;
          return _SmallCard(
            title: '饮食记录',
            icon: Icons.restaurant,
            color: AppColors.info,
            value: '$count',
            unit: '条',
          );
        },
        onRetry: () => ref.invalidate(dietProvider),
      );
    }
  }
}

// ===== 今日情绪 =====

class _MoodCard extends ConsumerWidget {
  const _MoodCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodAsync = ref.watch(moodProvider);
    return AsyncValueWidget(
      value: moodAsync,
      data: (list) {
        if (list.isEmpty) {
          return const _SmallCard(
            title: '今日情绪',
            icon: Icons.mood,
            color: AppColors.chartMood,
            value: '—',
            unit: '',
          );
        }
        final latest = list.first;
        final score = latest.score ?? 0;
        return _SmallCard(
          title: '今日情绪',
          icon: Icons.mood,
          color: AppColors.chartMood,
          value: '$score',
          unit: '/ 10',
        );
      },
      onRetry: () => ref.invalidate(moodProvider),
    );
  }
}

// ===== 最近一次心率 =====

class _HeartRateCard extends ConsumerWidget {
  const _HeartRateCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hrAsync = ref.watch(latestRecordProvider(HealthMetric.heartRate));
    return AsyncValueWidget(
      value: hrAsync,
      data: (record) {
        if (record == null) {
          return const _SmallCard(
            title: '最近心率',
            icon: Icons.favorite,
            color: AppColors.danger,
            value: '—',
            unit: '',
          );
        }
        return _SmallCard(
          title: '最近心率',
          icon: Icons.favorite,
          color: AppColors.danger,
          value: '${record.value ?? 0}',
          unit: record.unit ?? '',
        );
      },
      onRetry: () =>
          ref.invalidate(latestRecordProvider(HealthMetric.heartRate)),
    );
  }
}

// ===== 通用卡片 =====

class _BigCard extends StatelessWidget {
  const _BigCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.child,
  });
  final String title;
  final IconData icon;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.space16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: AppDimens.space8),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: AppDimens.space16),
            child,
          ],
        ),
      ),
    );
  }
}

class _SmallCard extends StatelessWidget {
  const _SmallCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.value,
    required this.unit,
  });
  final String title;
  final IconData icon;
  final Color color;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.space12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.space8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: color),
                ),
                if (unit.isNotEmpty) ...[
                  const SizedBox(width: 4),
                  Text(
                    unit,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyData extends StatelessWidget {
  const _EmptyData(this.message);
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.space16),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}