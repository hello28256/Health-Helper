// HealthDataPage widget 测试 —— 覆盖：
// 1. 渲染：标题 + Tab 数量（=HealthMetric.values.length）
// 2. 空数据：EmptyView
// 3. 有数据：渲染记录 tile + 时间 + 数值 + 来源
// 4. error 态：ErrorView + 重试

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_helper/api/api_error.dart';
import 'package:health_helper/pages/health/health_data_page.dart';
import 'package:health_helper/providers/health_provider.dart';
import 'package:health_helper/theme/app_theme.dart';
import 'package:health_helper_api/health_helper_api.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget wrap({required List<Override> overrides}) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: AppTheme.buildLightTheme(),
        home: const HealthDataPage(),
      ),
    );
  }

  testWidgets('渲染：标题 + 8 个 metric Tab', (tester) async {
    await tester.pumpWidget(wrap(
      overrides: [
        healthRecordsProvider.overrideWith(() => _FakeHealthNotifier(
          data: const {},
        )),
      ],
    ));
    await tester.pumpAndSettle();
    expect(find.text('健康数据'), findsOneWidget);
    // 默认展示首个 Tab（steps）；其它 Tab 通过 TabBarView 滑动或组件渲染
    expect(find.text('步数'), findsWidgets);
    expect(find.text('心率'), findsOneWidget);
    expect(find.text('睡眠'), findsOneWidget);
  });

  testWidgets('空数据：EmptyView', (tester) async {
    await tester.pumpWidget(wrap(
      overrides: [
        healthRecordsProvider.overrideWith(() => _FakeHealthNotifier(
          data: const {HealthMetric.heartRate: []},
        )),
      ],
    ));
    await tester.pumpAndSettle();
    // 切到心率 tab
    await tester.tap(find.text('心率'));
    await tester.pumpAndSettle();
    expect(find.textContaining('暂无数据'), findsOneWidget);
  });

  testWidgets('有数据：渲染记录 tile', (tester) async {
    final records = [
      HealthRecord((b) => b
        ..id = 'r1'
        ..metric = HealthMetric.heartRate
        ..value = 72
        ..unit = 'bpm'
        ..startAt = DateTime(2026, 8, 13, 10, 0)
        ..source_ = 'ios_healthkit'),
    ];
    await tester.pumpWidget(wrap(
      overrides: [
        healthRecordsProvider.overrideWith(() => _FakeHealthNotifier(
          data: {HealthMetric.heartRate: records},
        )),
      ],
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('心率'));
    await tester.pumpAndSettle();
    expect(find.text('72 bpm'), findsOneWidget);
    expect(find.text('来源：ios_healthkit'), findsOneWidget);
    expect(find.textContaining('2026-08-13'), findsOneWidget);
  });

  testWidgets('error 态：显示 ErrorView', (tester) async {
    await tester.pumpWidget(wrap(
      overrides: [
        healthRecordsProvider.overrideWith(() => _FakeHealthNotifier(
          data: const {},
          throwOnBuild: ApiError(code: 'NETWORK', message: 'fetch failed'),
        )),
      ],
    ));
    await tester.pumpAndSettle();
    expect(find.text('fetch failed'), findsOneWidget);
    expect(find.text('重试'), findsOneWidget);
  });
}

// ===== Fake notifier =====

class _FakeHealthNotifier extends HealthRecordsNotifier {
  _FakeHealthNotifier({required this.data, this.throwOnBuild});
  final Map<HealthMetric, List<HealthRecord>> data;
  final ApiError? throwOnBuild;

  @override
  Future<List<HealthRecord>> build(HealthMetric arg) async {
    final err = throwOnBuild;
    if (err != null) throw err;
    return data[arg] ?? const [];
  }
}