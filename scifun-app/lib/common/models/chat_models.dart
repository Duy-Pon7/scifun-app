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
      j['admin'],
      j['adminInfo'],
      j['createdBy'],
      j['created_by'],
      j['user'],
      j['userInfo'],
      j['user_info'],
    ];

    for (final item in nestedCandidates) {
      final nested = _pickNameFromMap(item);
      if (nested != null) return nested;
    }

    return null;
  }

  factory ChatMessage.fromJson(Map<String, dynamic> j) {
    DateTime? dt;
    final raw = j['createdAt']?.toString();
    if (raw != null && raw.isNotEmpty) dt = DateTime.tryParse(raw);

    return ChatMessage(
      id: (j['id'] ?? j['_id'])?.toString(),
      conversationId: j['conversationId']?.toString(),
      senderId: j['senderId']?.toString(),
      senderRole: j['senderRole']?.toString(),
      senderName: _extractSenderName(j),
      content: (j['content'] ?? '').toString(),
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
    final raw = j['updatedAt']?.toString();
    if (raw != null && raw.isNotEmpty) dt = DateTime.tryParse(raw);

    return ConversationSummary(
      id: (j['id'] ?? j['_id'])?.toString() ?? '',
      userId: j['userId']?.toString(),
      status: j['status']?.toString(),
      updatedAt: dt,
    );
  }
}
