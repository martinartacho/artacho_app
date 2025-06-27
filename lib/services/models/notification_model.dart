class NotificationModel {
  final String id;
  final String title;
  final String body;
  final bool read;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.read,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return NotificationModel(
      id: json['id'].toString(),
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      read: json['read_at'] != null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
