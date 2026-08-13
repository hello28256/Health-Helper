// 通用 widget 测试 —— 覆盖：
// 1. AppScaffold：标题/动作渲染
// 2. Loading：默认 + 自定义 message
// 3. ErrorView：message + 可选重试按钮
// 4. EmptyView：默认 icon + 自定义 icon
// 5. AsyncValueWidget：loading/error/data 三态 + skipLoadingOnRefresh + skipError

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_helper/api/api_error.dart';
import 'package:health_helper/widgets/common/common.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: child);

  group('AppScaffold', () {
    testWidgets('显示 title + body', (tester) async {
      await tester.pumpWidget(wrap(
        const AppScaffold(title: '测试', body: Text('body-content')),
      ));
      expect(find.text('测试'), findsOneWidget);
      expect(find.text('body-content'), findsOneWidget);
    });

    testWidgets('渲染 actions 列表', (tester) async {
      await tester.pumpWidget(wrap(
        const AppScaffold(
          title: '页面',
          body: SizedBox(),
          actions: [
            IconButton(icon: Icon(Icons.add), onPressed: null),
          ],
        ),
      ));
      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });

  group('Loading', () {
    testWidgets('默认显示 CircularProgressIndicator', (tester) async {
      await tester.pumpWidget(wrap(const Loading()));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('自定义 message 显示', (tester) async {
      await tester.pumpWidget(wrap(const Loading(message: '加载中...')));
      expect(find.text('加载中...'), findsOneWidget);
    });
  });

  group('ErrorView', () {
    testWidgets('显示 message', (tester) async {
      await tester.pumpWidget(wrap(const ErrorView(message: '网络错误')));
      expect(find.text('网络错误'), findsOneWidget);
    });

    testWidgets('提供 onRetry 时显示重试按钮', (tester) async {
      var retry = 0;
      await tester.pumpWidget(wrap(
        ErrorView(message: 'err', onRetry: () => retry++),
      ));
      final btn = find.text('重试');
      expect(btn, findsOneWidget);
      await tester.tap(btn);
      expect(retry, 1);
    });

    testWidgets('无 onRetry 时不显示重试按钮', (tester) async {
      await tester.pumpWidget(wrap(const ErrorView(message: 'err')));
      expect(find.text('重试'), findsNothing);
    });
  });

  group('EmptyView', () {
    testWidgets('显示默认 icon + message', (tester) async {
      await tester.pumpWidget(wrap(const EmptyView(message: '暂无数据')));
      expect(find.text('暂无数据'), findsOneWidget);
      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    });

    testWidgets('支持自定义 icon', (tester) async {
      await tester.pumpWidget(wrap(
        const EmptyView(message: 'no chat', icon: Icons.chat_bubble_outline),
      ));
      expect(find.byIcon(Icons.chat_bubble_outline), findsOneWidget);
    });
  });

  group('AsyncValueWidget', () {
    testWidgets('loading 态 → Loading', (tester) async {
      await tester.pumpWidget(wrap(
        AsyncValueWidget<int>(
          value: const AsyncValue.loading(),
          data: (_) => const Text('data-shown'),
        ),
      ));
      expect(find.byType(Loading), findsOneWidget);
      expect(find.text('data-shown'), findsNothing);
    });

    testWidgets('data 态 → builder(data)', (tester) async {
      await tester.pumpWidget(wrap(
        AsyncValueWidget<int>(
          value: const AsyncValue.data(42),
          data: (v) => Text('got-$v'),
        ),
      ));
      expect(find.text('got-42'), findsOneWidget);
    });

    testWidgets('error 态 → ErrorView + 提取 ApiError.message', (tester) async {
      await tester.pumpWidget(wrap(
        AsyncValueWidget<int>(
          value: AsyncValue.error(
            ApiError(code: 'UNAUTHORIZED', message: '会话过期'),
            StackTrace.empty,
          ),
          data: (_) => const Text('data-shown'),
        ),
      ));
      expect(find.text('会话过期'), findsOneWidget);
      expect(find.byType(ErrorView), findsOneWidget);
    });

    testWidgets('error 态有 onRetry → 渲染重试按钮', (tester) async {
      var retried = 0;
      await tester.pumpWidget(wrap(
        AsyncValueWidget<int>(
          value: const AsyncValue.error('boom', StackTrace.empty),
          data: (_) => const Text('x'),
          onRetry: () => retried++,
        ),
      ));
      await tester.tap(find.text('重试'));
      expect(retried, 1);
    });

    testWidgets('skipLoadingOnRefresh + 已有数据 → 不闪 loading',
        (tester) async {
      final v = const AsyncData<int>(99).copyWithPrevious(
            const AsyncLoading<int>(),
          );
      await tester.pumpWidget(wrap(
        AsyncValueWidget<int>(
          value: v,
          data: (d) => Text('kept-$d'),
        ),
      ));
      expect(find.text('kept-99'), findsOneWidget);
      expect(find.byType(Loading), findsNothing);
    });

    testWidgets('skipError + 已有数据 → 静默刷新', (tester) async {
      final v = const AsyncData<int>(7).copyWithPrevious(
            const AsyncError<int>('transient', StackTrace.empty),
          );
      await tester.pumpWidget(wrap(
        AsyncValueWidget<int>(
          value: v,
          data: (d) => Text('kept-$d'),
          skipError: true,
        ),
      ));
      expect(find.text('kept-7'), findsOneWidget);
      expect(find.byType(ErrorView), findsNothing);
    });
  });
}