class ChatMessage {
  final String? id;
  final String? conversationId;
  final String? senderId;
  final String? senderRole;
  final String? senderName;
  final String content;
  final DateTime? createdAt;

  ChatMessage({
    this.id,
    this.conversationId,
    this.senderId,
    this.senderRole,
    this.senderName,
    required this.content,
    this.createdAt,
  });

  static String? _asNonEmptyString(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static String? _pickNameFromMap(dynamic value) {
    if (value is! Map) return null;
    const keys = [
      'fullname',
      'fullName',
      'displayName',
      'name',
      'username',
      'userName',
      'nickName',
      'nickname',
    ];

    for (final k in keys) {
      final v = _asNonEmptyString(value[k]);
      if (v != null) return v;
    }

    return null;
  }

  static String? _pickConversationIdFromMap(dynamic value) {
    if (value is! Map) return null;

    const keys = [
      'conversationId',
      'conversation_id',
      'id',
      '_id',
      'chatId',
      'chat_id',
      'roomId',
      'room_id',
    ];

    for (final k in keys) {
      final v = _asNonEmptyString(value[k]);
      if (v != null) return v;
    }

    return null;
  }

  static String? _pickSenderIdFromMap(dynamic value) {
    if (value is! Map) return null;

    const keys = [
      'senderId',
      'sender_id',
      'id',
      '_id',
      'userId',
      'user_id',
      'uid',
      'sub',
    ];

    for (final k in keys) {
      final v = _asNonEmptyString(value[k]);
      if (v != null) return v;
    }

    return null;
  }

  static String? _pickSenderRoleFromMap(dynamic value) {
    if (value is! Map) return null;

    const keys = [
      'senderRole',
      'sender_role',
      'role',
    ];

    for (final k in keys) {
      final v = _asNonEmptyString(value[k]);
      if (v != null) return v;
    }

    return null;
  }

  static String? _pickUserIdFromMap(dynamic value) {
    if (value is! Map) return null;

    const keys = [
      'userId',
      'user_id',
      'id',
      '_id',
      'uid',
      'sub',
    ];

    for (final k in keys) {
      final v = _asNonEmptyString(value[k]);
      if (v != null) return v;
    }

    return null;
  }

  static String? _normalizeSenderRole(String? role) {
    final normalized = role?.trim().toUpperCase();
    if (normalized == null || normalized.isEmpty) return null;
    if (normalized == 'USER' || normalized == 'ROLE_USER') return 'USER';
    if (normalized == 'ADMIN' || normalized == 'ROLE_ADMIN') return 'ADMIN';
    return null;
  }

  static bool _looksLikeMessageMap(Map<String, dynamic> map) {
    return map.containsKey('content') ||
        map.containsKey('senderId') ||
        map.containsKey('sender_id') ||
        map.containsKey('senderRole') ||
        map.containsKey('sender_role') ||
        map.containsKey('conversationId') ||
        map.containsKey('conversation_id');
  }

  static Map<String, dynamic> _resolveMessagePayload(Map<String, dynamic> j) {
    if (_looksLikeMessageMap(j)) return j;

    final data = j['data'];
    if (data is Map<String, dynamic> && _looksLikeMessageMap(data)) {
      return data;
    }
    if (data is Map) {
      final cast = data.cast<String, dynamic>();
      if (_looksLikeMessageMap(cast)) return cast;
    }

    return j;
  }

  static String? _extractConversationId(Map<String, dynamic> j) {
    const directKeys = [
      'conversationId',
      'conversation_id',
      'chatId',
      'chat_id',
      'roomId',
      'room_id',
    ];

    for (final k in directKeys) {
      final value = _asNonEmptyString(j[k]);
      if (value != null) return value;
    }

    final nestedCandidates = [
      j['conversation'],
      j['chat'],
      j['room'],
    ];

    for (final item in nestedCandidates) {
      final nested = _pickConversationIdFromMap(item);
      if (nested != null) return nested;
    }

    return null;
  }

  static String? _extractSenderId(Map<String, dynamic> j) {
    const directKeys = [
      'senderId',
      'sender_id',
      'fromUserId',
      'from_user_id',
      'createdBy',
      'created_by',
    ];

    for (final k in directKeys) {
      final value = _asNonEmptyString(j[k]);
      if (value != null) return value;
    }

    final nestedCandidates = [
      j['sender'],
      j['senderInfo'],
      j['sender_info'],
      j['createdBy'],
      j['created_by'],
    ];

    for (final item in nestedCandidates) {
      final nested = _pickSenderIdFromMap(item);
      if (nested != null) return nested;
    }

    return null;
  }

  static String? _extractSenderRole(Map<String, dynamic> j) {
    const directKeys = [
      'senderRole',
      'sender_role',
    ];

    for (final k in directKeys) {
      final value = _normalizeSenderRole(_asNonEmptyString(j[k]));
      if (value != null) return value;
    }

    final nestedCandidates = [
      j['sender'],
      j['senderInfo'],
      j['sender_info'],
      j['createdBy'],
      j['created_by'],
    ];

    for (final item in nestedCandidates) {
      final nested = _normalizeSenderRole(_pickSenderRoleFromMap(item));
      if (nested != null) return nested;
    }

    return null;
  }

  static String? _extractSenderName(Map<String, dynamic> j) {
    const directKeys = [
      'senderName',
      'sender_name',
      'senderFullname',
      'sender_fullname',
      'senderDisplayName',
      'sender_display_name',
      'fullName',
      'fullname',
      'displayName',
    ];

    for (final k in directKeys) {
      final direct = _asNonEmptyString(j[k]);
      if (direct != null) return direct;
    }

    final nestedCandidates = [
      j['sender'],
      j['senderInfo'],
      j['sender_info'],
      j['createdBy'],
      j['created_by'],
    ];

    for (final item in nestedCandidates) {
      final nested = _pickNameFromMap(item);
      if (nested != null) return nested;
    }

    return null;
  }

  factory ChatMessage.fromJson(Map<String, dynamic> j) {
    final payload = _resolveMessagePayload(j);

    DateTime? dt;
    final raw = _asNonEmptyString(payload['createdAt']) ??
        _asNonEmptyString(payload['created_at']);
    if (raw != null && raw.isNotEmpty) dt = DateTime.tryParse(raw);

    return ChatMessage(
      id: _asNonEmptyString(payload['id']) ?? _asNonEmptyString(payload['_id']),
      conversationId: _extractConversationId(payload),
      senderId: _extractSenderId(payload),
      senderRole: _extractSenderRole(payload),
      senderName: _extractSenderName(payload),
      content: (payload['content'] ?? '').toString(),
      createdAt: dt,
    );
  }
}

class ConversationSummary {
  final String id;
  final String? userId;
  final String? status;
  final DateTime? updatedAt;

