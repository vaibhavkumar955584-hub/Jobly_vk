import 'dart:async';
import '../models/notification.dart';

class NotificationService {
  final List<JobNotification> _notifications = [
    JobNotification(
      id: '1',
      title: 'Application Viewed',
      body: 'Wipro Limited has viewed your application for "Accounting Consultant".',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    JobNotification(
      id: '2',
      title: 'New Job Match',
      body: 'A new role "Statutory Audit Manager" matches your profile.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  Future<List<JobNotification>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _notifications;
  }

  Future<void> markAsRead(String id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
    }
  }
}
