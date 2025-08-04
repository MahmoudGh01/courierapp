import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsLocalDataSource {
  AppSettingsLocalDataSource._() {
    _initPrefs();
  }

  static final AppSettingsLocalDataSource _instance =
      AppSettingsLocalDataSource._();

  factory AppSettingsLocalDataSource() => _instance;

  SharedPreferences? _preferences;

  static const String _languageKey = "current_language";

  _initPrefs() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  Future<String?> getCurrentLanguage() async {
    await _initPrefs();
    return _preferences!.getString(_languageKey);
  }

  Future<bool> setCurrentLanguage(String languageCode) async {
    await _initPrefs();
    return _preferences!.setString(_languageKey, languageCode);
  }
}
