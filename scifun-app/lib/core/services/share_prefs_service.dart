import 'package:shared_preferences/shared_preferences.dart';
import 'package:sci_fun/common/extension/share_prefs_extension.dart';

enum SharePrefsKey { accessToken, searchHistory }

class SharePrefsService {
  final SharedPreferences _prefs;
  static const String _keyToken = 'auth_token';
  static const String _keySaveSession = 'save_session';

  SharePrefsService({required SharedPreferences prefs}) : _prefs = prefs;
  Future<void> saveSearchHistory(List<String> searches) async {
    await _prefs.setStringList(SharePrefsKey.searchHistory.getKey, searches);
  }

  List<String> getSearchHistory() {
    return _prefs.getStringList(SharePrefsKey.searchHistory.getKey) ?? [];
  }

  Future<void> saveAuthToken(String? token) async {
    if (token == null) {
      await _prefs.remove(_keyToken);
    } else {
      await _prefs.setString(_keyToken, token);
    }
  }

  Future<void> saveSession(bool isSaveSession) async {
    await _prefs.setBool(_keySaveSession, isSaveSession);
  }

  String? getAuthToken() {
    return _prefs.getString(_keyToken);
  }

  bool? getSaveSession() {
    return _prefs.getBool(_keySaveSession);
  }

  Future<void> setString(SharePrefsKey key, String value) async {
    await _prefs.setString(key.getKey, value);
  }

  String? getString(SharePrefsKey key) {
    return _prefs.getString(key.getKey);
  }

  Future<void> clear() async {
    await _prefs.clear();
  }
}
