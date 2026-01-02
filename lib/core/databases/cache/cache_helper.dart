import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? _preferences;

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// Save data to SharedPreferences
  static Future<void> setData<T>(String key, T value) async {
    if (_preferences == null) {
      throw Exception("SharedPreferences not initialized");
    }

    if (value is String) {
      await _preferences!.setString(key, value);
    } else if (value is int) {
      await _preferences!.setInt(key, value);
    } else if (value is bool) {
      await _preferences!.setBool(key, value);
    } else if (value is double) {
      await _preferences!.setDouble(key, value);
    } else if (value is List<String>) {
      await _preferences!.setStringList(key, value);
    } else {
      throw Exception("Unsupported type");
    }
  }

  /// Retrieve data from SharedPreferences
  static T? getData<T>(String key) {
    if (_preferences == null) {
      throw Exception("SharedPreferences not initialized");
    }

    if (T == String) {
      return _preferences!.getString(key) as T?;
    } else if (T == int) {
      return _preferences!.getInt(key) as T?;
    } else if (T == bool) {
      return _preferences!.getBool(key) as T?;
    } else if (T == double) {
      return _preferences!.getDouble(key) as T?;
    } else if (T == List<String>) {
      return _preferences!.getStringList(key) as T?;
    } else {
      throw Exception("Unsupported type");
    }
  }

  /// Remove data from SharedPreferences
  static Future<void> removeData(String key) async {
    if (_preferences == null) {
      throw Exception("SharedPreferences not initialized");
    }
    await _preferences!.remove(key);
  }
}
