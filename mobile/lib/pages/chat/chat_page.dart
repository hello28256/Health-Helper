// ChatPage —— AI 心理对话
//
// 设计要点：
// 1. **历史优先 watch**：拉历史 → 用户消息立即追加（乐观） → AI 回复替换 placeholder
// 2. **气泡布局**：用户右对齐 + primaryContainer，AI 左对齐 + surfaceContainerHigh
// 3. **发送中状态**：disabled 输入框 + 按钮转圈；显示一个 "AI 正在思考…" placeholder
// 4. **自动滚到底**：消息更新后用 scrollController 滚到末尾
// 5. **错误处理**：snackbar + 清掉 placeholder；不丢历史
// 6. **ChatMessage 没有 role 字段** —— 用客户端临时 id 区分（`__pending_user__` / `__pending_ai__`）

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_helper/api/api_error.dart';
import 'package:health_helper/providers/chat_provider.dart';
import 'package:health_helper/theme/dimens.dart';
import 'package:health_helper/widgets/common/common.dart';
import 'package:health_helper_api/health_helper_api.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _sending = false;

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    final userId = '__pending_user__';
    final aiId = '__pending_ai__';
    final now = DateTime.now();
    final notifier = ref.read(chatHistoryProvider.notifier);
    notifier.appendLocal(ChatMessage((b) => b
      ..id = userId
      ..content = text
      ..createdAt = now));
    notifier.appendLocal(ChatMessage((b) => b
      ..id = aiId
      ..content = ''
      ..createdAt = now));
    _scrollToBottom();
    _inputCtrl.clear();
    try {
      final aiContent = await ref.read(sendMessageProvider)(text);
      notifier.replaceById(aiId, (m) => m.rebuild((b) => b..content = aiContent));
      _scrollToBottom();
    } on ApiError catch (e) {
      notifier.removeById(aiId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('发送失败：${e.message}')),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollCtrl.hasClients) return;
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(chatHistoryProvider);
    return AppScaffold(
      title: 'AI 心理对话',
      body: Column(
        children: [
          Expanded(
            child: AsyncValueWidget(
              value: history,
              data: (messages) {
                if (messages.isEmpty) {
                  return const EmptyView(
                    message: '想说点什么？\n我在这里倾听。',
                    icon: Icons.chat_bubble_outline,
                  );
                }
                return ListView.builder(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.all(AppDimens.space12),
                  itemCount: messages.length,
                  itemBuilder: (_, i) => _Bubble(message: messages[i]),
                );
              },
              onRetry: () => ref.invalidate(chatHistoryProvider),
            ),
          ),
          _Composer(
            controller: _inputCtrl,
            sending: _sending,
            onSend: _send,
          ),
        ],
      ),
    );
  }
}

// ===== 气泡 =====

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message});
  final ChatMessage message;

  bool get _isUser => (message.id ?? '').startsWith('__pending_user__');

  bool get _isPending =>
      (message.id ?? '').startsWith('__pending_ai__') &&
      (message.content ?? '').isEmpty;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = _isUser ? scheme.primaryContainer : scheme.surfaceContainerHigh;
    final align = _isUser ? Alignment.centerRight : Alignment.centerLeft;
    final radius = _isUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(AppDimens.radius12),
            topRight: Radius.circular(AppDimens.radius12),
            bottomLeft: Radius.circular(AppDimens.radius12),
            bottomRight: Radius.circular(4),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(AppDimens.radius12),
            topRight: Radius.circular(AppDimens.radius12),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(AppDimens.radius12),
          );
    return Align(
      alignment: align,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: AppDimens.space4),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.space12,
            vertical: AppDimens.space8,
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: radius,
          ),
          child: _isPending
              ? SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: scheme.onSurfaceVariant,
                  ),
                )
              : Text(message.content ?? ''),
        ),
      ),
    );
  }
}

// ===== 输入框 =====

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.sending,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool sending;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(AppDimens.space12),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                enabled: !sending,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: const InputDecoration(
                  hintText: '说点什么…',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: AppDimens.space8),
            FilledButton(
              onPressed: sending ? null : onSend,
              child: sending
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}