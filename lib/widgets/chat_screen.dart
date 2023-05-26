import 'package:chatgpt_web/injection.dart';
import 'package:chatgpt_web/models/message.dart';
import 'package:chatgpt_web/states/message_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatScreen extends HookConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 获取数据
    final messages = ref.watch(messageProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              // 聊天消息列表
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return MessageItem(message: messages[index]);
                  },
                  separatorBuilder: (context, index) => const Divider(
                        height: 16,
                      ),
                  itemCount: messages.length),
            ),
            // 消息输入框
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Type a message',
                suffixIcon: IconButton(
                  onPressed: () {
                    if (_textController.text.isNotEmpty) {
                      _sendMessage(ref, _textController.text);
                    }
                  },
                  icon: const Icon(Icons.send),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageItem extends StatelessWidget {
  const MessageItem({
    super.key,
    required this.message,
  });
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: message.isUser ? Colors.green : Colors.grey,
          child: Text(message.isUser ? 'M' : 'GPT'),
        ),
        const SizedBox(
          width: 8,
        ),
        Text(message.content),
      ],
    );
  }
}

final _textController = TextEditingController();

_sendMessage(WidgetRef ref, String content) {
  final message =
      Message(content: content, isUser: true, timestamp: DateTime.now());
  // 添加消息
  ref.read(messageProvider.notifier).addMessage(message);
  // 清空输入框的消息
  _textController.clear();
  // 发起请求
  _requestChatGPT(ref, content);
}

_requestChatGPT(WidgetRef ref, String content) async {
  final res = await chatgpt.sendChat(content);
  final text = res.choices.first.message?.content ?? "";
  final message =
      Message(content: text, isUser: false, timestamp: DateTime.now());
  ref.read(messageProvider.notifier).addMessage(message);
}
