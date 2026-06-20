import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  static const String _keyThemeMode = 'settings_theme_mode';
  static const String _keyReminderTime = 'settings_reminder_time';
  static const String _keyWeekStartDay = 'settings_week_start_day';

  ThemeMode _themeMode = ThemeMode.system;
  String _defaultReminderTime = '08:00';
  String _weekStartDay = 'Monday';
  bool _isInitialized = false;

  ThemeMode get themeMode => _themeMode;
  String get defaultReminderTime => _defaultReminderTime;
  String get weekStartDay => _weekStartDay;
  bool get isInitialized => _isInitialized;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load theme
    final themeStr = prefs.getString(_keyThemeMode) ?? 'system';
    _themeMode = _parseThemeMode(themeStr);

    // Load reminder time
    _defaultReminderTime = prefs.getString(_keyReminderTime) ?? '08:00';

    // Load week start day
    _weekStartDay = prefs.getString(_keyWeekStartDay) ?? 'Monday';

    _isInitialized = true;
    notifyListeners();
  }

  ThemeMode _parseThemeMode(String themeStr) {
    switch (themeStr) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
      default:
        return 'system';
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemeMode, _themeModeToString(mode));
    notifyListeners();
  }

  Future<void> setDefaultReminderTime(String time) async {
    _defaultReminderTime = time;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyReminderTime, time);
    notifyListeners();
  }

  Future<void> setWeekStartDay(String day) async {
    _weekStartDay = day;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyWeekStartDay, day);
    notifyListeners();
  }
}
