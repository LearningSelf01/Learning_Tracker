import 'package:shared_preferences/shared_preferences.dart';

/// Simple helper to persist and cache the last used area (student/teacher)
class LastArea {
  static const _key = 'last_area'; // values: 'student' | 'teacher'
  static String? _cache;

  /// Load persisted value into memory cache. Call at app start.
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _cache = prefs.getString(_key);
  }

  static String? get cached => _cache;

  static Future<void> setStudent() async {
    _cache = 'student';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, _cache!);
  }

  static Future<void> setTeacher() async {
    _cache = 'teacher';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, _cache!);
  }

  static Future<void> setAdmin() async {
    _cache = 'admin';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, _cache!);
  }

  static Future<void> clear() async {
    _cache = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
