import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/network/remote_config.dart';
import 'package:sci_fun/core/services/share_prefs_service.dart';

String wsUrlForEnvironment() {
  return RemoteConfig.wsUrl;
}

Future<String?> getChatToken() async {
  try {
    final token = sl<SharePrefsService>().getAuthToken();
    if (token != null && token.isNotEmpty) {
      return token;
    }
  } catch (_) {
    // Fallback to secure storage when shared prefs is unavailable.
  }

  const storage = FlutterSecureStorage();
  return storage.read(key: 'access_token');
}
