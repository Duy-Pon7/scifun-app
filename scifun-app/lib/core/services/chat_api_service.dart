import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sci_fun/common/helper/log_debug.dart';
import 'package:sci_fun/common/models/chat_models.dart';

class ChatApiService {
  ChatApiService(this.apiBaseUrl);

  static final Map<String, Uri> _chatRootCache = {};

  final String apiBaseUrl;

  String _base() => apiBaseUrl.replaceAll(RegExp(r'/+$'), '');

  Uri? _resolvedChatRoot;

  Map<String, String> _headers(String token) => {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      };

  String get _chatRootCacheKey {
    try {
      return Uri.parse(_base()).origin;
    } catch (_) {
      return _base();
    }
  }

  Uri _normalizeRoot(Uri uri) {
    final normalizedPath =
        uri.path == '/' ? '' : uri.path.replaceFirst(RegExp(r'/+$'), '');
    return uri.replace(
      path: normalizedPath,
      query: null,
      fragment: null,
    );
  }

  String _joinPath(String left, String right) {
    final normalizedLeft =
        left == '/' ? '' : left.replaceFirst(RegExp(r'/+$'), '');
    final normalizedRight = right.replaceFirst(RegExp(r'^/+'), '');

    if (normalizedLeft.isEmpty) {
      return '/$normalizedRight';
    }
    return '$normalizedLeft/$normalizedRight';
  }

  Uri _chatEndpoint(
    Uri root,
    String suffix, {
    Map<String, String>? queryParameters,
  }) {
    return root.replace(
      path: _joinPath(root.path, 'chat/$suffix'),
      queryParameters: queryParameters == null || queryParameters.isEmpty
          ? null
          : queryParameters,
      fragment: null,
    );
  }

  String? _stripTrailingVersion(String path) {
    final normalized = path.replaceFirst(RegExp(r'/v\d+$'), '');
    if (normalized == path || normalized.isEmpty) return null;
    return normalized;
  }

  String? _stripApiVersion(String path) {
    final match = RegExp(r'^(.*?/api)/v\d+$').firstMatch(path);
    if (match == null) return null;

    final apiPath = match.group(1);
    if (apiPath == null || apiPath.isEmpty) return null;
    return apiPath;
  }

  List<Uri> _chatRootCandidates() {
    final candidates = <Uri>[];
    final seen = <String>{};

    void add(Uri uri) {
      final normalized = _normalizeRoot(uri);
      final key = normalized.toString();
      if (seen.add(key)) {
        candidates.add(normalized);
      }
    }

    final cachedRoot = _resolvedChatRoot ?? _chatRootCache[_chatRootCacheKey];
    if (cachedRoot != null) {
      add(cachedRoot);
    }

    final baseUri = Uri.parse(_base());
    final originUri = _normalizeRoot(
      baseUri.replace(path: '', query: null, fragment: null),
    );
    final basePath = baseUri.path == '/'
        ? ''
        : baseUri.path.replaceFirst(RegExp(r'/+$'), '');

    final apiPath = _stripApiVersion(basePath);
    if (apiPath != null) {
      add(originUri.replace(path: apiPath));
    }

    final versionlessPath = _stripTrailingVersion(basePath);
    if (versionlessPath != null) {
      add(originUri.replace(path: versionlessPath));
    }

    if (basePath.isNotEmpty) {
      add(originUri.replace(path: basePath));
    }

    add(originUri.replace(path: '/api'));
    add(originUri);

    return candidates;
  }

  void _rememberChatRoot(Uri? requestUri) {
    if (requestUri == null) return;

    final match = RegExp(r'/chat(?:/|$)').firstMatch(requestUri.path);
    if (match == null) return;

    final root = _normalizeRoot(
      requestUri.replace(
        path: requestUri.path.substring(0, match.start),
        query: null,
        fragment: null,
      ),
    );

    _resolvedChatRoot = root;
    _chatRootCache[_chatRootCacheKey] = root;
  }

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
          _rememberChatRoot(res.request?.url ?? u);
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
        throw _StopFallbackException(message);
      } on _StopFallbackException {
        rethrow;
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
          _rememberChatRoot(res.request?.url ?? u);
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
        throw _StopFallbackException(message);
      } on _StopFallbackException {
        rethrow;
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
      final normalizedType = type.trim().toUpperCase();
      final query = normalizedType.isEmpty
          ? null
          : <String, String>{'type': normalizedType};
      final candidates = _chatRootCandidates()
          .map((root) => _chatEndpoint(
                root,
                'conversation',
                queryParameters: query,
              ))
          .toList();

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
      final candidates = _chatRootCandidates()
          .map((root) => _chatEndpoint(root, 'conversations'))
          .toList();

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
      final candidates = _chatRootCandidates()
          .map(
            (root) => _chatEndpoint(
              root,
              '$conversationId/messages',
              queryParameters: {
                'page': '$page',
                'limit': '$limit',
              },
            ),
          )
          .toList();

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

class _StopFallbackException implements Exception {
  _StopFallbackException(this.message);

  final String message;

  @override
  String toString() => message;
}
