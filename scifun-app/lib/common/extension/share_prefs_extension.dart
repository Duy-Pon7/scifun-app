import 'package:thilop10_3004/core/services/share_prefs_service.dart';

extension SharedPrefsKeysX on SharePrefsKey {
  String get getKey {
    switch (this) {
      case SharePrefsKey.accessToken:
        return 'access_token';
      case SharePrefsKey.searchHistory:
        return 'search_history';
    }
  }
}
