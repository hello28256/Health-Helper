// DietTab widget 测试 —— 覆盖：
// 1. 渲染：名称 + 卡路里 + 餐别下拉 + 提交
// 2. 默认选中 breakfast
// 3. 切换餐别到 lunch
// 4. 成功提交
// 5. 空名称 → 校验失败

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_helper/api/api_clients.dart';
import 'package:health_helper/auth/token_holder.dart';
import 'package:health_helper/pages/record/diet_tab.dart';
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
        home: const Scaffold(body: DietTab()),
      ),
    );
  }

  testWidgets('渲染：名称 + 卡路里 + 餐别 + 提交', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    expect(find.text('食物名称'), findsOneWidget);
    expect(find.text('热量（千卡）'), findsOneWidget);
    expect(find.text('餐别'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, '提交'), findsOneWidget);
  });

  testWidgets('默认餐别 = breakfast', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    expect(find.text('早餐'), findsOneWidget);
  });

  testWidgets('切换餐别到 lunch', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    await tester.tap(find.text('早餐'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('午餐').last);
    await tester.pumpAndSettle();
    expect(find.text('午餐'), findsOneWidget);
  });

  testWidgets('空名称 → "请输入食物名称"', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(1), '100');
    await tester.tap(find.widgetWithText(FilledButton, '提交'));
    await tester.pump();
    expect(find.text('请输入食物名称'), findsOneWidget);
  });

  testWidgets('成功提交 → snackbar + POST 触发', (tester) async {
    var posts = 0;
    String? capturedBody;
    adapter = _StubAdapter((req) async {
      if (req.method == 'POST') {
        posts++;
        capturedBody = req.data?.toString();
        return _ok(
          '{"id":"d-1","userId":"u-1","foodId":1,"mealType":"lunch","consumedAt":"2026-08-13T12:00:00Z"}',
        );
      }
      return _ok('[]');
    });
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), '鸡腿');
    await tester.enterText(find.byType(TextFormField).at(1), '400');
    await tester.tap(find.widgetWithText(FilledButton, '提交'));
    await tester.pumpAndSettle();

    expect(posts, 1);
    expect(capturedBody, contains('mealType'));
    expect(capturedBody, contains('breakfast'));
    expect(capturedBody, contains('鸡腿'));
    expect(find.text('已记录饮食'), findsOneWidget);
  });
}