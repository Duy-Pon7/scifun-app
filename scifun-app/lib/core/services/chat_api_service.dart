import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sci_fun/common/helper/log_debug.dart';
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

  Future<http.Response> _postWithFallbacks(
    List<Uri> candidates,
    Map<String, String> headers,
  ) async {
    const source = 'ChatApiService._postWithFallbacks';
    final tried = <String>[];
    for (final u in candidates) {
      tried.add(u.toString());
      try {
        final res = await http.post(u, headers: headers);
        if (res.statusCode >= 200 && res.statusCode < 300) {
          logApiSuccess(
            source: source,
            data: {'url': u.toString(), 'statusCode': res.statusCode},
          );
          return res;
        }

        if (res.statusCode == 404) {
          logApiFailure(
            source: source,
            data: {
              'message': '404 fallback',
              'url': u.toString(),
              'statusCode': res.statusCode,
            },
          );
          continue;
        }

        final message =
            'Request failed: ${res.statusCode} ${res.body} (url: $u)';
        logApiFailure(
          source: source,
          data: {
            'message': message,
            'url': u.toString(),
            'statusCode': res.statusCode,
            'response': res.body,
          },
        );
        throw Exception(message);
      } catch (e) {
        logApiFailure(
          source: source,
          data: {'url': u.toString(), 'error': e.toString()},
        );
        continue;
      }
    }

    final message = 'All POST attempts failed. Tried: ${tried.join(', ')}';
    logApiFailure(source: source, data: {'message': message, 'tried': tried});
    throw Exception(message);
  }

  Future<http.Response> _getWithFallbacks(
    List<Uri> candidates,
    Map<String, String> headers,
  ) async {
    const source = 'ChatApiService._getWithFallbacks';
    final tried = <String>[];
    for (final u in candidates) {
      tried.add(u.toString());
      try {
        final res = await http.get(u, headers: headers);
        if (res.statusCode >= 200 && res.statusCode < 300) {
          logApiSuccess(
            source: source,
            data: {'url': u.toString(), 'statusCode': res.statusCode},
          );
          return res;
        }

        if (res.statusCode == 404) {
          logApiFailure(
            source: source,
            data: {
              'message': '404 fallback',
              'url': u.toString(),
              'statusCode': res.statusCode,
            },
          );
          continue;
        }

        final message =
            'Request failed: ${res.statusCode} ${res.body} (url: $u)';
        logApiFailure(
          source: source,
          data: {
            'message': message,
            'url': u.toString(),
            'statusCode': res.statusCode,
            'response': res.body,
          },
        );
        throw Exception(message);
      } catch (e) {
        logApiFailure(
          source: source,
          data: {'url': u.toString(), 'error': e.toString()},
        );
        continue;
      }
    }

    final message = 'All GET attempts failed. Tried: ${tried.join(', ')}';
    logApiFailure(source: source, data: {'message': message, 'tried': tried});
    throw Exception(message);
  }

  Future<String> openConversation({
    required String token,
    String type = 'HUMAN',
  }) async {
    const source = 'ChatApiService.openConversation';
    try {
      final base = _base();
      final origin = Uri.parse(apiBaseUrl).origin;
      final baseNoVersion = base.replaceAll(RegExp(r'/api/v\d+$'), '');
      final normalizedType = type.trim().toUpperCase();

      List<Uri> buildCandidates(String root) {
        final list = <Uri>[];
        if (normalizedType.isNotEmpty) {
          list.add(Uri.parse('$root/chat/conversation?type=$normalizedType'));
          list.add(
              Uri.parse('$root/api/chat/conversation?type=$normalizedType'));
        }
        list.add(Uri.parse('$root/chat/conversation'));
        list.add(Uri.parse('$root/api/chat/conversation'));
        return list;
      }

      final candidates = <Uri>[
        ...buildCandidates(base),
        ...buildCandidates(origin),
      ];

      if (baseNoVersion != base) {
        candidates.addAll(buildCandidates(baseNoVersion));
      }

      final res = await _postWithFallbacks(candidates, {
        ..._headers(token),
        'Content-Type': 'application/json',
      });

      final json = jsonDecode(res.body);
      final id = _pickConversationId(json);
      if (id == null || id.isEmpty) {
        final message =
            'No conversationId in response: ${res.body} (url: ${res.request?.url})';
        logApiFailure(
          source: source,
          data: {'message': message, 'response': res.body},
        );
        throw Exception(message);
      }

      logApiSuccess(
        source: source,
        data: {'conversationId': id, 'url': res.request?.url.toString()},
      );
      return id;
    } catch (e) {
      logApiFailure(
        source: source,
        data: {'error': e.toString()},
      );
      rethrow;
    }
  }

  Future<List<ConversationSummary>> listConversations({
    required String token,
  }) async {
    const source = 'ChatApiService.listConversations';
    try {
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
      final conversations = arr
          .whereType<Map>()
          .map((e) => ConversationSummary.fromJson(e.cast<String, dynamic>()))
          .toList();

      logApiSuccess(
        source: source,
        data: {
          'count': conversations.length,
          'url': res.request?.url.toString()
        },
      );
      return conversations;
    } catch (e) {
      logApiFailure(source: source, data: {'error': e.toString()});
      rethrow;
    }
  }

  Future<List<ChatMessage>> getMessages({
    required String token,
    required String conversationId,
    int page = 1,
    int limit = 50,
  }) async {
    const source = 'ChatApiService.getMessages';
    try {
      final base = _base();
      final origin = Uri.parse(apiBaseUrl).origin;
      final baseNoVersion = base.replaceAll(RegExp(r'/api/v\d+$'), '');

      final candidates = <Uri>[
        Uri.parse(
            '$base/chat/$conversationId/messages?page=$page&limit=$limit'),
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

      final messages = items
          .whereType<Map>()
          .map((e) => ChatMessage.fromJson(e.cast<String, dynamic>()))
          .toList();

      logApiSuccess(
        source: source,
        data: {
          'conversationId': conversationId,
          'page': page,
          'limit': limit,
          'count': messages.length,
          'url': res.request?.url.toString(),
        },
      );
      return messages;
    } catch (e) {
      logApiFailure(
        source: source,
        data: {
          'conversationId': conversationId,
          'page': page,
          'limit': limit,
          'error': e.toString(),
        },
      );
      rethrow;
    }
  }
}
