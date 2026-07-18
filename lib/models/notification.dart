class JobNotification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  bool isRead;

  JobNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
  });
}
