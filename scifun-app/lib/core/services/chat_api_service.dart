import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sci_fun/common/models/chat_models.dart';

class ChatApiService {
  ChatApiService(this.apiBaseUrl);

  final String apiBaseUrl;

  String _base() => apiBaseUrl.replaceAll(RegExp(r'/+$'), '');

  Map<String, String> _headers(String token) => {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      };

  String? _pickConversationId(dynamic obj) {
    if (obj is Map<String, dynamic>) {
      return (obj['conversationId'] ??
              obj['id'] ??
              obj['_id'] ??
              (obj['data'] is Map
                  ? (obj['data']['conversationId'] ??
                      obj['data']['id'] ??
                      obj['data']['_id'])
                  : null))
          ?.toString();
    }
    return null;
  }

  List<dynamic> _pickItems(dynamic payload) {
    if (payload == null) return [];
    if (payload is List) return payload;
    if (payload is Map<String, dynamic>) {
      final items = payload['items'];
      if (items is List) return items;

      final content = payload['content'];
      if (content is List) return content;

      final data = payload['data'];
      if (data is Map) {
        final dataItems = data['items'];
        if (dataItems is List) return dataItems;
        final dataContent = data['content'];
        if (dataContent is List) return dataContent;
      }
    }
    return [];
  }

  // Helper to try multiple POST URLs (returns first successful response)
  Future<http.Response> _postWithFallbacks(
      List<Uri> candidates, Map<String, String> headers) async {
    final tried = <String>[];
    for (final u in candidates) {
      tried.add(u.toString());
      try {
        final res = await http.post(u, headers: headers);
        if (res.statusCode >= 200 && res.statusCode < 300) {
          try {
            print('POST success: $u');
          } catch (_) {}
          return res;
        }
        if (res.statusCode == 404) {
          try {
            print('POST 404: $u');
          } catch (_) {}
          continue;
        }
        throw Exception(
            'Request failed: ${res.statusCode} ${res.body} (url: $u)');
      } catch (e) {
        try {
          print('POST error for $u: $e');
        } catch (_) {}
        continue;
      }
    }
    throw Exception('All POST attempts failed. Tried: ${tried.join(', ')}');
  }

  // Helper to try multiple GET URLs (returns first successful response)
  Future<http.Response> _getWithFallbacks(
      List<Uri> candidates, Map<String, String> headers) async {
    final tried = <String>[];
    for (final u in candidates) {
      tried.add(u.toString());
      try {
        final res = await http.get(u, headers: headers);
        if (res.statusCode >= 200 && res.statusCode < 300) {
          try {
            print('GET success: $u');
          } catch (_) {}
          return res;
        }
        if (res.statusCode == 404) {
          try {
            print('GET 404: $u');
          } catch (_) {}
          continue;
        }
        throw Exception(
            'Request failed: ${res.statusCode} ${res.body} (url: $u)');
      } catch (e) {
        try {
          print('GET error for $u: $e');
        } catch (_) {}
        continue;
      }
    }
    throw Exception('All GET attempts failed. Tried: ${tried.join(', ')}');
  }

  /// USER: POST /chat/conversation (will try several URL variants)
  Future<String> openConversation({required String token}) async {
    final base = _base();
    final origin = Uri.parse(apiBaseUrl).origin;
    final baseNoVersion = base.replaceAll(RegExp(r'/api/v\d+$'), '');

    final candidates = <Uri>[
      Uri.parse('$base/chat/conversation'),
      Uri.parse('$base/api/chat/conversation'),
      Uri.parse('$origin/chat/conversation'),
      Uri.parse('$origin/api/chat/conversation'),
    ];

    if (baseNoVersion != base) {
      candidates.add(Uri.parse('$baseNoVersion/api/chat/conversation'));
      candidates.add(Uri.parse('$baseNoVersion/chat/conversation'));
    }

    final res = await _postWithFallbacks(candidates, {
      ..._headers(token),
      'Content-Type': 'application/json',
    });

    final json = jsonDecode(res.body);
    final id = _pickConversationId(json);
    if (id == null || id.isEmpty) {
      throw Exception(
          'No conversationId in response: ${res.body} (url: ${res.request?.url})');
    }

    return id;
  }

  /// ADMIN: GET /chat/conversations (will try several URL variants)
  Future<List<ConversationSummary>> listConversations(
      {required String token}) async {
    final base = _base();
    final origin = Uri.parse(apiBaseUrl).origin;
    final baseNoVersion = base.replaceAll(RegExp(r'/api/v\d+$'), '');

    final candidates = <Uri>[
      Uri.parse('$base/chat/conversations'),
      Uri.parse('$base/api/chat/conversations'),
      Uri.parse('$origin/chat/conversations'),
      Uri.parse('$origin/api/chat/conversations'),
    ];

    if (baseNoVersion != base) {
      candidates.add(Uri.parse('$baseNoVersion/api/chat/conversations'));
      candidates.add(Uri.parse('$baseNoVersion/chat/conversations'));
    }

    final res = await _getWithFallbacks(candidates, _headers(token));

    final payload = jsonDecode(res.body);
    final arr = payload is List
        ? payload
        : (payload is Map ? (_pickItems(payload)) : <dynamic>[]);
    return arr
        .whereType<Map>()
        .map((e) => ConversationSummary.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  /// GET /chat/{conversationId}/messages?page=1&limit=50 (tries several URL variants)
  Future<List<ChatMessage>> getMessages({
    required String token,
    required String conversationId,
    int page = 1,
    int limit = 50,
  }) async {
    final base = _base();
    final origin = Uri.parse(apiBaseUrl).origin;
    final baseNoVersion = base.replaceAll(RegExp(r'/api/v\d+$'), '');

    final candidates = <Uri>[
      Uri.parse('$base/chat/$conversationId/messages?page=$page&limit=$limit'),
      Uri.parse(
          '$base/api/chat/$conversationId/messages?page=$page&limit=$limit'),
      Uri.parse(
          '$origin/chat/$conversationId/messages?page=$page&limit=$limit'),
      Uri.parse(
          '$origin/api/chat/$conversationId/messages?page=$page&limit=$limit'),
    ];

    if (baseNoVersion != base) {
      candidates.add(Uri.parse(
          '$baseNoVersion/api/chat/$conversationId/messages?page=$page&limit=$limit'));
      candidates.add(Uri.parse(
          '$baseNoVersion/chat/$conversationId/messages?page=$page&limit=$limit'));
    }

    final res = await _getWithFallbacks(candidates, _headers(token));

    final payload = jsonDecode(res.body);
    final items = _pickItems(payload);

    return items
        .whereType<Map>()
        .map((e) => ChatMessage.fromJson(e.cast<String, dynamic>()))
        .toList();
  }
}
