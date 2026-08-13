// TrendPage widget 测试 —— 覆盖：
// 1. loading 态：显示 Loading
// 2. error 态：显示 ErrorView + retry
// 3. 步数有数据：LineChart 渲染 + "最近 7 天步数" 标题
// 4. 步数空数据：EmptyView
// 5. 情绪有数据：LineChart 渲染 + Chip 列表（dominantMood）
// 6. 切换 tab 不崩

import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_helper/api/api_error.dart';
import 'package:health_helper/pages/trend/trend_page.dart';
import 'package:health_helper/providers/mood_provider.dart';
import 'package:health_helper/providers/steps_provider.dart';
import 'package:health_helper/theme/app_theme.dart';
import 'package:health_helper/widgets/common/common.dart';
import 'package:health_helper_api/health_helper_api.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget wrap({
    required List<Override> overrides,
  }) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: AppTheme.buildLightTheme(),
        home: const TrendPage(),
      ),
    );
  }

  /// 注入成功的 steps（3 天数据）+ 空 mood
  List<Override> okOverrides() {
    final steps = [
      DailyStep((b) => b
        ..date = '2026-08-10'
        ..steps = 5000),
      DailyStep((b) => b
        ..date = '2026-08-11'
        ..steps = 8000),
      DailyStep((b) => b
        ..date = '2026-08-12'
        ..steps = 12000),
    ];
    return [
      stepsProvider.overrideWith(() => _FakeStepsNotifier(steps)),
      moodTrendProvider.overrideWith((ref) async => const <MoodTrendPoint>[]),
    ];
  }

  /// 注入错误态
  List<Override> errorOverrides() {
    return [
      stepsProvider.overrideWith(() => _FakeStepsNotifier(
        const [],
        throwOnBuild: ApiError(code: 'NETWORK', message: 'boom'),
      )),
      moodTrendProvider.overrideWith(
        (ref) async => throw ApiError(code: 'NETWORK', message: 'boom'),
      ),
    ];
  }

  testWidgets('loading 态：显示 Loading', (tester) async {
    await tester.pumpWidget(wrap(
      overrides: [
        stepsProvider.overrideWith(_LoadingStepsNotifier.new),
        moodTrendProvider.overrideWith(
          (ref) => _neverMoodCompleter.future,
        ),
      ],
    ));
    await tester.pump();
    expect(find.byType(Loading), findsOneWidget);
  });

  testWidgets('error 态：显示 ErrorView', (tester) async {
    await tester.pumpWidget(wrap(overrides: errorOverrides()));
    await tester.pumpAndSettle();
    expect(find.text('boom'), findsOneWidget);
    expect(find.text('重试'), findsOneWidget);
  });

  testWidgets('步数有数据：图表 + 标题', (tester) async {
    await tester.pumpWidget(wrap(overrides: okOverrides()));
    await tester.pumpAndSettle();
    expect(find.text('最近 7 天步数'), findsOneWidget);
    expect(find.byType(LineChart), findsOneWidget);
  });

  testWidgets('步数空数据：EmptyView', (tester) async {
    await tester.pumpWidget(wrap(
      overrides: [
        stepsProvider.overrideWith(() => _FakeStepsNotifier(const [])),
        moodTrendProvider.overrideWith((ref) async => const <MoodTrendPoint>[]),
      ],
    ));
    await tester.pumpAndSettle();
    expect(find.textContaining('暂无步数记录'), findsOneWidget);
  });

  testWidgets('情绪有数据：图表 + Chip 标签', (tester) async {
    final points = [
      MoodTrendPoint((b) => b
        ..date = '2026-08-10'
        ..recordCount = 1
        ..dominantMood = 'happy'),
      MoodTrendPoint((b) => b
        ..date = '2026-08-11'
        ..recordCount = 2
        ..dominantMood = 'sad'),
    ];
    await tester.pumpWidget(wrap(
      overrides: [
        stepsProvider.overrideWith(() => _FakeStepsNotifier(const [])),
        moodTrendProvider.overrideWith((ref) async => points),
      ],
    ));
    // 切换到情绪 tab
    await tester.pumpAndSettle();
    await tester.tap(find.text('情绪'));
    await tester.pumpAndSettle();
    expect(find.text('最近 7 天情绪记录'), findsOneWidget);
    expect(find.byType(LineChart), findsOneWidget);
    expect(find.textContaining('happy'), findsOneWidget);
    expect(find.textContaining('sad'), findsOneWidget);
  });

  testWidgets('情绪空数据：EmptyView', (tester) async {
    await tester.pumpWidget(wrap(
      overrides: [
        stepsProvider.overrideWith(() => _FakeStepsNotifier(const [])),
        moodTrendProvider.overrideWith((ref) async => const <MoodTrendPoint>[]),
      ],
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('情绪'));
    await tester.pumpAndSettle();
    expect(find.textContaining('暂无情绪记录'), findsOneWidget);
  });
}

// ===== 测试用的 Fake notifier =====

class _FakeStepsNotifier extends StepsNotifier {
  _FakeStepsNotifier(this._data, {this.throwOnBuild});
  final List<DailyStep> _data;
  final ApiError? throwOnBuild;

  @override
  Future<List<DailyStep>> build() async {
    if (throwOnBuild != null) throw throwOnBuild!;
    return _data;
  }
}

class _LoadingStepsNotifier extends StepsNotifier {
  @override
  Future<List<DailyStep>> build() {
    // 永不完成，保持 loading 态直到 widget tree 销毁
    return _neverCompleter.future;
  }
}

/// 永不完成的 Completer，避免触发 pending-timer 断言
final _neverCompleter = Completer<List<DailyStep>>();
final _neverMoodCompleter = Completer<List<MoodTrendPoint>>();