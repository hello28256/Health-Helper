// @dart=2.19


import 'package:test/test.dart';
import 'package:health_helper_api/health_helper_api.dart';


/// tests for ChatApi
void main() {
  final instance = HealthHelperApi().getChatApi();

  group(ChatApi, () {
    // 查询历史对话
    //
    //Future<ApiChatHistoryGet200Response> apiChatHistoryGet({ int limit }) async
    test('test apiChatHistoryGet', () async {
      // TODO
    });

    // 发送 AI 对话
    //
    // AI 回复带 **医疗免责声明**（你不是医生 / 不能替代专业诊断）。服务端未配置 ANTHROPIC_API_KEY / OPENAI_API_KEY 时返回 503 AI_DISABLED；上游 AI 失败时返回 502 AI_UPSTREAM_ERROR。
    //
    //Future<ChatSendResult> apiChatMessagesPost(ApiChatMessagesPostRequest apiChatMessagesPostRequest) async
    test('test apiChatMessagesPost', () async {
      // TODO
    });

  });
}
