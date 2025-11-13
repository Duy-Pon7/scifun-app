import 'package:sci_fun/common/entities/address_entity.dart';
import 'package:sci_fun/common/entities/ward_entity.dart';
import 'package:equatable/equatable.dart';

// class User {
//   User({
//     required this.id,
//     required this.fullname,
//     required this.phone,
//     required this.gender,
//     required this.email,
//     required this.province,
//     required this.ward,
//     required this.birthday,
//     required this.avatar,
//     required this.status,
//     required this.package,
//   });

//   final int? id;
//   final String? fullname;
//   final String? email;
//   final String? phone;
//   final int? gender;
//   final ProvinceEntity? province;
//   final WardEntity? ward;
//   final DateTime? birthday;
//   final String? avatar;
//   final int? status;
//   final Package? package;

//   User copyWith({
//     int? id,
//     String? fullname,
//     String? email,
//     String? phone,
//     String? address,
//     int? gender,
//     ProvinceEntity? provinceId,
//     WardEntity? wardId,
//     DateTime? birthday,
//     String? avatar,
//     int? status,
//     Package? package,
//   }) =>
//       User(
//         id: id ?? this.id,
//         fullname: fullname ?? this.fullname,
//         email: email ?? this.email,
//         phone: phone ?? this.phone,
//         gender: gender ?? this.gender,
//         province: province ?? this.province,
//         ward: ward ?? this.ward,
//         birthday: birthday ?? this.birthday,
//         avatar: avatar ?? this.avatar,
//         status: status ?? this.status,
//         package: package ?? this.package,
//       );
// }

// class Package {
//   Package({
//     required this.type,
//     required this.endDate,
//   });
//   final String? type;
//   final DateTime? endDate;
// }

// NEW

class UserEntity extends Equatable {
  const UserEntity({
    required this.status,
    required this.message,
    required this.token,
    required this.data,
  });

  final int? status;
  final String? message;
  final String? token;
  final DataEntity? data;

  UserEntity copyWith({
    int? status,
    String? message,
    String? token,
    DataEntity? data,
  }) {
    return UserEntity(
      status: status ?? this.status,
      message: message ?? this.message,
      token: token ?? this.token,
      data: data ?? this.data,
    );
  }

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      status: json["status"],
      message: json["message"],
      token: json["token"],
      data: json["data"] == null ? null : DataEntity.fromJson(json["data"]),
    );
  }

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

class DataEntity extends Equatable {
  const DataEntity({
    required this.id,
    required this.email,
    required this.password,
    required this.fullname,
    required this.isVerified,
    required this.avatar,
    required this.role,
    required this.sex,
    required this.subscription,
    required this.dob,
    required this.v,
  });

  final String? id;
  final String? email;
  final String? password;
  final String? fullname;
  final bool? isVerified;
  final String? avatar;
  final String? role;
  final int? sex;
  final SubscriptionEntity? subscription;
  final DateTime? dob;
  final int? v;

  DataEntity copyWith({
    String? id,
    String? email,
    String? password,
    String? fullname,
    bool? isVerified,
    String? avatar,
    String? role,
    int? sex,
    SubscriptionEntity? subscription,
    DateTime? dob,
    int? v,
  }) {
    return DataEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      fullname: fullname ?? this.fullname,
      isVerified: isVerified ?? this.isVerified,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      sex: sex ?? this.sex,
      subscription: subscription ?? this.subscription,
      dob: dob ?? this.dob,
      v: v ?? this.v,
    );
  }

  factory DataEntity.fromJson(Map<String, dynamic> json) {
    return DataEntity(
      id: json["_id"],
      email: json["email"],
      password: json["password"],
      fullname: json["fullname"],
      isVerified: json["isVerified"],
      avatar: json["avatar"],
      role: json["role"],
      sex: json["sex"],
      subscription: json["subscription"] == null
          ? null
          : SubscriptionEntity.fromJson(json["subscription"]),
      dob: DateTime.tryParse(json["dob"] ?? ""),
      v: json["__v"],
    );
  }

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

class SubscriptionEntity extends Equatable {
  const SubscriptionEntity({
    required this.status,
    required this.tier,
    required this.currentPeriodEnd,
    required this.provider,
  });

  final String? status;
  final String? tier;
  final DateTime? currentPeriodEnd;
  final String? provider;

  SubscriptionEntity copyWith({
    String? status,
    String? tier,
    DateTime? currentPeriodEnd,
    String? provider,
  }) {
    return SubscriptionEntity(
      status: status ?? this.status,
      tier: tier ?? this.tier,
      currentPeriodEnd: currentPeriodEnd ?? this.currentPeriodEnd,
      provider: provider ?? this.provider,
    );
  }

  factory SubscriptionEntity.fromJson(Map<String, dynamic> json) {
    return SubscriptionEntity(
      status: json["status"],
      tier: json["tier"],
      currentPeriodEnd: DateTime.tryParse(json["currentPeriodEnd"] ?? ""),
      provider: json["provider"],
    );
  }

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
