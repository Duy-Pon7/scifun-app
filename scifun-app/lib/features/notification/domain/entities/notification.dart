import 'package:sci_fun/common/entities/user_entity.dart';

class Notification {
  final int? id;
  final String? title;
  final String? message;
  final int? status;
  final UserEntity? user;
  final DateTime? createdAt;

  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.status,
    required this.user,
    required this.createdAt,
  });
}
