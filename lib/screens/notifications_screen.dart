import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = NotificationService();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Notifications')),
      body: FutureBuilder<List<JobNotification>>(
        future: service.getNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final notes = snapshot.data ?? [];
          if (notes.isEmpty) {
            return const Center(child: Text('No notifications yet.'));
          }

          return ListView.separated(
            itemCount: notes.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final note = notes[index];
              return Container(
                color: note.isRead ? Colors.transparent : Colors.white,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.joblyBlue.withOpacity(0.1),
                    child: const Icon(Icons.notifications_active_outlined, color: AppTheme.joblyBlue),
                  ),
                  title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(note.body),
                      const SizedBox(height: 4),
                      Text(
                        '${note.timestamp.day}/${note.timestamp.month} · ${note.timestamp.hour}:${note.timestamp.minute}',
                        style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                  onTap: () {
                    service.markAsRead(note.id);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
