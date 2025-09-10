class SimpleNotification {
  final int id;
  final int? userId;
  final String title;
  final String body;
  final String? targetType;
  final String? targetValue;
  final bool isRead;
  final DateTime createdAt;

  SimpleNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.targetType,
    required this.targetValue,
    required this.isRead,
    required this.createdAt,
  });

  factory SimpleNotification.fromJson(Map<String, dynamic> json) {
    return SimpleNotification(
      id: json['id'],
      userId: json['user_id'] == null
          ? null
          : (json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id'].toString())),
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      targetType: json['target_type'],
      targetValue: json['target_value'],
      isRead: json['is_read'] == 1,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

