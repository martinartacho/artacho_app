import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<List<dynamic>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = NotificationService.getNotifications();
  }

  Future<void> _markAsRead(String id) async {
    final success = await NotificationService.markAsRead(id);
    if (success) {
      setState(() {
        _notificationsFuture = NotificationService.getNotifications();
      });
    }
  }

  Widget _buildNotificationTile(Map<String, dynamic> item, bool isRead) {
    final title = item['title'] ?? 'Sin título';
    final content = item['content'] ?? '';

    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(content),
        ],
      ),
      trailing: isRead
          ? const Icon(Icons.check, color: Colors.green)
          : TextButton(
              onPressed: () => _markAsRead(item['id'].toString()),
              child: const Text('Marcar leída'),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: FutureBuilder<List<dynamic>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar notificaciones'));
          }

          final notifications = snapshot.data ?? [];
          if (notifications.isEmpty) {
            return const Center(child: Text('No tienes notificaciones'));
          }

          // ✅ CORRECTO: pivot.read_at
          final unread = notifications
              .where((n) => n['pivot']?['read_at'] == null)
              .toList();
          final read = notifications
              .where((n) => n['pivot']?['read_at'] != null)
              .toList();

          return ListView(
            children: [
              if (unread.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    '🔔 No leídas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ...unread
                    .map((item) => _buildNotificationTile(item, false))
                    .toList(),
              ],
              if (read.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    '✅ Leídas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ...read
                    .map((item) => _buildNotificationTile(item, true))
                    .toList(),
              ],
            ],
          );
        },
      ),
    );
  }
}
