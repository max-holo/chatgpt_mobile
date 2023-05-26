import 'package:chatgpt_web/models/message.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MessageList extends StateNotifier<List<Message>> {
  MessageList() : super([]);

  void addMessage(Message message) {
    state = [...state, message];
  }
}

final messageProvider = StateNotifierProvider<MessageList, List<Message>>(
  (ref) => MessageList(),
);
