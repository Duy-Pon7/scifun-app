import 'dart:async';
import 'dart:convert';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class RealtimeService {
  RealtimeService._();
  static final RealtimeService I = RealtimeService._();

  StompClient? _client;

  final _commentController = StreamController<Map<String, dynamic>>.broadcast();
  final _notiController = StreamController<Map<String, dynamic>>.broadcast();

  // Connection status stream: true when STOMP connected, false otherwise.
  final _connectionController = StreamController<bool>.broadcast();

  // Queue messages when socket is not ready; they will be flushed on connect.
  final List<Map<String, String>> _pendingMessages = [];

  Stream<Map<String, dynamic>> get commentStream => _commentController.stream;
  Stream<Map<String, dynamic>> get notificationStream => _notiController.stream;
  Stream<bool> get connectionStream => _connectionController.stream;

  bool get isConnected => _client != null;

  /// wsUrl: wss://api.your.com/ws  (backend registerStompEndpoints: /ws)
  Future<void> connect({
    required String wsUrl,
    required Future<String?> Function() getToken,
    void Function(dynamic error)? onError,
  }) async {
    // Tránh activate nhiều lần
    if (_client != null) return;

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

    // If there's no client yet, queue the message and return false.
    if (c == null) {
      _pendingMessages.add({
        'destination': '/app/comment/new',
        'body': body,
      });
      print('WS not connected, queued message');
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

  Future<void> dispose() async {
    disconnect();
    await _commentController.close();
    await _notiController.close();
    await _connectionController.close();
  }
}
