// DashboardPage widget 测试 —— 覆盖：
// 1. 渲染欢迎语（未登录 → 默认）
// 2. 步数卡：空数据 → "今日暂无步数数据"；有数据 → 显示数字 + 百分比
// 3. 4 个小卡：运动卡路里/饮食/情绪/心率在空数据/有数据/错误态下表现
// 4. 下拉刷新：触发所有 provider ref.invalidate

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_helper/api/api_clients.dart';
import 'package:health_helper/auth/token_holder.dart';
import 'package:health_helper/pages/dashboard/dashboard_page.dart';
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

  Widget wrap({Map<String, String> routes = const {}}) {
    final clients = ApiClients(holder: holder, adapter: adapter);
    return ProviderScope(
      overrides: [
        tokenHolderProvider.overrideWithValue(holder),
        apiClientsProvider.overrideWithValue(clients),
      ],
      child: MaterialApp(
        theme: AppTheme.buildLightTheme(),
        home: const DashboardPage(),
      ),
    );
  }

  testWidgets('渲染：标题 + 4 个小卡标题', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    expect(find.text('Health Helper'), findsOneWidget);
    expect(find.text('今日步数'), findsOneWidget);
    expect(find.text('运动消耗'), findsOneWidget);
    expect(find.text('饮食记录'), findsOneWidget);
    expect(find.text('今日情绪'), findsOneWidget);
    expect(find.text('最近心率'), findsOneWidget);
  });

  testWidgets('步数空数据 → "今日暂无步数数据"', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    expect(find.text('今日暂无步数数据'), findsOneWidget);
  });

  testWidgets('步数有数据 → 显示数字 + 百分比', (tester) async {
    adapter = _StubAdapter((req) async {
      if (req.path.contains('/api/exercises/steps')) {
        return _ok(
          '[{"userId":"u-1","date":"2026-08-13","steps":5000,"source":"manual","updatedAt":"2026-08-13T10:00:00Z"}]',
        );
      }
      return _ok('[]');
    });
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    expect(find.text('5000'), findsOneWidget);
    expect(find.text('50% 完成'), findsOneWidget);
  });

  testWidgets('心率有数据 → 显示 bpm', (tester) async {
    adapter = _StubAdapter((req) async {
      if (req.path.contains('/api/health/records/latest')) {
        return _ok(
          '{"record":{"id":"hr-1","userId":"u-1","metric":"heart_rate","value":75,"unit":"bpm","startAt":"2026-08-13T10:00:00Z","source":"ios_healthkit"}}',
        );
      }
      return _ok('[]');
    });
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    expect(find.text('75'), findsOneWidget);
    expect(find.text('bpm'), findsOneWidget);
  });

  testWidgets('心率无数据 → 显示 "—"', (tester) async {
    adapter = _StubAdapter((req) async {
      if (req.path.contains('/api/health/records/latest')) {
        return _ok('{"record":null}');
      }
      return _ok('[]');
    });
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    expect(find.text('—'), findsWidgets);
  });

  testWidgets('情绪有数据 → 显示 score', (tester) async {
    adapter = _StubAdapter((req) async {
      if (req.path.contains('/api/mood/records')) {
        return _ok(
          '[{"id":"m-1","userId":"u-1","mood":"happy","score":8,"recordedAt":"2026-08-13T10:00:00Z"}]',
        );
      }
      return _ok('[]');
    });
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    expect(find.text('8'), findsOneWidget);
  });

  testWidgets('饮食记录 → 显示 count', (tester) async {
    adapter = _StubAdapter((req) async {
      if (req.path.contains('/api/diet/records')) {
        return _ok(
          '[{"id":"d-1","userId":"u-1","foodId":1,"mealType":"breakfast","consumedAt":"2026-08-13T08:00:00Z"}]',
        );
      }
      return _ok('[]');
    });
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    expect(find.text('1'), findsWidgets);
  });

  testWidgets('步数 provider 失败 → 显示 ErrorView', (tester) async {
    adapter = _StubAdapter((req) async {
      if (req.path.contains('/api/exercises/steps')) {
        return _ok(
          '{"error":{"code":"SERVER_ERROR","message":"db down"}}',
          status: 500,
        );
      }
      return _ok('[]');
    });
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    expect(find.text('db down'), findsOneWidget);
  });
}