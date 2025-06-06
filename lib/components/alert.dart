class Alert {
  final int id;
  final String title;
  final String content;
  final String type;
  final String status;

  Alert({required this.id, required this.title, required this.content, required this.type, required this.status});

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'No Title',
      content: json['content'] as String? ?? 'No Content',
      type: json['type'] as String? ?? 'unknown',
      status: json['status'] as String? ?? 'unknown',
    );
  }
}
