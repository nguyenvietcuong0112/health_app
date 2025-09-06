

enum Role { user, model }

class ChatMessage {
  final String text;
  final Role role;

  ChatMessage({required this.text, required this.role});
}
