import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:sci_fun/common/models/chat_models.dart';
import 'package:sci_fun/common/widget/app_loading_indicator.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/services/chat_api_service.dart';
import 'package:sci_fun/core/services/realtime_service.dart';

class AdminChatPage extends StatefulWidget {
  const AdminChatPage({
    super.key,
    required this.apiBaseUrl,
    required this.wsUrl,
    required this.getToken,
  });

  final String apiBaseUrl;
  final String wsUrl;
  final Future<String?> Function() getToken;

  @override
  State<AdminChatPage> createState() => _AdminChatPageState();
}

class _AdminChatPageState extends State<AdminChatPage> {
  late final ChatApiService _api = ChatApiService(widget.apiBaseUrl);

  final _text = TextEditingController();
  final _scrollCtrl = ScrollController();
  final _messages = <ChatMessage>[];
  final _conversations = <ConversationSummary>[];

  StreamSubscription<ChatMessage>? _wsSub;
  StreamSubscription<bool>? _connSub;

  String? _token;
  String? _activeConversationId;
  String? _selfId;
  String? _error;

  bool _loading = true;
  bool _loadingConversations = false;
  bool _loadingMessages = false;
  bool _sending = false;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _wsSub?.cancel();
    _connSub?.cancel();
    _text.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  String? _extractUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) return null;
      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final data = jsonDecode(payload);
      if (data is! Map<String, dynamic>) return null;
      final id = data['userId'] ?? data['sub'] ?? data['id'];
      if (id == null) return null;
      final value = id.toString().trim();
      return value.isEmpty ? null : value;
    } catch (_) {
      return null;
    }
  }

  String? get _myId {
    final id = RealtimeService.I.selfId;
    if (id != null && id.trim().isNotEmpty) return id.trim();
    return _selfId;
  }

  bool _isMine(ChatMessage message) {
    final myId = _myId;
    if (myId != null && myId.isNotEmpty) {
      return message.senderId == myId;
    }
    return (message.senderRole ?? '').toUpperCase() == 'ADMIN';
  }

  int _findOptimisticIndex(ChatMessage message) {
    return _messages.lastIndexWhere((item) {
      if (!(item.id?.startsWith('local-') ?? false)) return false;
      if (item.content != message.content) return false;

      if (item.createdAt == null || message.createdAt == null) {
        return true;
      }

      return item.createdAt!.difference(message.createdAt!).inSeconds.abs() <=
          10;
    });
  }

  Future<void> _init() async {
    try {
      _token = await widget.getToken();
      if (_token == null || _token!.isEmpty) {
        throw Exception('Missing token');
      }

      _selfId = _extractUserIdFromToken(_token!);

      await RealtimeService.I.connect(
        wsUrl: widget.wsUrl,
        getToken: widget.getToken,
        onError: (e) => debugPrint('WS error: $e'),
      );
      _isConnected = RealtimeService.I.isConnected;
      _selfId = _myId ?? _selfId;

      _connSub = RealtimeService.I.connectionStream.listen((connected) {
        if (!mounted) return;
        setState(() {
          _isConnected = connected;
        });
      });

      _wsSub = RealtimeService.I.chatStream.listen((message) {
        if (!mounted) return;
        if (message.conversationId != _activeConversationId) return;
        final isMine = _isMine(message);

        setState(() {
          final existedById = message.id == null
              ? -1
              : _messages.indexWhere((item) => item.id == message.id);
          if (existedById >= 0) {
            _messages[existedById] = message;
            return;
          }

          final optimisticIdx = _findOptimisticIndex(message);
          if (optimisticIdx >= 0) {
            _messages[optimisticIdx] = message;
            return;
          }

          // Skip self echoes when optimistic message is already shown.
          if (isMine) return;

          _messages.add(message);
        });
        _scrollToBottom();
      });

      await _loadConversations(selectFirst: true);
    } catch (e) {
      _error = 'Init admin chat failed: $e';
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _loadConversations({bool selectFirst = false}) async {
    final token = _token;
    if (token == null || token.isEmpty) return;

    if (mounted) {
      setState(() {
        _loadingConversations = true;
      });
    }

    try {
      final items = await _api.listConversations(token: token);
      if (!mounted) return;

      setState(() {
        _conversations
          ..clear()
          ..addAll(items);
      });

      final active = _activeConversationId;
      if (active != null && _conversations.every((e) => e.id != active)) {
        setState(() {
          _activeConversationId = null;
          _messages.clear();
        });
      }

      if (selectFirst &&
          _activeConversationId == null &&
          _conversations.isNotEmpty) {
        await _selectConversation(_conversations.first.id);
      }
    } catch (e) {
      if (!mounted) return;
      _showSnack('Load conversations failed: $e');
    } finally {
      if (mounted) {
        setState(() {
          _loadingConversations = false;
        });
      }
    }
  }

  Future<void> _selectConversation(String id) async {
    if (_activeConversationId == id) return;
    setState(() {
      _activeConversationId = id;
      _loadingMessages = true;
      _messages.clear();
    });
    RealtimeService.I.setActiveConversation(id);
    await _loadMessages(id);
  }

  Future<void> _loadMessages(String conversationId) async {
    final token = _token;
    if (token == null || token.isEmpty) return;

    try {
      final history = await _api.getMessages(
        token: token,
        conversationId: conversationId,
        limit: 100,
      );

      if (!mounted || conversationId != _activeConversationId) return;
      setState(() {
        _messages
          ..clear()
          ..addAll(history);
      });
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      _showSnack('Load messages failed: $e');
    } finally {
      if (mounted && conversationId == _activeConversationId) {
        setState(() {
          _loadingMessages = false;
        });
      }
    }
  }

  Future<void> _refreshAll() async {
    await _loadConversations();
    final active = _activeConversationId;
    if (active != null) {
      setState(() {
        _loadingMessages = true;
      });
      await _loadMessages(active);
    }
  }

  Future<void> _send() async {
    final cid = _activeConversationId;
    final text = _text.text.trim();
    if (cid == null || text.isEmpty || _sending) return;

    final optimistic = ChatMessage(
      id: 'local-${DateTime.now().millisecondsSinceEpoch}',
      conversationId: cid,
      senderId: _myId,
      senderRole: 'ADMIN',
      content: text,
      createdAt: DateTime.now(),
    );

    _text.clear();
    setState(() {
      _messages.add(optimistic);
      _sending = true;
    });
    _scrollToBottom();

    try {
      final sent = await RealtimeService.I.sendChatMessage(
        conversationId: cid,
        content: text,
      );
      if (!sent && mounted) {
        _showSnack('Tin nhắn được xếp hàng, sẽ gửi khi kết nối lại.');
      }
    } catch (e) {
      if (!mounted) return;
      _showSnack('Gửi tin nhắn thất bại: $e');
    } finally {
      if (mounted) {
        setState(() {
          _sending = false;
        });
      }
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  void _scrollToBottom() {
    if (!_scrollCtrl.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollCtrl.hasClients) return;
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  String _fmtConversation(ConversationSummary c) {
    final user = c.userId?.trim();
    if (user != null && user.isNotEmpty) {
      return user;
    }
    return c.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      appBar: BasicAppbar(
        title: 'Chat Admin',
      ),
      body: _loading
          ? const Center(
              child: AppLoadingIndicator(message: 'Dang mo chat admin...'),
            )
          : _error != null
              ? _AdminErrorView(
                  message: _error!,
                  onRetry: () {
                    setState(() {
                      _loading = true;
                      _error = null;
                    });
                    _init();
                  },
                )
              : Column(
                  children: [
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
                      child: Row(
                        children: [
                          Icon(
                            _isConnected
                                ? Symbols.cloud_done_rounded
                                : Symbols.cloud_off_rounded,
                            size: 18,
                            color: _isConnected
                                ? const Color(0xFF1E7A3B)
                                : const Color(0xFFAD6B00),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isConnected ? 'CONNECTED' : 'CONNECTING',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            tooltip: 'Reload',
                            onPressed: _refreshAll,
                            icon: const Icon(Symbols.refresh_rounded),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 96,
                      padding: const EdgeInsets.only(bottom: 8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(color: Color(0xFFE4E8EE)),
                        ),
                      ),
                      child: _loadingConversations
                          ? const Center(
                              child: SizedBox(
                                width: 22,
                                height: 22,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : _conversations.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Chưa có cuộc hội thoại',
                                    style: TextStyle(color: Color(0xFF6B7483)),
                                  ),
                                )
                              : ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  itemCount: _conversations.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 8),
                                  itemBuilder: (_, i) {
                                    final c = _conversations[i];
                                    final selected =
                                        c.id == _activeConversationId;
                                    return InkWell(
                                      onTap: () => _selectConversation(c.id),
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        width: 180,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: selected
                                              ? const Color(0xFFD8ECFF)
                                              : const Color(0xFFF3F5F8),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: selected
                                                ? const Color(0xFF2A84E1)
                                                : const Color(0xFFD5DCE6),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              _fmtConversation(c),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              c.id,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: Color(0xFF6B7483),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                    ),
                    Expanded(
                      child: _activeConversationId == null
                          ? const Center(
                              child: Text('Chọn một cuộc hội thoại để bắt đầu'),
                            )
                          : _loadingMessages
                              ? const Center(
                                  child: AppLoadingIndicator(
                                    message: 'Đang tải tin nhắn...',
                                  ),
                                )
                              : ListView.builder(
                                  controller: _scrollCtrl,
                                  padding: const EdgeInsets.all(12),
                                  itemCount: _messages.length,
                                  itemBuilder: (_, i) {
                                    final m = _messages[i];
                                    final isMe = _isMine(m);
                                    return _AdminChatBubble(
                                      isMe: isMe,
                                      role: m.senderRole ??
                                          (isMe ? 'ADMIN' : 'USER'),
                                      content: m.content,
                                      time: m.createdAt,
                                    );
                                  },
                                ),
                    ),
                    _AdminChatInput(
                      enabled: _activeConversationId != null,
                      controller: _text,
                      onSend: _send,
                    ),
                  ],
                ),
    );
  }
}

class _AdminErrorView extends StatelessWidget {
  const _AdminErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF575F6E)),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminChatBubble extends StatelessWidget {
  const _AdminChatBubble({
    required this.isMe,
    required this.role,
    required this.content,
    required this.time,
  });

  final bool isMe;
  final String role;
  final String content;
  final DateTime? time;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              role.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isMe ? Colors.white70 : Colors.black45,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              content,
              style: TextStyle(
                fontSize: 15,
                color: isMe ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time?.toLocal().toString().substring(0, 16) ?? '',
              style: TextStyle(
                fontSize: 10,
                color: isMe ? Colors.white54 : Colors.black38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminChatInput extends StatelessWidget {
  const _AdminChatInput({
    required this.enabled,
    required this.controller,
    required this.onSend,
  });

  final bool enabled;
  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                enabled: enabled,
                controller: controller,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(
                  hintText: enabled
                      ? 'Nhập tin nhắn cho user...'
                      : 'Chọn cuộc hội thoại...',
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color(0xfff1f3f6),
                ),
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 24,
              backgroundColor: enabled ? Colors.blue : const Color(0xFFB8C2D3),
              child: IconButton(
                icon: const Icon(Symbols.send_rounded, color: Colors.white),
                onPressed: enabled ? onSend : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
