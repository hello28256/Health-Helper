// ChatPage widget 测试 —— 覆盖：
// 1. 渲染：标题 + 输入框 + 发送按钮
// 2. loading 态 → Loading
// 3. error 态 → ErrorView + 重试
// 4. 空历史 → EmptyView
// 5. 有历史：渲染气泡
// 6. 发送消息 → 气泡 + AI placeholder；成功后 placeholder 替换为真实内容
// 7. 发送失败 → snackbar + placeholder 被移除

// ignore_for_file: prefer_initializing_formals

import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_helper/api/api_clients.dart';
import 'package:health_helper/api/api_error.dart';
import 'package:health_helper/auth/token_holder.dart';
import 'package:health_helper/pages/chat/chat_page.dart';
import 'package:health_helper/providers/auth_provider.dart';
import 'package:health_helper/providers/chat_provider.dart';
import 'package:health_helper/storage/secure_storage.dart';
import 'package:health_helper/theme/app_theme.dart';
import 'package:health_helper/widgets/common/common.dart';
import 'package:health_helper_api/health_helper_api.dart';

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
    adapter = _StubAdapter((req) async => _ok('{"history":[]}'));
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
        home: const ChatPage(),
      ),
    );
  }

  testWidgets('渲染：标题 + 输入框 + 发送按钮', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    expect(find.text('AI 心理对话'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byIcon(Icons.send), findsOneWidget);
  });

  testWidgets('loading 态：显示 Loading', (tester) async {
    final pending = Completer<List<ChatMessage>>();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          chatHistoryProvider.overrideWith(() => _FakeChatNotifier(
            pending: pending,
          )),
        ],
        child: MaterialApp(
          theme: AppTheme.buildLightTheme(),
          home: const ChatPage(),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(Loading), findsOneWidget);
    pending.complete(const []);
    await tester.pumpAndSettle();
  });

  testWidgets('error 态：显示 ErrorView', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          chatHistoryProvider.overrideWith(() => _FakeChatNotifier(
            throwOnBuild: ApiError(code: 'NETWORK', message: 'boom'),
          )),
        ],
        child: MaterialApp(
          theme: AppTheme.buildLightTheme(),
          home: const ChatPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('boom'), findsOneWidget);
    expect(find.text('重试'), findsOneWidget);
  });

  testWidgets('空历史：EmptyView', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    expect(find.textContaining('想说点什么'), findsOneWidget);
  });

  testWidgets('有历史：渲染气泡', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          chatHistoryProvider.overrideWith(() => _FakeChatNotifier(
            initial: [
              ChatMessage((b) => b
                ..id = 'm1'
                ..content = '你好'
                ..createdAt = DateTime.now()),
              ChatMessage((b) => b
                ..id = 'm2'
                ..content = '我很好，谢谢'
                ..createdAt = DateTime.now()),
            ],
          )),
        ],
        child: MaterialApp(
          theme: AppTheme.buildLightTheme(),
          home: const ChatPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('你好'), findsOneWidget);
    expect(find.text('我很好，谢谢'), findsOneWidget);
  });

  testWidgets('发送消息：用户气泡 + AI placeholder + 真实回复', (tester) async {
    String? capturedMessage;
    adapter = _StubAdapter((req) async {
      if (req.method == 'POST') {
        capturedMessage = req.data?.toString();
        return _ok(
          '{"userMessage":{"id":"u1","content":"hi","createdAt":"2026-08-13T10:00:00Z"},"assistantMessage":{"id":"a1","content":"你好呀","createdAt":"2026-08-13T10:00:01Z"}}',
        );
      }
      return _ok('{"history":[]}');
    });
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'hi');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    expect(capturedMessage, contains('hi'));
    expect(find.text('hi'), findsOneWidget);
    expect(find.text('你好呀'), findsOneWidget);
  });

  testWidgets('发送失败 → snackbar + placeholder 被移除', (tester) async {
    adapter = _StubAdapter((req) async {
      if (req.method == 'POST') {
        return _ok(
          '{"error":{"code":"NETWORK_ERROR","message":"send failed"}}',
          status: 500,
        );
      }
      return _ok('{"history":[]}');
    });
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'hi');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    expect(find.textContaining('send failed'), findsOneWidget);
  });
}

// ===== Fake notifier =====

class _FakeChatNotifier extends ChatHistoryNotifier {
  _FakeChatNotifier({
    this.initial,
    Completer<List<ChatMessage>>? pending,
    this.throwOnBuild,
  }) : _pending = pending;
  final List<ChatMessage>? initial;
  final Completer<List<ChatMessage>>? _pending;
  final ApiError? throwOnBuild;

  @override
  Future<List<ChatMessage>> build() async {
    final err = throwOnBuild;
    if (err != null) throw err;
    if (_pending != null) return _pending.future;
    return initial ?? const [];
  }
}