import 'package:sci_fun/common/models/user_model.dart';

import '../../domain/entities/notification.dart';

class NotiModel extends Notification {
  NotiModel({
    required super.id,
    required super.title,
    required super.message,
    required super.status,
    required super.user,
    required super.createdAt,
  });
  factory NotiModel.fromJson(
    Map<String, dynamic> json, {
    required DateTime fallbackDate,
  }) {
    return NotiModel(
      id: json["id"] is int ? json["id"] : null,
      title: json["title"] is String ? json["title"] : null,
      message: json["message"] is String ? json["message"] : null,
      status: json["status"] is int ? json["status"] : null,
      user: json["user"] != null && json["user"] is Map<String, dynamic>
          ? UserModel.fromJson(json["user"])
          : null,
      createdAt: DateTime.tryParse(json["created_at"] ?? "") ?? fallbackDate,
    );
  }
}