  ConversationSummary({
    required this.id,
    this.userId,
    this.status,
    this.updatedAt,
  });

  factory ConversationSummary.fromJson(Map<String, dynamic> j) {
    DateTime? dt;
    final raw = ChatMessage._asNonEmptyString(j['updatedAt']) ??
        ChatMessage._asNonEmptyString(j['updated_at']);
    if (raw != null && raw.isNotEmpty) dt = DateTime.tryParse(raw);

    return ConversationSummary(
      id: ChatMessage._asNonEmptyString(j['conversationId']) ??
          ChatMessage._asNonEmptyString(j['conversation_id']) ??
          ChatMessage._asNonEmptyString(j['id']) ??
          ChatMessage._asNonEmptyString(j['_id']) ??
          ChatMessage._asNonEmptyString(j['chatId']) ??
          ChatMessage._asNonEmptyString(j['chat_id']) ??
          ChatMessage._asNonEmptyString(j['roomId']) ??
          ChatMessage._asNonEmptyString(j['room_id']) ??
          '',
      userId: ChatMessage._asNonEmptyString(j['userId']) ??
          ChatMessage._asNonEmptyString(j['user_id']) ??
          ChatMessage._asNonEmptyString(j['uid']) ??
          ChatMessage._pickUserIdFromMap(j['user']),
      status: j['status']?.toString(),
      updatedAt: dt,
    );
  }
}
