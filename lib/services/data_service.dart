import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../food_management/models/food_item.dart';
import '../notifications/models/notification_model.dart';
import '../profile/models/review_model.dart';

/// DataService handles all local data persistence using SharedPreferences
/// This ensures that data (food posts, notifications, reviews, etc.) is saved locally
/// and persists across app restarts.
class DataService {
  static const String _foodItemsKey = 'food_items';
  static const String _notificationsKey = 'notifications';
  static const String _reviewsKey = 'reviews';

  late SharedPreferences _prefs;

  // Singleton instance
  static final DataService _instance = DataService._internal();

  factory DataService() {
    return _instance;
  }

  DataService._internal();

  /// Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ==================== FOOD ITEMS ====================

  /// Save all food items to local storage
  Future<bool> saveFoodItems(List<FoodItem> items) async {
    try {
      final jsonList = items.map((item) => jsonEncode(item.toJson())).toList();
      return await _prefs.setStringList(_foodItemsKey, jsonList);
    } catch (e) {
      print('Error saving food items: $e');
      return false;
    }
  }

  /// Load all food items from local storage
  List<FoodItem> loadFoodItems() {
    try {
      final jsonList = _prefs.getStringList(_foodItemsKey) ?? [];
      return jsonList
          .map((json) => FoodItem.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      print('Error loading food items: $e');
      return [];
    }
  }

  /// Add a single food item to storage
  Future<bool> addFoodItem(FoodItem item) async {
    try {
      final items = loadFoodItems();
      items.add(item);
      return await saveFoodItems(items);
    } catch (e) {
      print('Error adding food item: $e');
      return false;
    }
  }

  /// Delete a food item by ID
  Future<bool> deleteFoodItem(String foodId) async {
    try {
      final items = loadFoodItems();
      items.removeWhere((item) => item.id == foodId);
      return await saveFoodItems(items);
    } catch (e) {
      print('Error deleting food item: $e');
      return false;
    }
  }

  /// Get a specific food item by ID
  FoodItem? getFoodItemById(String foodId) {
    final items = loadFoodItems();
    try {
      return items.firstWhere((item) => item.id == foodId);
    } catch (e) {
      return null;
    }
  }

  // ==================== NOTIFICATIONS ====================

  /// Save all notifications to local storage
  Future<bool> saveNotifications(List<AppNotification> items) async {
    try {
      print(
        '[DataService.saveNotifications] Saving ${items.length} notifications to storage',
      );
      final jsonList = items.map((item) => jsonEncode(item.toJson())).toList();
      final result = await _prefs.setStringList(_notificationsKey, jsonList);
      print('[DataService.saveNotifications] Save result: $result');
      return result;
    } catch (e) {
      print('Error saving notifications: $e');
      return false;
    }
  }

  /// Load all notifications from local storage
  List<AppNotification> loadNotifications() {
    try {
      final jsonList = _prefs.getStringList(_notificationsKey) ?? [];
      print(
        '[DataService.loadNotifications] Loaded ${jsonList.length} notifications from storage',
      );
      return jsonList
          .map((json) => AppNotification.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      print('Error loading notifications: $e');
      return [];
    }
  }

  /// Add a single notification
  Future<bool> addNotification(AppNotification notification) async {
    try {
      final notifications = loadNotifications();
      notifications.add(notification);
      return await saveNotifications(notifications);
    } catch (e) {
      print('Error adding notification: $e');
      return false;
    }
  }

  /// Mark a notification as read
  Future<bool> markNotificationAsRead(String notificationId) async {
    try {
      final notifications = loadNotifications();
      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        notifications[index].read = true;
        return await saveNotifications(notifications);
      }
      return false;
    } catch (e) {
      print('Error marking notification as read: $e');
      return false;
    }
  }

  /// Delete a notification
  Future<bool> deleteNotification(String notificationId) async {
    try {
      final notifications = loadNotifications();
      notifications.removeWhere((n) => n.id == notificationId);
      return await saveNotifications(notifications);
    } catch (e) {
      print('Error deleting notification: $e');
      return false;
    }
  }

  /// Get unread notifications count
  int getUnreadNotificationCount() {
    final notifications = loadNotifications();
    return notifications.where((n) => !n.read).length;
  }

  // ==================== REVIEWS ====================

  /// Save all reviews to local storage
  Future<bool> saveReviews(List<ReviewModel> items) async {
    try {
      final jsonList = items.map((item) => jsonEncode(item.toJson())).toList();
      return await _prefs.setStringList(_reviewsKey, jsonList);
    } catch (e) {
      print('Error saving reviews: $e');
      return false;
    }
  }

  /// Load all reviews from local storage
  List<ReviewModel> loadReviews() {
    try {
      final jsonList = _prefs.getStringList(_reviewsKey) ?? [];
      return jsonList
          .map((json) => ReviewModel.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      print('Error loading reviews: $e');
      return [];
    }
  }

  /// Add a single review
  Future<bool> addReview(ReviewModel review) async {
    try {
      final reviews = loadReviews();
      reviews.add(review);
      return await saveReviews(reviews);
    } catch (e) {
      print('Error adding review: $e');
      return false;
    }
  }

  /// Get all reviews for a specific owner (user who posted the food)
  List<ReviewModel> getReviewsForOwner(String ownerId) {
    final allReviews = loadReviews();
    return allReviews.where((review) => review.ownerId == ownerId).toList();
  }

  /// Get all reviews for a specific food post
  List<ReviewModel> getReviewsForFood(String foodId) {
    final allReviews = loadReviews();
    return allReviews.where((review) => review.foodId == foodId).toList();
  }

  /// Delete a review by ID
  Future<bool> deleteReview(String reviewId) async {
    try {
      final reviews = loadReviews();
      reviews.removeWhere((r) => r.id == reviewId);
      return await saveReviews(reviews);
    } catch (e) {
      print('Error deleting review: $e');
      return false;
    }
  }

  // ==================== GENERAL ====================

  /// Clear all stored data
  Future<bool> clearAllData() async {
    try {
      return await _prefs.clear();
    } catch (e) {
      print('Error clearing data: $e');
      return false;
    }
  }
}
