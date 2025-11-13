import 'dart:convert';

bool isExpireToken(String? token) {
  try {
    if (token == null) {
      return true;
    }
    final parts = token.split('.');
    if (parts.length != 3) return true;

    final payload = json
        .decode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));

    final int exp = payload['exp'];
    final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);

    return DateTime.now().isAfter(expiryDate);
  } catch (e) {
    return true;
  }
}
