import 'package:shared_preferences/shared_preferences.dart';
import 'package:sci_fun/common/extension/share_prefs_extension.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';

enum SharePrefsKey { accessToken, searchHistory }

class SharePrefsService {
  final SharedPreferences _prefs;
  static const String _keyToken = 'auth_token';
  static const String _keySaveSession = 'save_session';
  static const String _keyUserData = 'user_data';
  static const String _keySelectedSubjectId = 'selected_subject_id';
  static const String _keySelectedSubjectName = 'selected_subject_name';
  static const String _keyOnboardingLevel = 'onboarding_level';
  static const String _defaultSubjectName = 'Vật lý';

  SharePrefsService({required SharedPreferences prefs}) : _prefs = prefs {
    AppColor.applySubjectName(getSelectedSubjectName());
  }
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

  Future<void> saveUserData(String? userData) async {
    if (userData == null) {
      await _prefs.remove(_keyUserData);
    } else {
      await _prefs.setString(_keyUserData, userData);
    }
  }

  Future<void> saveSession(bool isSaveSession) async {
    await _prefs.setBool(_keySaveSession, isSaveSession);
  }

  String? getAuthToken() {
    return _prefs.getString(_keyToken);
  }

  String? getUserData() {
    return _prefs.getString(_keyUserData);
  }

  bool? getSaveSession() {
    return _prefs.getBool(_keySaveSession);
  }

  Future<void> saveSelectedSubject({
    required String subjectId,
    required String subjectName,
  }) async {
    final normalizedId = subjectId.trim();
    final normalizedName =
        subjectName.trim().isEmpty ? _defaultSubjectName : subjectName.trim();
    AppColor.applySubjectName(normalizedName);

    if (normalizedId.isEmpty) {
      await _prefs.remove(_keySelectedSubjectId);
    } else {
      await _prefs.setString(_keySelectedSubjectId, normalizedId);
    }
    await _prefs.setString(_keySelectedSubjectName, normalizedName);
  }

  String? getSelectedSubjectId() {
    return _prefs.getString(_keySelectedSubjectId);
  }

  String? getSelectedSubjectName() {
    return _prefs.getString(_keySelectedSubjectName) ?? _defaultSubjectName;
  }

  String? getOnboardingLevel() {
    return _prefs.getString(_keyOnboardingLevel);
  }

  Future<void> clearSelectedSubject() async {
    await _prefs.remove(_keySelectedSubjectId);
    await _prefs.remove(_keySelectedSubjectName);
    AppColor.resetSubjectTheme();
  }

  Future<void> setString(SharePrefsKey key, String value) async {
    await _prefs.setString(key.getKey, value);
  }

  String? getString(SharePrefsKey key) {
    return _prefs.getString(key.getKey);
  }

  Future<void> clear() async {
    await _prefs.clear();
    AppColor.resetSubjectTheme();
  }
}
