import 'package:sci_fun/common/entities/user_entity.dart';

// NEW
class UserModel extends UserEntity {
  const UserModel({
    required super.status,
    required super.message,
    required super.token,
    required super.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      status: json["status"],
      message: json["message"],
      token: json["token"],
      data: json["data"] == null ? null : DataModel.fromJson(json["data"]),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "token": token,
        "data": data?.toJson(),
      };

  @override
  List<Object?> get props => [
        status,
        message,
        token,
        data,
      ];
}

class DataModel extends DataEntity {
  const DataModel({
    required super.id,
    required super.email,
    required super.password,
    required super.fullname,
    required super.isVerified,
    required super.avatar,
    required super.role,
    required super.sex,
    required super.subscription,
    required super.dob,
    required super.v,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      id: json["id"] ?? json["_id"],
      email: json["email"],
      password: json["password"],
      fullname: json["fullname"],
      isVerified: json["isVerified"],
      avatar: json["avatar"],
      role: json["role"],
      sex: json["sex"],
      subscription: json["subscription"] == null
          ? null
          : SubscriptionModel.fromJson(json["subscription"]),
      dob: DateTime.tryParse(json["dob"] ?? ""),
      v: json["__v"],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "_id": id,
        "email": email,
        "password": password,
        "fullname": fullname,
        "isVerified": isVerified,
        "avatar": avatar,
        "role": role,
        "sex": sex,
        "subscription": subscription?.toJson(),
        "dob": dob?.toIso8601String(),
        "__v": v,
      };

  @override
  List<Object?> get props => [
        id,
        email,
        password,
        fullname,
        isVerified,
        avatar,
        role,
        sex,
        subscription,
        dob,
        v,
      ];
}

class SubscriptionModel extends SubscriptionEntity {
  const SubscriptionModel({
    required super.status,
    required super.tier,
    required super.currentPeriodEnd,
    required super.provider,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      status: json["status"],
      tier: json["tier"],
      currentPeriodEnd: DateTime.tryParse(json["currentPeriodEnd"] ?? ""),
      provider: json["provider"],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "status": status,
        "tier": tier,
        "currentPeriodEnd": currentPeriodEnd?.toIso8601String(),
        "provider": provider,
      };

  @override
  List<Object?> get props => [
        status,
        tier,
        currentPeriodEnd,
        provider,
      ];
}
