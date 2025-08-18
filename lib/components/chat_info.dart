class ChatInfo {
  final int id;
  final String title;
  final String content;
  final List<Message> messages;

  ChatInfo({
    required this.id,
    required this.title,
    required this.content,
    required this.messages,
  });

  factory ChatInfo.fromJson(Map<String, dynamic> json) {
    return ChatInfo(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'No Title',
      content: json['content'] as String? ?? 'No Content',
      messages: (json['messages'] as List<dynamic>?)
              ?.map((msg) => Message.fromJson(msg))
              .toList() ?? [],
    );
  }
}

class Message {
  final int id;
  final int brigadeId;
  final String brigadeName;
  final String message;
  final String createdAt;

  Message({
    required this.id,
    required this.brigadeId,
    required this.brigadeName,
    required this.message,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as int,
      brigadeId: json['brigade_id'] as int,
      brigadeName: json['brigade_name'] as String? ?? 'Unknown',
      message: json['message'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }
}
