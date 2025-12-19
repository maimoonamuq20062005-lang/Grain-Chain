import 'package:flutter/material.dart';
import 'models/notification_model.dart';
import '../services/data_service.dart';
import '../services/user_session_service.dart';

class NotificationService extends ChangeNotifier {
  final List<AppNotification> _notifications = [];
  final DataService _dataService = DataService();
  final UserSessionService _userSessionService = UserSessionService();

  // Initialize and load notifications from storage
  Future<void> init() async {
    _reloadNotifications();
  }

  // Reload notifications for current user (call this after login)
  void _reloadNotifications() {
    _notifications.clear();
    final allNotifications = _dataService.loadNotifications();
    // Filter to show only notifications for current logged-in user
    final currentUserId = _userSessionService.getCurrentUserId();

    print(
      '[NotificationService._reloadNotifications] Total notifications in storage: ${allNotifications.length}',
    );
    print(
      '[NotificationService._reloadNotifications] Current user ID: $currentUserId',
    );

    // Debug: print all notifications and their recipient IDs
    for (int i = 0; i < allNotifications.length; i++) {
      print(
        '[NotificationService._reloadNotifications] Notification $i: title=${allNotifications[i].title}, recipientId=${allNotifications[i].recipientUserId}',
      );
    }

    if (currentUserId != null) {
      final filtered = allNotifications
          .where((n) => n.recipientUserId == currentUserId)
          .toList();
      print(
        '[NotificationService._reloadNotifications] Filtered notifications for user: ${filtered.length}',
      );
      _notifications.addAll(filtered);
    }
    notifyListeners();
  }

  // Expose notifications (newest first)
  List<AppNotification> get notifications =>
      List.unmodifiable(_notifications.reversed);

  // Public method to reload notifications for current user (call after login)
  void reloadNotificationsForUser() {
    _reloadNotifications();
  }

  // Add a new notification (save for all, but only display to recipient)
  void addNotification(AppNotification notification) {
    print(
      '[NotificationService] Adding notification: ${notification.title} for recipient: ${notification.recipientUserId}',
    );
    print(
      '[NotificationService] Notification details: id=${notification.id}, title=${notification.title}, body=${notification.body}',
    );

    // Always load all notifications from storage to preserve them
    final allNotifications = _dataService.loadNotifications();
    print(
      '[NotificationService] Current notifications in storage: ${allNotifications.length}',
    );

    // Add the new notification
    allNotifications.add(notification);

    // Save ALL notifications to persistent storage (fire and forget)
    _dataService
        .saveNotifications(allNotifications)
        .then((result) {
          print(
            '[NotificationService] Saved ${allNotifications.length} notifications to storage - Result: $result',
          );
        })
        .onError((error, stackTrace) {
          print('[NotificationService] Error saving notifications: $error');
          print('[NotificationService] Stack trace: $stackTrace');
        });

    // Only add to in-memory list if it's for current user
    final currentUserId = _userSessionService.getCurrentUserId();
    print('[NotificationService] Current logged-in user ID: $currentUserId');
    print(
      '[NotificationService] Checking if notification for current user: $currentUserId == ${notification.recipientUserId}',
    );

    if (currentUserId == notification.recipientUserId) {
      _notifications.add(notification);
      print(
        '[NotificationService] ✓ MATCH! Added notification to in-memory list for current user',
      );
      notifyListeners();
    } else {
      print(
        '[NotificationService] ✗ NO MATCH. Notification is not for current user, only saved to storage',
      );
    }
  }

  // Mark a notification as read
  void markAsRead(String id) {
    try {
      final notif = _notifications.firstWhere((n) => n.id == id);
      notif.read = true;

      // Load all notifications from storage and update the one we found
      final allNotifications = _dataService.loadNotifications();
      final index = allNotifications.indexWhere((n) => n.id == id);
      if (index >= 0) {
        allNotifications[index].read = true;
      }

      // Save ALL notifications to persistent storage
      _dataService.saveNotifications(allNotifications).ignore();
      notifyListeners();
    } catch (e) {
      // Notification with this ID not found; safely ignore
      print("Notification with id $id not found.");
    }
  }

  // Delete a notification
  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);

    // Load all notifications from storage and remove the one we deleted
    final allNotifications = _dataService.loadNotifications();
    allNotifications.removeWhere((n) => n.id == id);

    // Save ALL notifications to persistent storage
    _dataService.saveNotifications(allNotifications).ignore();
    notifyListeners();
  }

  // Clear all notifications
  void clearAll() {
    _notifications.clear();
    // Save to persistent storage
    _dataService.saveNotifications(_notifications).ignore();
    notifyListeners();
  }

  // Count of unread notifications
  int get unreadCount => _notifications.where((n) => !n.read).length;
}
