import 'package:shared_preferences/shared_preferences.dart';
import '../food_management/models/user_model.dart';

/// UserSessionService manages the logged-in user's session data
/// Stores and retrieves user information (ID, name, email)
class UserSessionService {
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _isLoggedInKey = 'isLoggedIn';

  late SharedPreferences _prefs;

  // Singleton instance
  static final UserSessionService _instance = UserSessionService._internal();

  factory UserSessionService() {
    return _instance;
  }

  UserSessionService._internal();

  /// Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save user session after login/signup
  Future<bool> saveUserSession({
    required String userId,
    required String userName,
    required String userEmail,
  }) async {
    try {
      await _prefs.setString(_userIdKey, userId);
      await _prefs.setString(_userNameKey, userName);
      await _prefs.setString(_userEmailKey, userEmail);
      await _prefs.setBool(_isLoggedInKey, true);
      return true;
    } catch (e) {
      print('Error saving user session: $e');
      return false;
    }
  }

  /// Get current logged-in user
  UserModel? getCurrentUser() {
    try {
      final id = _prefs.getString(_userIdKey);
      final name = _prefs.getString(_userNameKey);

      if (id == null || name == null) {
        return null;
      }

      return UserModel(id: id, name: name, profileImage: 'icon');
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  /// Get current user ID
  String? getCurrentUserId() {
    return _prefs.getString(_userIdKey);
  }

  /// Get current user name
  String? getCurrentUserName() {
    return _prefs.getString(_userNameKey);
  }

  /// Get current user email
  String? getCurrentUserEmail() {
    return _prefs.getString(_userEmailKey);
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    return _prefs.getBool(_isLoggedInKey) ?? false;
  }

  /// Clear user session (logout)
  Future<bool> clearUserSession() async {
    try {
      await _prefs.remove(_userIdKey);
      await _prefs.remove(_userNameKey);
      await _prefs.remove(_userEmailKey);
      await _prefs.setBool(_isLoggedInKey, false);
      return true;
    } catch (e) {
      print('Error clearing user session: $e');
      return false;
    }
  }

  /// Generate unique user ID from username and email
  /// This is called ONLY during signup to ensure stable IDs
  /// Uses email hash instead of timestamp so same signup creates same ID
  static String generateUserId(String userName, String email) {
    // Generate ID: lowercase username + email hash
    // This ensures the SAME ID is generated for the SAME email
    final emailHash = email.toLowerCase().hashCode.abs();
    return '${userName.toLowerCase()}_$emailHash';
  }
}
