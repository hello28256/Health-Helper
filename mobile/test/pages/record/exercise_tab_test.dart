// ExerciseTab widget 测试 —— 覆盖：
// 1. 渲染表单 + 提交按钮
// 2. 表单校验：空类型/空时长/非数字
// 3. 成功提交 → snackbar + 清空表单
// 4. 失败 → snackbar 显示 ApiError.message

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_helper/api/api_clients.dart';
import 'package:health_helper/auth/token_holder.dart';
import 'package:health_helper/pages/record/exercise_tab.dart';
import 'package:health_helper/providers/auth_provider.dart';
import 'package:health_helper/storage/secure_storage.dart';
import 'package:health_helper/theme/app_theme.dart';

class InMemorySecureStorage implements SecureStorage {
  final Map<String, String> _store = {};
  @override
  Future<String?> read({required String key}) async => _store[key];
  @override
  Future<void> write({required String key, required String value}) async => _store[key] = value;
  @override
  Future<void> delete({required String key}) async => _store.remove(key);
  @override
  Future<void> clear() async => _store.clear();
}

class _StubAdapter implements HttpClientAdapter {
  _StubAdapter(this.handler);
  Future<Response<dynamic>> Function(RequestOptions) handler;
  @override
  void close({bool force = false}) {}
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final resp = await handler(options);
    if (resp.statusCode != null && resp.statusCode! >= 400) {
      throw DioException(
        requestOptions: options,
        response: resp,
        type: DioExceptionType.badResponse,
      );
    }
    return ResponseBody.fromString(
      resp.data?.toString() ?? '',
      resp.statusCode ?? 200,
      headers: const {'content-type': ['application/json']},
    );
  }
}

Response<dynamic> _ok(String data, {int status = 200}) {
  return Response<dynamic>(
    requestOptions: RequestOptions(path: '/'),
    statusCode: status,
    data: data,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TokenHolder holder;
  late _StubAdapter adapter;

  setUp(() async {
    holder = TokenHolder(storage: InMemorySecureStorage());
    await holder.save(accessToken: 'a', refreshToken: 'r');
    adapter = _StubAdapter((req) async => _ok('[]'));
  });

  Widget wrap() {
    final clients = ApiClients(holder: holder, adapter: adapter);
    return ProviderScope(
      overrides: [
        tokenHolderProvider.overrideWithValue(holder),
        apiClientsProvider.overrideWithValue(clients),
      ],
      child: MaterialApp(
        theme: AppTheme.buildLightTheme(),
        home: const Scaffold(body: ExerciseTab()),
      ),
    );
  }

  testWidgets('渲染：3 个字段 + 提交按钮', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    expect(find.text('类型（跑步 / 游泳 / 骑车 …）'), findsOneWidget);
    expect(find.text('时长（分钟）'), findsOneWidget);
    expect(find.text('消耗（千卡）'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, '提交'), findsOneWidget);
  });

  testWidgets('空提交 → 显示"请输入运动类型"', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, '提交'));
    await tester.pump();
    expect(find.text('请输入运动类型'), findsOneWidget);
  });

  testWidgets('时长非数字 → "请输入整数"', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), '跑步');
    await tester.enterText(find.byType(TextFormField).at(1), 'abc');
    await tester.enterText(find.byType(TextFormField).at(2), '100');
    await tester.tap(find.widgetWithText(FilledButton, '提交'));
    await tester.pump();
    expect(find.text('请输入整数'), findsOneWidget);
  });

  testWidgets('时长 ≤ 0 → "时长必须大于 0"', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), '跑步');
    await tester.enterText(find.byType(TextFormField).at(1), '0');
    await tester.enterText(find.byType(TextFormField).at(2), '100');
    await tester.tap(find.widgetWithText(FilledButton, '提交'));
    await tester.pump();
    expect(find.text('时长必须大于 0'), findsOneWidget);
  });

  testWidgets('成功提交 → snackbar + 清空表单', (tester) async {
    var posts = 0;
    adapter = _StubAdapter((req) async {
      if (req.method == 'POST') {
        posts++;
        return _ok(
          '{"id":"ex-1","userId":"u-1","typeId":"running","startedAt":"2026-08-13T10:00:00Z","durationSec":1800,"calories":250}',
        );
      }
      return _ok('[]');
    });
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), '跑步');
    await tester.enterText(find.byType(TextFormField).at(1), '30');
    await tester.enterText(find.byType(TextFormField).at(2), '250');
    await tester.tap(find.widgetWithText(FilledButton, '提交'));
    await tester.pumpAndSettle();

    expect(posts, 1);
    expect(find.text('已记录运动'), findsOneWidget);
    // 清空：第一个输入框的 text 应为空
    final widget = tester.widget<TextFormField>(find.byType(TextFormField).at(0));
    expect(widget.controller!.text, isEmpty);
  });

  testWidgets('提交失败 → snackbar 显示 ApiError.message', (tester) async {
    adapter = _StubAdapter((req) async {
      if (req.method == 'POST') {
        return _ok(
          '{"error":{"code":"VALIDATION_ERROR","message":"type 非法"}}',
          status: 400,
        );
      }
      return _ok('[]');
    });
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), '跑步');
    await tester.enterText(find.byType(TextFormField).at(1), '30');
    await tester.enterText(find.byType(TextFormField).at(2), '250');
    await tester.tap(find.widgetWithText(FilledButton, '提交'));
    await tester.pumpAndSettle();
    expect(find.textContaining('type 非法'), findsOneWidget);
  });
}