import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sci_fun/common/models/chat_models.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/widget/app_loading_indicator.dart';
import 'package:sci_fun/core/services/chat_api_service.dart';
import 'package:sci_fun/core/services/realtime_service.dart';

class UserChatPage extends StatefulWidget {
  const UserChatPage({
    super.key,
    required this.apiBaseUrl,
    required this.wsUrl,
    required this.getToken,
  });

  final String apiBaseUrl;
  final String wsUrl;
  final Future<String?> Function() getToken;

  @override
  State<UserChatPage> createState() => _UserChatPageState();
}

class _UserChatPageState extends State<UserChatPage> {
  late final ChatApiService _api = ChatApiService(widget.apiBaseUrl);

  StreamSubscription? _wsSub;
  StreamSubscription? _connSub;

  final _text = TextEditingController();
  final _scrollCtrl = ScrollController();
  final _messages = <ChatMessage>[];

  String? _token;
  String? _conversationId;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  bool _isOwnMessage(ChatMessage message) {
    final myId = RealtimeService.I.selfId;
    if (myId != null && myId.isNotEmpty) {
      return message.senderId == myId;
    }
    return (message.senderRole ?? '').toUpperCase() == 'USER';
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

      final convId = await _api.openConversation(token: _token!);
      if (!mounted) return;
      _conversationId = convId;

      await RealtimeService.I.connect(
        wsUrl: widget.wsUrl,
        getToken: widget.getToken,
        onError: (e) => debugPrint('WS error: $e'),
      );

      _connSub = RealtimeService.I.connectionStream.listen((v) {
        if (!mounted) return;
        // Connection state is now handled internally by RealtimeService
      });

      RealtimeService.I.setActiveConversation(convId);

      _wsSub = RealtimeService.I.chatStream.listen((m) {
        if (!mounted) return;
        if (m.conversationId != _conversationId) return;
        final isMine = _isOwnMessage(m);

        setState(() {
          final existedById =
              m.id == null ? -1 : _messages.indexWhere((x) => x.id == m.id);
          if (existedById != -1) {
            _messages[existedById] = m;
            return;
          }

          final optimisticIdx = _findOptimisticIndex(m);
          if (optimisticIdx != -1) {
            _messages[optimisticIdx] = m;
            return;
          }

          // Skip self echoes when we already rendered optimistic message.
          if (isMine) return;

          _messages.add(m);
        });

        _scrollToBottom();
      });

      final history = await _api.getMessages(
        token: _token!,
        conversationId: convId,
        limit: 50,
      );

      if (!mounted) return;
      setState(() {
        _messages
          ..clear()
          ..addAll(history);
        _loading = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Init chat failed: $e')));
    }
  }

  void _scrollToBottom() {
    if (!_scrollCtrl.hasClients) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollCtrl.hasClients) return;
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send() async {
    final cid = _conversationId;
    final t = _text.text.trim();
    if (cid == null || t.isEmpty) return;

    final myId = RealtimeService.I.selfId;
    final optimistic = ChatMessage(
      id: 'local-${DateTime.now().millisecondsSinceEpoch}',
      conversationId: cid,
      senderId: myId,
      senderRole: 'USER',
      content: t,
      createdAt: DateTime.now(),
    );

    _text.clear();
    if (!mounted) return;
    setState(() {
      _messages.add(optimistic);
    });

    _scrollToBottom();

    // Fire-and-forget send; server echo will replace the optimistic message.
    await RealtimeService.I.sendChatMessage(
      conversationId: cid,
      content: t,
    );
  }

  @override
  void dispose() {
    _wsSub?.cancel();
    _connSub?.cancel();
    _text.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      appBar: BasicAppbar(
        title: "Hỗ trợ trực tuyến",
      ),
      body: _loading
          ? const Center(
              child: AppLoadingIndicator(message: 'Đang mở chat...'),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollCtrl,
                    padding: const EdgeInsets.all(12),
                    itemCount: _messages.length,
                    itemBuilder: (_, i) {
                      final m = _messages[i];
                      final isMe = _isOwnMessage(m);

                      return _ChatBubble(
                        isMe: isMe,
                        role: m.senderRole ?? (isMe ? 'USER' : 'ADMIN'),
                        content: m.content,
                        time: m.createdAt,
                      );
                    },
                  ),
                ),
                _ChatInput(
                  controller: _text,
                  onSend: _send,
                ),
              ],
            ),
    );
  }
}

/* -------------------- CHAT BUBBLE -------------------- */

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              role,
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

/* -------------------- INPUT -------------------- */

class _ChatInput extends StatelessWidget {
  const _ChatInput({
    required this.controller,
    required this.onSend,
  });

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
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(
                  hintText: 'Nhập tin nhắn...',
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
              backgroundColor: Colors.blue,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: onSend,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
