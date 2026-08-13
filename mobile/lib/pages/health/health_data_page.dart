// HealthDataPage —— 健康数据查看 + HealthKit/Health Connect 权限引导
//
// 设计要点：
// 1. **顶部 Tab**：按 HealthMetric 切换，每个 tab 拉对应的 healthRecordsProvider(metric)
// 2. **记录列表**：显示每条 HealthRecord 的时间 + 数值 + 单位 + 来源
// 3. **权限引导卡片**：顶部 banner（未授权态），文案按平台分支（iOS HealthKit / Android Health Connect）
// 4. **空数据**：EmptyView + 引导文案
// 5. **HealthRecord.source_**（尾下划线）：built_value 生成避免与关键字冲突

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:health_helper/providers/health_provider.dart';
import 'package:health_helper/theme/colors.dart';
import 'package:health_helper/theme/dimens.dart';
import 'package:health_helper/widgets/common/common.dart';
import 'package:health_helper_api/health_helper_api.dart';
import 'package:intl/intl.dart';

class HealthDataPage extends ConsumerWidget {
  const HealthDataPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: HealthMetric.values.length,
      child: AppScaffold(
        title: '健康数据',
        appBar: AppBar(
          title: const Text('健康数据'),
          bottom: TabBar(
            isScrollable: true,
            tabs: HealthMetric.values
                .map((m) => Tab(text: _metricLabel(m)))
                .toList(),
          ),
        ),
        body: Column(
          children: [
            const _PermissionBanner(),
            Expanded(
              child: TabBarView(
                children: HealthMetric.values
                    .map((m) => _MetricRecords(metric: m))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _metricLabel(HealthMetric m) {
  switch (m) {
    case HealthMetric.steps:
      return '步数';
    case HealthMetric.heartRate:
      return '心率';
    case HealthMetric.sleep:
      return '睡眠';
    case HealthMetric.weight:
      return '体重';
    case HealthMetric.bloodPressure:
      return '血压';
    case HealthMetric.bloodGlucose:
      return '血糖';
    case HealthMetric.spo2:
      return '血氧';
    case HealthMetric.bodyTemperature:
      return '体温';
    default:
      return m.name;
  }
}

// ===== 权限引导 banner =====
//
// Phase F 真正接入 health 包前，先放静态文案
// 平台判断用 Theme.of(context).platform，但 web 不会触发

class _PermissionBanner extends StatelessWidget {
  const _PermissionBanner();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isIos = !kIsWeb && Theme.of(context).platform == TargetPlatform.iOS;
    final isAndroid =
        !kIsWeb && Theme.of(context).platform == TargetPlatform.android;

    String platformName;
    String description;
    if (isIos) {
      platformName = 'Apple Health';
      description = '授权后可自动同步步数、心率、睡眠等数据。';
    } else if (isAndroid) {
      platformName = 'Health Connect';
      description = '授权后可自动同步步数、心率、睡眠等数据。';
    } else {
      // Web / 测试环境：不显示 banner
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(AppDimens.space12),
      padding: const EdgeInsets.all(AppDimens.space12),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimens.radius12),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.health_and_safety_outlined, color: scheme.primary),
          const SizedBox(width: AppDimens.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '连接 $platformName',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: AppDimens.space4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimens.space8),
          FilledButton.tonal(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$platformName 授权即将上线')),
              );
            },
            child: const Text('去授权'),
          ),
        ],
      ),
    );
  }
}

// ===== 单个 metric 的记录列表 =====

class _MetricRecords extends ConsumerWidget {
  const _MetricRecords({required this.metric});
  final HealthMetric metric;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(healthRecordsProvider(metric));
    return AsyncValueWidget(
      value: records,
      data: (list) {
        if (list.isEmpty) {
          return const EmptyView(
            message: '暂无数据\n连接 HealthKit / Health Connect 后自动同步',
            icon: Icons.monitor_heart_outlined,
          );
        }
        // 按时间倒序
        final sorted = [...list]
          ..sort((a, b) =>
              (b.startAt ?? DateTime.fromMillisecondsSinceEpoch(0))
                  .compareTo(a.startAt ?? DateTime.fromMillisecondsSinceEpoch(0)));
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(healthRecordsProvider(metric));
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(AppDimens.space12),
            itemCount: sorted.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppDimens.space8),
            itemBuilder: (_, i) => _RecordTile(record: sorted[i]),
          ),
        );
      },
      onRetry: () => ref.invalidate(healthRecordsProvider(metric)),
    );
  }
}

// ===== 单条记录 =====

class _RecordTile extends StatelessWidget {
  const _RecordTile({required this.record});
  final HealthRecord record;

  String _formatTime(DateTime? t) {
    if (t == null) return '-';
    return DateFormat('yyyy-MM-dd HH:mm').format(t);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppDimens.space12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppDimens.radius12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${record.value ?? '-'} ${record.unit ?? ''}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppDimens.space4),
                Text(
                  _formatTime(record.startAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
                if (record.source_ != null) ...[
                  const SizedBox(height: AppDimens.space4),
                  Text(
                    '来源：${record.source_}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ],
            ),
          ),
          if (record.endAt != null)
            Text(
              '时长 ${record.endAt!.difference(record.startAt ?? record.endAt!).inMinutes} 分钟',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
        ],
      ),
    );
  }
}