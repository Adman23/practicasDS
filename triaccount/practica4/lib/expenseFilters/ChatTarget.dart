import 'Message.dart';

class ChatTarget {
  void publish(Message message) {
    print('Publishing to chat: ${message.content}');
  }
}
