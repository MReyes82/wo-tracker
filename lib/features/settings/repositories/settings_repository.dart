import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  static const String _languageKey = 'app_language';

  /// Save the selected language code to persistent storage
  Future<bool> saveLanguage(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_languageKey, languageCode);
    } catch (e) {
      print('Error saving language: $e');
      return false;
    }
  }

  /// Get the saved language code, or null if not set
  Future<String?> getLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_languageKey);
    } catch (e) {
      print('Error getting language: $e');
      return null;
    }
  }

  /// Clear the saved language preference
  Future<bool> clearLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_languageKey);
    } catch (e) {
      print('Error clearing language: $e');
      return false;
    }
  }
}
