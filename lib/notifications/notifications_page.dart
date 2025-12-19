import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'notification_service.dart';
import '../utils/responsive.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final notifService = Provider.of<NotificationService>(context);
    final notifications = notifService.notifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: const Color(0xFFE91E63),
        centerTitle: true,
        elevation: 4,
      ),
      body: notifications.isEmpty
          ? Center(
              child: Text(
                "No notifications yet",
                style: TextStyle(
                  fontSize: SizeConfig.sp(16),
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final n = notifications[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 8,
                        spreadRadius: 1,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    title: Text(
                      n.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.sp(16),
                      ),
                    ),
                    subtitle: Text(
                      n.body,
                      style: TextStyle(
                        fontSize: SizeConfig.sp(14),
                        height: 1.4,
                      ),
                    ),
                    trailing: n.read
                        ? const Icon(Icons.done, color: Colors.green)
                        : const Icon(Icons.circle, color: Colors.red, size: 12),
                    onTap: () => notifService.markAsRead(n.id),
                  ),
                );
              },
            ),
    );
  }
}
