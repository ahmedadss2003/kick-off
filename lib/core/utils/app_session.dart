import 'package:shared_preferences/shared_preferences.dart';

/// Simple in-memory session storage.
/// Replace with SharedPreferences/SecureStorage in production.
class AppSession {
  AppSession._();

  static String? token;
  static String? cachedImageUrl;

  static Future<void> saveProfileImage(String url) async {
    cachedImageUrl = url;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', url);
  }

  static Future<void> clearSession() async {
    token = null;
    cachedImageUrl = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
