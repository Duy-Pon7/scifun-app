class ChatMessage {
  final String? id;
  final String? conversationId;
  final String? senderId;
  final String? senderRole;
  final String content;
  final DateTime? createdAt;

  ChatMessage({
    this.id,
    this.conversationId,
    this.senderId,
    this.senderRole,
    required this.content,
    this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> j) {
    DateTime? dt;
    final raw = j['createdAt']?.toString();
    if (raw != null && raw.isNotEmpty) dt = DateTime.tryParse(raw);

    return ChatMessage(
      id: (j['id'] ?? j['_id'])?.toString(),
      conversationId: j['conversationId']?.toString(),
      senderId: j['senderId']?.toString(),
      senderRole: j['senderRole']?.toString(),
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
