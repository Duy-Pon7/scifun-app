import 'package:flutter_test/flutter_test.dart';
import 'package:sci_fun/common/models/chat_models.dart';

void main() {
  group('ChatMessage.fromJson', () {
    test('parses explicit sender role USER/ADMIN', () {
      final user = ChatMessage.fromJson({
        'id': 'm1',
        'conversationId': 'c1',
        'senderId': 'u1',
        'senderRole': 'user',
        'content': 'alo',
      });

      final admin = ChatMessage.fromJson({
        'id': 'm2',
        'conversationId': 'c1',
        'senderId': 'a1',
        'senderRole': 'ADMIN',
        'content': 'xin chao',
      });

      expect(user.senderRole, 'USER');
      expect(admin.senderRole, 'ADMIN');
    });

    test('does not guess role from unrelated keys', () {
      final message = ChatMessage.fromJson({
        'id': 'm3',
        'conversationId': 'c1',
        'senderId': 'u1',
        'role': 'ADMIN',
        'userType': 'ADMIN',
        'content': 'hello',
      });

      expect(message.senderRole, isNull);
    });

    test('parses sender info from sender object', () {
      final message = ChatMessage.fromJson({
        'conversation': {'id': 'conv-9'},
        'sender': {
          'id': 'admin-9',
          'role': 'ADMIN',
          'displayName': 'Support Team',
        },
        'content': 'support reply',
      });

      expect(message.conversationId, 'conv-9');
      expect(message.senderId, 'admin-9');
      expect(message.senderRole, 'ADMIN');
      expect(message.senderName, 'Support Team');
    });

    test('parses wrapped payload in data map', () {
      final message = ChatMessage.fromJson({
        'data': {
          'id': 'm4',
          'conversationId': 'conv-4',
          'senderId': 'user-4',
          'senderRole': 'USER',
          'content': 'wrapped message',
          'created_at': '2026-03-20T08:44:47.542+00:00',
        }
      });

      expect(message.id, 'm4');
      expect(message.conversationId, 'conv-4');
      expect(message.senderId, 'user-4');
      expect(message.senderRole, 'USER');
      expect(message.createdAt, isNotNull);
    });
  });

  group('ConversationSummary.fromJson', () {
    test('uses conversation id fields for summary id', () {
      final summary = ConversationSummary.fromJson({
        'conversationId': 'conv-123',
        'userId': 'user-123',
      });

      expect(summary.id, 'conv-123');
      expect(summary.userId, 'user-123');
    });

    test('parses room type from supported keys', () {
      final summary = ConversationSummary.fromJson({
        'id': 'conv-200',
        'roomType': 'HUMAN',
      });

      expect(summary.id, 'conv-200');
      expect(summary.type, 'HUMAN');
    });
  });
}
