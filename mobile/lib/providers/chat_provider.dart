// chat_provider —— AI 心理对话
//
// 设计要点：
// 1. **后端 GET /api/chat/history 返回 {history: ChatMessage[]}**——所以这里存的是扁平消息列表
// 2. **sendMessage 是非流式**：调 POST /api/chat/messages，拿到 ChatSendResult（userMessage + assistantMessage）
// 3. **乐观更新**：用户消息先入列表，AI 回复再拼接

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_helper/api/api_error.dart';
import 'package:health_helper/providers/auth_provider.dart';

import 'package:health_helper_api/health_helper_api.dart';

/// 历史消息列表（按时间倒序）
final chatHistoryProvider =
    AsyncNotifierProvider<ChatHistoryNotifier, List<ChatMessage>>(
  ChatHistoryNotifier.new,
);

class ChatHistoryNotifier extends AsyncNotifier<List<ChatMessage>> {
  @override
  Future<List<ChatMessage>> build() async {
    final clients = ref.read(apiClientsProvider);
    try {
      final resp = await clients.dio.get<dynamic>('/api/chat/history');
      final raw = resp.data;
      if (raw is! Map) return const [];
      // 后端返回 {history: ChatMessage[]}
      final historyRaw = raw['history'];
      if (historyRaw is! List) return const [];
      return historyRaw
          .map((e) => standardSerializers.deserializeWith(
                ChatMessage.serializer,
                e as Map,
              ) as ChatMessage)
          .toList();
    } on DioException catch (e) {
      final apiErr = e.error is ApiError ? e.error as ApiError : null;
      throw apiErr ??
          ApiError(code: 'NETWORK_ERROR', message: e.message ?? 'fetch failed');
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }

  /// 客户端追加一条消息（乐观更新用）
  void appendLocal(ChatMessage msg) {
    final current = state.value ?? const <ChatMessage>[];
    state = AsyncData([...current, msg]);
  }

  /// 用 id 替换某条消息（content 占位 → 真实回复）
  void replaceById(String id, ChatMessage Function(ChatMessage) update) {
    final current = state.value ?? const <ChatMessage>[];
    state = AsyncData([
      for (final m in current)
        if (m.id == id) update(m) else m,
    ]);
  }

  /// 按 id 删除
  void removeById(String id) {
    final current = state.value ?? const <ChatMessage>[];
    state = AsyncData([for (final m in current) if (m.id != id) m]);
  }
}

/// 发送消息（非流式版），返回 AI 回复文本
final sendMessageProvider = Provider<Future<String> Function(String)>((ref) {
  return (String userMessage) async {
    final clients = ref.read(apiClientsProvider);
    try {
      final resp = await clients.dio.post<dynamic>(
        '/api/chat/messages',
        data: {'message': userMessage},
      );
      final raw = resp.data;
      if (raw is! Map) return '';
      final result = standardSerializers.deserializeWith(
        ChatSendResult.serializer,
        raw,
      ) as ChatSendResult;
      return result.assistantMessage?.content ?? '';
    } on DioException catch (e) {
      final apiErr = e.error is ApiError ? e.error as ApiError : null;
      throw apiErr ??
          ApiError(code: 'NETWORK_ERROR', message: e.message ?? 'send failed');
    }
  };
});