import 'package:flutter_test/flutter_test.dart';
import 'package:sci_fun/features/comment/data/model/comment_model.dart';

void main() {
  test('CommentModel fromJson and toJson', () {
    final json = {
      'id': '69434c278015cdc1745b04b6',
      'userId': '69350cbc6a733272cc573a37',
      'userName': 'New User',
      'userAvatar':
          'https://res.cloudinary.com/dglm2f7sr/image/upload/v1761373988/default_awmzq0.jpg',
      'content': 'fnndd',
      'parentId': null,
      'repliesCount': 0,
      'createdAt': '2025-12-18T00:34:47.743+00:00',
      'updatedAt': '2025-12-18T00:34:47.743+00:00'
    };

    final model = CommentModel.fromJson(json);

    expect(model.id, '69434c278015cdc1745b04b6');
    expect(model.userName, 'New User');
    expect(model.repliesCount, 0);
    expect(model.createdAt?.toUtc().toIso8601String().startsWith('2025-12-18'),
        true);

    final toJson = model.toJson();
    expect(toJson['id'], json['id']);
    expect(toJson['userName'], json['userName']);
  });
}
