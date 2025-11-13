import 'package:thilop10_3004/common/entities/user.dart';

class Notification {
  final int? id;
  final String? title;
  final String? message;
  final int? status;
  final User? user;
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
