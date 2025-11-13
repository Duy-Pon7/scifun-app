import 'package:sci_fun/common/entities/user_check_entity.dart';

class UserCheckModel extends UserCheckEntity {
  UserCheckModel({
    required super.emailExists,
    required super.phoneExists,
    required super.type,
    required super.emailUser,
    required super.phoneUser,
  });

  factory UserCheckModel.fromJson(Map<String, dynamic> json) {
    return UserCheckModel(
      emailExists: json["email_exists"],
      phoneExists: json["phone_exists"],
      type: json["type"],
      emailUser: json["email_user"] == null
          ? null
          : UserCModel.fromJson(json["email_user"]),
      phoneUser: json["phone_user"] == null
          ? null
          : UserCModel.fromJson(json["phone_user"]),
    );
  }
}

class UserCModel extends UserC {
  UserCModel({
    required super.id,
    required super.fullname,
    required super.avatar,
    required super.email,
    required super.phone,
    required super.emailVerifiedAt,
  });

  factory UserCModel.fromJson(Map<String, dynamic> json) {
    return UserCModel(
      id: json["id"],
      fullname: json["fullname"],
      avatar: json["avatar"],
      email: json["email"],
      phone: json["phone"],
      emailVerifiedAt: DateTime.tryParse(json["email_verified_at"] ?? ""),
    );
  }
}
