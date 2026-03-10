/// Simple in-memory session storage.
/// Replace with SharedPreferences/SecureStorage in production.
class AppSession {
  AppSession._();

  static String? token;
}
