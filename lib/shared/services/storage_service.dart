import 'package:shared_preferences/shared_preferences.dart';


class StorageService {
  static const String _lastSyncKey = 'last_sync';
  static const String _autoBackupKey = 'auto_backup_enabled';
  static const String _sortPreferenceKey = 'sort_preference';
  static const String _themePreferenceKey = 'theme_preference';
  static const String _passwordCountKey = 'password_count_cache';


  Future<DateTime?> getLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getString(_lastSyncKey);
    return timestamp != null ? DateTime.parse(timestamp) : null;
  }


  Future<void> updateLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
  }


  Future<bool> isAutoBackupEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_autoBackupKey) ?? true;
  }


  Future<void> setAutoBackup(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoBackupKey, enabled);
  }

  
  Future<int> getSortPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_sortPreferenceKey) ?? 2; 
  }


  Future<void> setSortPreference(int sortIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_sortPreferenceKey, sortIndex);
  }


  Future<String> getThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themePreferenceKey) ?? 'system';
  }

  
  Future<void> setThemePreference(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themePreferenceKey, theme);
  }


  Future<void> cachePasswordCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_passwordCountKey, count);
  }

 
  Future<int?> getCachedPasswordCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_passwordCountKey);
  }


  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
