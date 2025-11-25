import 'package:flutter/material.dart';
import '../models/language.dart';
import '../repositories/settings_repository.dart';

class SettingsViewModel extends ChangeNotifier {
  final SettingsRepository _repository = SettingsRepository();
  
  Locale _currentLocale = const Locale('en');
  bool _isLoading = false;

  Locale get currentLocale => _currentLocale;
  bool get isLoading => _isLoading;

  List<Language> get supportedLanguages => Language.supportedLanguages;

  Language get currentLanguage {
    return Language.fromCode(_currentLocale.languageCode);
  }

  /// Initialize the view model and load saved language
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final savedLanguageCode = await _repository.getLanguage();
      if (savedLanguageCode != null) {
        _currentLocale = Locale(savedLanguageCode);
      }
    } catch (e) {
      print('Error initializing settings: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Change the app language
  Future<void> changeLanguage(Language language) async {
    if (_currentLocale.languageCode == language.code) {
      return; // Already using this language
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Save to persistent storage
      final success = await _repository.saveLanguage(language.code);
      
      if (success) {
        _currentLocale = Locale(language.code);
        print('SettingsViewModel: Language changed to ${language.name}');
      } else {
        print('SettingsViewModel: Failed to save language preference');
      }
    } catch (e) {
      print('Error changing language: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
