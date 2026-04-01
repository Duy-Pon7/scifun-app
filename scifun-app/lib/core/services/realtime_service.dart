import 'dart:async';
import 'dart:convert';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:sci_fun/common/models/chat_models.dart';

class RealtimeService {
  RealtimeService._();
  static final RealtimeService I = RealtimeService._();

  StompClient? _client;

  final _commentController = StreamController<Map<String, dynamic>>.broadcast();
  final _notiController = StreamController<Map<String, dynamic>>.broadcast();
  final _chatController = StreamController<ChatMessage>.broadcast();

  // Connection status stream: true when STOMP connected, false otherwise.
  final _connectionController = StreamController<bool>.broadcast();

  // Queue messages when socket is not ready; they will be flushed on connect.
  final List<Map<String, String>> _pendingMessages = [];

  // Active chat subscription state
  String? _activeConversationId;
  dynamic _chatSubscription;
  String? _selfId;

  Stream<Map<String, dynamic>> get commentStream => _commentController.stream;
  Stream<Map<String, dynamic>> get notificationStream => _notiController.stream;
  Stream<ChatMessage> get chatStream => _chatController.stream;
  Stream<bool> get connectionStream => _connectionController.stream;

  bool get isConnected => _client?.connected ?? false;

  /// ID assigned by server for this connection (from CONNECTED headers, e.g. user-name)
  String? get selfId => _selfId;

  ChatMessage? _parseChatFrame(
    StompFrame frame, {
    String? fallbackConversationId,
  }) {
    final body = frame.body;
    if (body == null || body.isEmpty) return null;

    try {
      final json = jsonDecode(body);
      if (json is! Map) return null;

      var message = ChatMessage.fromJson(json.cast<String, dynamic>());
      final messageConversationId = message.conversationId?.trim();
      if ((messageConversationId == null || messageConversationId.isEmpty) &&
          fallbackConversationId != null &&
          fallbackConversationId.trim().isNotEmpty) {
        message = ChatMessage(
          id: message.id,
          conversationId: fallbackConversationId.trim(),
          senderId: message.senderId,
          senderRole: message.senderRole,
          senderName: message.senderName,
          content: message.content,
          createdAt: message.createdAt,
        );
      }
      return message;
    } catch (e) {
      print('Failed to parse chat message: $e');
      return null;
    }
  }

  dynamic _subscribeConversationTopic(
    String conversationId, {
    required void Function(ChatMessage message) onMessage,
  }) {
    final c = _client;
    if (c == null || !c.connected) return null;

    final id = conversationId.trim();
    if (id.isEmpty) return null;

    try {
      return c.subscribe(
        destination: '/topic/chat/$id',
        callback: (f) {
          final message = _parseChatFrame(
            f,
            fallbackConversationId: id,
          );
          if (message != null) onMessage(message);
        },
      );
    } catch (e) {
      print('Failed to subscribe to chat topic $id: $e');
      return null;
    }
  }

  void unsubscribe(dynamic subscription) {
    if (subscription == null) return;
    try {
      (subscription as dynamic).unsubscribe();
    } catch (_) {}
  }

  /// Subscribe to `/topic/chat/{conversationId}` with a custom callback.
  /// Used by admin screen to listen to multiple rooms simultaneously.
  dynamic subscribeConversationTopic({
    required String conversationId,
    required void Function(ChatMessage message) onMessage,
  }) {
    return _subscribeConversationTopic(
      conversationId,
      onMessage: onMessage,
    );
  }

