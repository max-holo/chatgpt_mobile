import 'dart:html';

import 'package:chatgpt_web/env.dart';
import 'package:openai_api/openai_api.dart';

class ChatGPTService {
  final client = OpenaiClient(
    config: OpenaiConfig(
      apiKey: Env.apiKey, // your api key from openai.com
      // baseUrl: Env.baseUrl, // you can set your reverse proxy api
      httpProxy: Env.httpProxy, // if you need access api through http proxy
    ),
  );

  // 发送请求
  Future<ChatCompletionResponse> sendChat(String content) async {
    final request =
        ChatCompletionRequest(model: Model.gpt3_5Turbo_0301, messages: [
      ChatMessage(
        content: content,
        role: ChatMessageRole.user,
      )
    ]);
    return await client.sendChatCompletion(request);
  }
}
