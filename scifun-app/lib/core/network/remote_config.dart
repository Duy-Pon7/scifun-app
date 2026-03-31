import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RemoteConfig {
  RemoteConfig._();

  static const String _fallbackApiBaseUrl =
      'https://java-app-9trd.onrender.com/api/v1';

  static String get apiBaseUrl {
    final candidates = <String?>[
      if (kIsWeb) dotenv.env['WEB_BASE_URL'],
      dotenv.env['BASE_URL'],
    ];

    final configuredValue = _firstNonEmpty(candidates);
    return _normalizeApiBaseUrl(configuredValue ?? _fallbackApiBaseUrl);
  }

  static String get wsUrl {
    final explicitWsUrl = dotenv.env['WS_URL']?.trim();
    if (explicitWsUrl != null && explicitWsUrl.isNotEmpty) {
      return explicitWsUrl;
    }

    final apiUri = Uri.parse(apiBaseUrl);
    final wsScheme = apiUri.scheme == 'https' ? 'wss' : 'ws';

    return apiUri
        .replace(
          scheme: wsScheme,
          path: '/ws',
          query: null,
          fragment: null,
        )
        .toString();
  }

  static String? _firstNonEmpty(List<String?> values) {
    for (final value in values) {
      final trimmed = value?.trim();
      if (trimmed != null && trimmed.isNotEmpty) {
        return trimmed;
      }
    }
    return null;
  }

  static String _normalizeApiBaseUrl(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return _fallbackApiBaseUrl;
    }

    try {
      final uri = Uri.parse(trimmed);
      if (!uri.hasScheme || uri.host.isEmpty) {
        return _fallbackApiBaseUrl;
      }

      final normalizedPath = uri.path.replaceFirst(RegExp(r'/+$'), '');
      return uri
          .replace(
            path: normalizedPath,
            query: null,
            fragment: null,
          )
          .toString();
    } catch (_) {
      return _fallbackApiBaseUrl;
    }
  }
}
