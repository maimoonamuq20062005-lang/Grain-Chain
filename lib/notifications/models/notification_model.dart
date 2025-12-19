class AppNotification {
  final String id;
  final String title;
  final String body;
  final String recipientUserId; // Which user should receive this notification
  final DateTime timestamp;
  bool read;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.recipientUserId,
    required this.timestamp,
    this.read = false,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'recipientUserId': recipientUserId,
      'timestamp': timestamp.toIso8601String(),
      'read': read,
    };
  }

  // Create from JSON
  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      recipientUserId: json['recipientUserId'] as String? ?? 'unknown',
      timestamp: DateTime.parse(json['timestamp'] as String),
      read: json['read'] as bool? ?? false,
    );
  }
}
