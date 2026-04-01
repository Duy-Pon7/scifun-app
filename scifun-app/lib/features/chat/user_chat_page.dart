import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
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

  StreamSubscription<ChatMessage>? _wsSub;
  StreamSubscription<bool>? _connSub;

  final _text = TextEditingController();
  final _scrollCtrl = ScrollController();
  final _messages = <ChatMessage>[];

  String? _token;
  String? _selfId;
  String? _conversationId;
  bool _isConnected = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _init();
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
      final id = data['userId'] ??
          data['user_id'] ??
          data['uid'] ??
          data['sub'] ??
          data['id'];
      if (id == null) return null;
      final value = id.toString().trim();
      return value.isEmpty ? null : value;
    } catch (_) {
      return null;
    }
  }

  String? _extractRoleFromToken(String token) {
    String? pickRole(dynamic value) {
      if (value == null) return null;
      if (value is Iterable) {
        for (final item in value) {
          final role = pickRole(item);
          if (role != null) return role;
        }
        return null;
      }
      if (value is Map) {
        const keys = ['role', 'authority', 'name', 'code', 'value', 'type'];
        for (final key in keys) {
          final role = pickRole(value[key]);
          if (role != null) return role;
        }
        return null;
      }
      return _normalizeRole(value.toString());
    }

    try {
      final parts = token.split('.');
      if (parts.length < 2) return null;
      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final data = jsonDecode(payload);
      if (data is! Map<String, dynamic>) return null;

      const keys = [
        'role',
        'roles',
        'authorities',
        'authority',
        'permissions',
        'permission',
        'scope',
        'scopes',
        'groups',
      ];
      for (final key in keys) {
        final role = pickRole(data[key]);
        if (role != null) return role;
      }
    } catch (_) {}

    return null;
  }

  String? get _myId {
    final id = _selfId?.trim();
    if (id != null && id.trim().isNotEmpty) return id.trim();
    final socketId = RealtimeService.I.selfId;
    if (socketId != null && socketId.trim().isNotEmpty) {
      return socketId.trim();
    }
    return null;
  }

  Set<String> get _myIds {
    final ids = <String>{};

    final tokenId = _selfId?.trim();
    if (tokenId != null && tokenId.isNotEmpty) {
      ids.add(tokenId);
    }

    final socketId = RealtimeService.I.selfId?.trim();
    if (socketId != null && socketId.isNotEmpty) {
      ids.add(socketId);
    }

    return ids;
  }

  String? _normalizeRole(String? role) {
    final normalized = role?.trim().toUpperCase();
    if (normalized == null || normalized.isEmpty) return null;

    if (normalized == 'ADMIN' ||
        normalized == 'ROLE_ADMIN' ||
        normalized == 'SUPER_ADMIN' ||
        normalized.contains('ADMIN')) {
      return 'ADMIN';
    }

    if (normalized == 'USER' ||
        normalized == 'ROLE_USER' ||
        normalized.contains('USER')) {
      return 'USER';
    }

    return null;
  }

  bool _isOwnMessage(ChatMessage message) {
    final senderId = message.senderId?.trim();
    if (senderId != null && senderId.isNotEmpty) {
      return _myIds.contains(senderId);
    }

    if (message.id?.startsWith('local-') == true &&
        _normalizeRole(message.senderRole) == 'USER') {
      return true;
    }

    return false;
  }

  ChatMessage _ensureConversationId(
      ChatMessage message, String conversationId) {
    if (message.conversationId == conversationId) return message;
    return ChatMessage(
      id: message.id,
      conversationId: conversationId,
      senderId: message.senderId,
      senderRole: message.senderRole,
      senderName: message.senderName,
      content: message.content,
      createdAt: message.createdAt,
    );
  }

  ChatMessage _mergeWithOptimistic(ChatMessage incoming, ChatMessage local) {
    return ChatMessage(
      id: incoming.id ?? local.id,
      conversationId: incoming.conversationId ?? local.conversationId,
      senderId: incoming.senderId ?? local.senderId,
      senderRole: incoming.senderRole ?? local.senderRole,
      senderName: incoming.senderName ?? local.senderName,
      content: incoming.content,
      createdAt: incoming.createdAt ?? local.createdAt,
    );
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

  void _appendIncomingMessage(ChatMessage message) {
    final existedById = message.id == null
        ? -1
        : _messages.indexWhere((x) => x.id == message.id);
    if (existedById != -1) {
      _messages[existedById] = message;
      return;
    }

    final optimisticIdx = _findOptimisticIndex(message);
    if (optimisticIdx != -1) {
      _messages[optimisticIdx] =
          _mergeWithOptimistic(message, _messages[optimisticIdx]);
      return;
    }

    // Skip self echoes when we already rendered optimistic message.
    if (_isOwnMessage(message)) return;

    _messages.add(message);
  }

  void _bindLiveMessageStream() {
    _wsSub?.cancel();
    _wsSub = RealtimeService.I.chatStream.listen((incoming) {
      if (!mounted) return;
      final activeConversationId = _conversationId;
      if (activeConversationId == null || activeConversationId.isEmpty) return;

      final incomingConversationId = incoming.conversationId?.trim();
      if (incomingConversationId != null &&
          incomingConversationId.isNotEmpty &&
          incomingConversationId != activeConversationId) {
        return;
      }

      final message = _ensureConversationId(incoming, activeConversationId);
      setState(() {
        _appendIncomingMessage(message);
      });
      _scrollToBottom();
    });
  }

  Future<void> _loadConversationHistory(String conversationId) async {
    final token = _token;
    if (token == null || token.isEmpty) return;

    final history = await _api.getMessages(
      token: token,
      conversationId: conversationId,
      limit: 50,
    );

    history.sort((a, b) {
      final at = a.createdAt;
      final bt = b.createdAt;
      if (at == null && bt == null) return 0;
      if (at == null) return -1;
      if (bt == null) return 1;
      return at.compareTo(bt);
    });

    if (!mounted || conversationId != _conversationId) return;
    setState(() {
      _messages
        ..clear()
        ..addAll(history);
      _loading = false;
    });
    _scrollToBottom();
  }

  bool _isSameMessageCluster(ChatMessage previous, ChatMessage current) {
    if (_isOwnMessage(previous) != _isOwnMessage(current)) return false;

    final prevTime = previous.createdAt;
    final currentTime = current.createdAt;

    if (prevTime == null || currentTime == null) return true;

    return currentTime.difference(prevTime).inMinutes.abs() <= 4;
  }

  String _senderLabel(ChatMessage message, bool isMe) {
    if (isMe) return 'B\u1ea1n';

    final role = _normalizeRole(message.senderRole);
    if (role == 'ADMIN') {
      final senderName = message.senderName?.trim();
      if (senderName != null && senderName.isNotEmpty) return senderName;

      final senderId = message.senderId?.trim();
      if (senderId != null && senderId.isNotEmpty) return senderId;
      return 'H\u1ed7 tr\u1ee3 vi\u00ean';
    }
    return 'Ng\u01b0\u1eddi d\u00f9ng';
  }

  Future<void> _init() async {
    await _connSub?.cancel();
    _connSub = null;
    await _wsSub?.cancel();
    _wsSub = null;

    try {
      _token = await widget.getToken();
      if (_token == null || _token!.isEmpty) {
        throw Exception('Missing token');
      }
      final role = _extractRoleFromToken(_token!);
      if (role == 'ADMIN') {
        throw Exception('Admin account cannot use user chat page');
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
        if (!connected) return;

        _selfId = _myId ?? _selfId;
        final cid = _conversationId;
        if (cid != null && cid.isNotEmpty) {
          RealtimeService.I.setActiveConversation(cid);
        }
      });

      _bindLiveMessageStream();

      final convId = await _api.openConversation(
        token: _token!,
        type: 'HUMAN',
      );

      if (!mounted) return;
      setState(() {
        _conversationId = convId;
      });

      // Subscribe first, then load history to avoid missing realtime messages.
      RealtimeService.I.setActiveConversation(convId);
      await _loadConversationHistory(convId);
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
    if (!_isConnected) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ket noi chat dang bi gian doan.')),
        );
      }
      return;
    }

    final cid = _conversationId;
    final t = _text.text.trim();
    if (cid == null || t.isEmpty) return;

    final myId = _myId;
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

    final sent = await RealtimeService.I.sendChatMessage(
      conversationId: cid,
      content: t,
    );
    if (!sent && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tin nhan duoc xep hang va se gui khi ket noi lai.'),
        ),
      );
    }
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
      backgroundColor: const Color(0xfff3f5fb),
      appBar: BasicAppbar(
        title: 'H\u1ed7 tr\u1ee3 tr\u1ef1c tuy\u1ebfn',
      ),
      body: _loading
          ? const Center(
              child: AppLoadingIndicator(message: '\u0110ang m\u1edf chat...'),
            )
          : Column(
              children: [
                Expanded(
                  child: _messages.isEmpty
                      ? const _EmptyChatState()
                      : ListView.builder(
                          controller: _scrollCtrl,
                          padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                          itemCount: _messages.length,
                          itemBuilder: (_, i) {
                            final m = _messages[i];
                            final isMe = _isOwnMessage(m);
                            final previous =
                                i > 0 ? _messages.elementAt(i - 1) : null;
                            final compactTop = previous != null &&
                                _isSameMessageCluster(previous, m);

                            return _ChatBubble(
                              isMe: isMe,
                              senderLabel: _senderLabel(m, isMe),
                              content: m.content,
                              time: m.createdAt,
                              compactTop: compactTop,
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
    required this.senderLabel,
    required this.content,
    required this.time,
    required this.compactTop,
  });

  final bool isMe;
  final String senderLabel;
  final String content;
  final DateTime? time;
  final bool compactTop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: compactTop ? 4 : 12, bottom: 4),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: isMe
                  ? const LinearGradient(
                      colors: [Color(0xff2d8ef0), Color(0xff1c75da)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isMe ? null : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(isMe ? 18 : 6),
                bottomRight: Radius.circular(isMe ? 6 : 18),
              ),
              border: isMe
                  ? null
                  : Border.all(
                      color: const Color(0xffdfe6f2),
                      width: 1,
                    ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (!compactTop) ...[
                    Text(
                      senderLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                        color: isMe
                            ? Colors.white.withValues(alpha: 0.84)
                            : const Color(0xff6a758a),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 17,
                      height: 1.35,
                      color: isMe ? Colors.white : const Color(0xff20232b),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatChatTime(time),
                    style: TextStyle(
                      fontSize: 11,
                      color: isMe
                          ? Colors.white.withValues(alpha: 0.7)
                          : const Color(0xff8f98aa),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyChatState extends StatelessWidget {
  const _EmptyChatState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Symbols.mark_chat_read_rounded,
              size: 52,
              color: Color(0xff9ba6bc),
            ),
            SizedBox(height: 10),
            Text(
              'B\u1eaft \u0111\u1ea7u \u0111o\u1ea1n chat v\u1edbi b\u1ed9 ph\u1eadn h\u1ed7 tr\u1ee3',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff4f5a70),
              ),
            ),
            SizedBox(height: 6),
            Text(
              'G\u1eedi tin nh\u1eafn \u0111\u1ec3 nh\u1eadn t\u01b0 v\u1ea5n nhanh h\u01a1n.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xff7d8799),
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
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
        decoration: const BoxDecoration(
          color: Color(0xfff8f9fd),
          boxShadow: [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 10,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xffdce3f0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => onSend(),
                  decoration: InputDecoration(
                    hintText: 'Nh\u1eadp tin nh\u1eafn...',
                    hintStyle: const TextStyle(color: Color(0xff9ba4b7)),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                final canSend = value.text.trim().isNotEmpty;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: canSend
                          ? const [Color(0xff2d8ef0), Color(0xff1c75da)]
                          : const [Color(0xffbfc9dc), Color(0xffaab5ca)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (canSend
                                ? const Color(0xff2d8ef0)
                                : const Color(0xff9eabc4))
                            .withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Symbols.send_rounded, color: Colors.white),
                    onPressed: canSend ? onSend : null,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

String _formatChatTime(DateTime? time) {
  if (time == null) return '';

  final local = time.toLocal();
  final now = DateTime.now();
  final hh = local.hour.toString().padLeft(2, '0');
  final mm = local.minute.toString().padLeft(2, '0');

  final isToday = local.year == now.year &&
      local.month == now.month &&
      local.day == now.day;

  if (isToday) return '$hh:$mm';

  final dd = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  return '$dd/$month $hh:$mm';
}