  /// wsUrl: wss://api.your.com/ws  (backend registerStompEndpoints: /ws)
  Future<void> connect({
    required String wsUrl,
    required Future<String?> Function() getToken,
    void Function(dynamic error)? onError,
  }) async {
    // Avoid activating multiple times. If a client exists and is already connected, return.
    if (_client != null) {
      try {
        if (_client!.connected) return;
        // If there's an existing client but it's not connected, deactivate and recreate to ensure clean state.
        try {
          _client!.deactivate();
        } catch (_) {}
      } catch (_) {}
      _client = null;
    }

    final token = await getToken();

    _client = StompClient(
      config: StompConfig(
        url: wsUrl,

        // Token thường đọc trong CONNECT headers (Spring inbound interceptor hay dùng)
        stompConnectHeaders: token == null
            ? {}
            : {
                'Authorization': 'Bearer $token',
              },

        // Handshake headers (mobile/desktop OK; web browser thường bị hạn chế)
        webSocketConnectHeaders: token == null
            ? {}
            : {
                'Authorization': 'Bearer $token',
              },

        reconnectDelay: const Duration(seconds: 3),
        heartbeatIncoming: const Duration(seconds: 10),
        heartbeatOutgoing: const Duration(seconds: 10),

        onConnect: (StompFrame frame) {
          // Broadcast comment mới: messagingTemplate.convertAndSend("/topic/comment/new", ...)
          _client!.subscribe(
            destination: '/topic/comment/new',
            callback: (f) {
              final body = f.body;
              if (body == null || body.isEmpty) return;
              final json = jsonDecode(body);
              if (json is Map<String, dynamic>) {
                _commentController.add(json);
              }
            },
          );
          // debug
          try {
            print('Subscribed to /topic/comment/new');
          } catch (_) {}

          // Notification theo user: convertAndSendToUser(userId, "/queue/notifications", ...)
          _client!.subscribe(
            destination: '/user/queue/notifications',
            callback: (f) {
              final body = f.body;
              if (body == null || body.isEmpty) return;
              final json = jsonDecode(body);
              if (json is Map<String, dynamic>) {
                _notiController.add(json);
              }
            },
          );
          // debug
          try {
            print('Subscribed to /user/queue/notifications');
          } catch (_) {}

          // Optional: subscribe to reply notifications if backend sends replies to this destination
          _client!.subscribe(
            destination: '/user/queue/comment/reply',
            callback: (f) {
              final body = f.body;
              if (body == null || body.isEmpty) return;
              final json = jsonDecode(body);
              if (json is Map<String, dynamic>) {
                // For now we add to comment stream to show replies as comments
                _commentController.add(json);
              }
            },
          );
          // debug
          try {
            print('Subscribed to /user/queue/comment/reply');
          } catch (_) {}

          // Capture 'user-name' if provided by the server in CONNECTED headers
          try {
            final uname = frame.headers['user-name'];
            if (uname != null && uname.toString().isNotEmpty) {
              _selfId = uname.toString();
            }
          } catch (_) {}

          // If an active conversation was set before connect, subscribe to it now.
          final activeConversationId = _activeConversationId?.trim();
          if (activeConversationId != null && activeConversationId.isNotEmpty) {
            _chatSubscription = _subscribeConversationTopic(
              activeConversationId,
              onMessage: (message) => _chatController.add(message),
            );
            try {
              print('Subscribed to /topic/chat/$activeConversationId');
            } catch (_) {}
          }

          // We're connected now
          _connectionController.add(true);

          // Flush any queued messages (e.g., comments) that were stored while disconnected.
          if (_pendingMessages.isNotEmpty) {
            for (final msg
                in List<Map<String, String>>.from(_pendingMessages)) {
              try {
                _client!.send(
                  destination: msg['destination']!,
                  headers: {'content-type': 'application/json'},
                  body: msg['body']!,
                );
                _pendingMessages.remove(msg);
              } catch (e) {
                // Keep the message queued if it still cannot be sent.
                print('Failed to resend queued message: $e');
              }
            }
          }
        },

        onWebSocketError: (e) {
          onError?.call(e);
          _connectionController.add(false);
        },
        onStompError: (f) {
          onError?.call(f.body ?? f.headers);
          _connectionController.add(false);
        },
      ),
    );

    _client!.activate();
  }

  void disconnect() {
    unsubscribe(_chatSubscription);
    _chatSubscription = null;
    final c = _client;
    _client = null;
    c?.deactivate();
    _connectionController.add(false);
  }

  /// client gửi: /app/comment/new (backend @MessageMapping("/comment/new"))
  /// Attempts to send a new comment. Returns true if sent immediately, false otherwise.
  /// If the socket is unavailable or sending fails, the message is queued and retried on connect.
  Future<bool> sendNewComment({
    required String content,
    String? parentId,
  }) async {
    final c = _client;

    final body = jsonEncode({
      'content': content,
      'parentId': parentId,
    });

    // If there's no client yet or it's not connected, queue the message and return false.
    if (c == null || !c.connected) {
      _pendingMessages.add({
        'destination': '/app/comment/new',
        'body': body,
      });
      print('WS not connected (or not ready), queued message');
      return false;
    }

    try {
      // Try sending synchronously and catch immediate errors (like StompBadStateException)
      try {
        c.send(
          destination: '/app/comment/new',
          headers: {'content-type': 'application/json'},
          body: body,
        );
        return true;
      } catch (e, st) {
        // Synchronous send failed (likely because connection is not active) — queue for retry
        print('WS send sync error: $e\n$st');
        _pendingMessages.add({
          'destination': '/app/comment/new',
          'body': body,
        });
        return false;
      }
    } catch (e, st) {
      // Fallback: ensure no exception escapes
      print('WS send unexpected error: $e\n$st');
      _pendingMessages.add({
        'destination': '/app/comment/new',
        'body': body,
      });
      return false;
    }
  }

  /// Set active conversation: will subscribe to `/topic/chat/{conversationId}` when connected.
  void setActiveConversation(String conversationId) {
    if (_activeConversationId == conversationId) return;

    // try to unsubscribe previous subscription if we have it
    unsubscribe(_chatSubscription);
    _chatSubscription = null;

    _activeConversationId = conversationId;

    if (_client != null && _client!.connected) {
      _chatSubscription = _subscribeConversationTopic(
        conversationId,
        onMessage: (message) => _chatController.add(message),
      );
    }
  }

  /// Sends a chat message to `/app/chat/{conversationId}/send`.
  Future<bool> sendChatMessage({
    required String conversationId,
    required String content,
  }) async {
    final c = _client;
    final dest = '/app/chat/$conversationId/send';
    final body = jsonEncode({
      'conversationId': conversationId,
      'content': content,
    });

    if (c == null || !c.connected) {
      _pendingMessages.add({'destination': dest, 'body': body});
      print('WS not connected (or not ready), queued chat message');
      return false;
    }

    try {
      try {
        c.send(
          destination: dest,
          headers: {'content-type': 'application/json'},
          body: body,
        );
        return true;
      } catch (e, st) {
        print('WS send chat sync error: $e\n$st');
        _pendingMessages.add({'destination': dest, 'body': body});
        return false;
      }
    } catch (e, st) {
      print('WS send chat unexpected error: $e\n$st');
      _pendingMessages.add({'destination': dest, 'body': body});
      return false;
    }
  }

  Future<void> dispose() async {
    disconnect();
    await _commentController.close();
    await _notiController.close();
    await _chatController.close();
    await _connectionController.close();
  }
}
