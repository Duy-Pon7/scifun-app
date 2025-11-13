import 'dart:convert';

bool isExpiredToken(String token){
  try {
    final parts = token.split('.');
    if (parts.length != 3)  return true;

    final payload = base64Url.normalize(parts[1]);
    final decoded = json.decode(utf8.decode(base64Url.decode(payload)));

    if (decoded is! Map<String, dynamic>) return true;
    
    final exp = decoded['exp'];
    if(exp == null) return true;

    final expirationDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    return DateTime.now().isAfter(expirationDate);
  } catch (e) {
    return true;
  }
}