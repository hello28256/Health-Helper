// TrendPage —— 趋势图（步数 / 情绪 7 天数据）
//
// 设计要点：
// 1. **fl_chart LineChart**：折线 + 圆点
// 2. **数据来源**：stepsProvider(近 7 天) / moodTrendProvider
// 3. **空数据 EmptyView**：没有记录时显示引导文案
// 4. **AsyncValueWidget 统一三态**

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_helper/providers/mood_provider.dart';
import 'package:health_helper/providers/steps_provider.dart';
import 'package:health_helper/theme/colors.dart';
import 'package:health_helper/theme/dimens.dart';
import 'package:health_helper/widgets/common/common.dart';

class TrendPage extends ConsumerWidget {
  const TrendPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: AppScaffold(
        title: '趋势',
        appBar: AppBar(
          title: const Text('趋势'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_walk), text: '步数'),
              Tab(icon: Icon(Icons.mood), text: '情绪'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _StepsTrend(),
            _MoodTrend(),
          ],
        ),
      ),
    );
  }
}

// ===== 步数趋势 =====

class _StepsTrend extends ConsumerWidget {
  const _StepsTrend();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stepsAsync = ref.watch(stepsProvider);
    return AsyncValueWidget(
      value: stepsAsync,
      data: (records) {
        if (records.isEmpty) {
          return const EmptyView(
            message: '暂无步数记录\n走两步试试？',
            icon: Icons.directions_walk,
          );
        }
        // 取最近 7 天
        final sorted = [...records]
          ..sort((a, b) => (a.date ?? '').compareTo(b.date ?? ''));
        final last7 = sorted.length > 7 ? sorted.sublist(sorted.length - 7) : sorted;
        final spots = <FlSpot>[];
        for (var i = 0; i < last7.length; i++) {
          spots.add(FlSpot(i.toDouble(), (last7[i].steps ?? 0).toDouble()));
        }
        return Padding(
          padding: const EdgeInsets.all(AppDimens.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '最近 7 天步数',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppDimens.space16),
              SizedBox(
                height: 240,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (v, _) => Text(
                            v.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, _) {
                            final i = v.toInt();
                            if (i < 0 || i >= last7.length) {
                              return const SizedBox();
                            }
                            final date = last7[i].date ?? '';
                            return Text(
                              date.length >= 5 ? date.substring(5) : date,
                              style: const TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).dividerColor,
                        ),
                        left: BorderSide(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: AppColors.chartSteps,
                        barWidth: 3,
                        dotData: const FlDotData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      onRetry: () => ref.invalidate(stepsProvider),
    );
  }
}

// ===== 情绪趋势 =====
//
// MoodTrendPoint 模型字段：date(String YYYY-MM-DD) / recordCount(int) / dominantMood(String)
// 这里以 recordCount（每天记录条数）为 Y 轴；底部用 dominantMood 显示主情绪标签

class _MoodTrend extends ConsumerWidget {
  const _MoodTrend();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendAsync = ref.watch(moodTrendProvider);
    return AsyncValueWidget(
      value: trendAsync,
      data: (points) {
        if (points.isEmpty) {
          return const EmptyView(
            message: '暂无情绪记录\n今天心情如何？',
            icon: Icons.mood,
          );
        }
        // 取最近 7 天
        final sorted = [...points]
          ..sort((a, b) => (a.date ?? '').compareTo(b.date ?? ''));
        final last7 = sorted.length > 7 ? sorted.sublist(sorted.length - 7) : sorted;
        final spots = <FlSpot>[];
        for (var i = 0; i < last7.length; i++) {
          spots.add(FlSpot(
            i.toDouble(),
            (last7[i].recordCount ?? 0).toDouble(),
          ));
        }
        return Padding(
          padding: const EdgeInsets.all(AppDimens.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '最近 7 天情绪记录',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppDimens.space16),
              SizedBox(
                height: 240,
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    gridData: const FlGridData(show: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          getTitlesWidget: (v, _) => Text(
                            v.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, _) {
                            final i = v.toInt();
                            if (i < 0 || i >= last7.length) {
                              return const SizedBox();
                            }
                            final date = last7[i].date ?? '';
                            return Text(
                              date.length >= 5 ? date.substring(5) : date,
                              style: const TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).dividerColor,
                        ),
                        left: BorderSide(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: AppColors.chartMood,
                        barWidth: 3,
                        dotData: const FlDotData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.space12),
              // 主情绪标签列表
              Wrap(
                spacing: AppDimens.space8,
                runSpacing: AppDimens.space4,
                children: last7
                    .map(
                      (p) => Chip(
                        label: Text(
                          '${p.date ?? '-'} · ${p.dominantMood ?? '-'}',
                          style: const TextStyle(fontSize: 11),
                        ),
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        );
      },
      onRetry: () => ref.invalidate(moodTrendProvider),
    );
  }
}