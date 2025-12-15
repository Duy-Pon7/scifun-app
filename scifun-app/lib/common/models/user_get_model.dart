import 'package:sci_fun/common/entities/user_get_entity.dart';

/// =======================
/// User Model
/// =======================
class UserGetModel extends UserGetEntity {
  const UserGetModel({
    super.status,
    super.message,
    UserDataModel? super.data,
  });

  factory UserGetModel.fromJson(Map<String, dynamic> json) {
    return UserGetModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] == null ? null : UserDataModel.fromJson(json['data']),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}

class UserDataModel extends UserDataEntity {
  const UserDataModel({
    super.id,
    super.email,
    super.fullname,
    super.avatar,
    super.sex,
    super.dob,
    super.role,
    SubscriptionModel? super.subscription,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      id: json['id'],
      email: json['email'],
      fullname: json['fullname'],
      avatar: json['avatar'],
      sex: json['sex'],
      dob: DateTime.tryParse(json['dob'] ?? ''),
      role: json['role'],
      subscription: json['subscription'] == null
          ? null
          : SubscriptionModel.fromJson(json['subscription']),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'fullname': fullname,
        'avatar': avatar,
        'sex': sex,
        'dob': dob?.toIso8601String(),
        'role': role,
        'subscription': subscription?.toJson(),
      };
}

class SubscriptionModel extends SubscriptionEntity {
  const SubscriptionModel({
    super.status,
    super.tier,
    super.currentPeriodEnd,
    super.provider,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      status: json['status'],
      tier: json['tier'],
      currentPeriodEnd: DateTime.tryParse(json['currentPeriodEnd'] ?? ''),
      provider: json['provider'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'status': status,
        'tier': tier,
        'currentPeriodEnd': currentPeriodEnd?.toIso8601String(),
        'provider': provider,
      };
}
