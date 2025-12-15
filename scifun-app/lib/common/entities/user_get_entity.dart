import 'package:equatable/equatable.dart';

/// =======================
/// User Entity (Root)
/// =======================
class UserGetEntity extends Equatable {
  const UserGetEntity({
    this.status,
    this.message,
    this.data,
  });

  final int? status;
  final String? message;
  final UserDataEntity? data;

  factory UserGetEntity.fromJson(Map<String, dynamic> json) {
    return UserGetEntity(
      status: json['status'],
      message: json['message'],
      data: json['data'] == null ? null : UserDataEntity.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };

  UserGetEntity copyWith({
    int? status,
    String? message,
    UserDataEntity? data,
  }) {
    return UserGetEntity(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [status, message, data];
}

/// =======================
/// User Data Entity
/// =======================
class UserDataEntity extends Equatable {
  const UserDataEntity({
    this.id,
    this.email,
    this.fullname,
    this.avatar,
    this.sex,
    this.dob,
    this.role,
    this.subscription,
  });

  final String? id;
  final String? email;
  final String? fullname;
  final String? avatar;
  final int? sex;
  final DateTime? dob;
  final String? role;
  final SubscriptionEntity? subscription;

  factory UserDataEntity.fromJson(Map<String, dynamic> json) {
    return UserDataEntity(
      id: json['id'],
      email: json['email'],
      fullname: json['fullname'],
      avatar: json['avatar'],
      sex: json['sex'],
      dob: DateTime.tryParse(json['dob'] ?? ''),
      role: json['role'],
      subscription: json['subscription'] == null
          ? null
          : SubscriptionEntity.fromJson(json['subscription']),
    );
  }

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

  UserDataEntity copyWith({
    String? id,
    String? email,
    String? fullname,
    String? avatar,
    int? sex,
    DateTime? dob,
    String? role,
    SubscriptionEntity? subscription,
  }) {
    return UserDataEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      fullname: fullname ?? this.fullname,
      avatar: avatar ?? this.avatar,
      sex: sex ?? this.sex,
      dob: dob ?? this.dob,
      role: role ?? this.role,
      subscription: subscription ?? this.subscription,
    );
  }

  @override
  List<Object?> get props =>
      [id, email, fullname, avatar, sex, dob, role, subscription];
}

/// =======================
/// Subscription Entity
/// =======================
class SubscriptionEntity extends Equatable {
  const SubscriptionEntity({
    this.status,
    this.tier,
    this.currentPeriodEnd,
    this.provider,
  });

  final String? status;
  final String? tier;
  final DateTime? currentPeriodEnd;
  final String? provider;

  factory SubscriptionEntity.fromJson(Map<String, dynamic> json) {
    return SubscriptionEntity(
      status: json['status'],
      tier: json['tier'],
      currentPeriodEnd: DateTime.tryParse(json['currentPeriodEnd'] ?? ''),
      provider: json['provider'],
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'tier': tier,
        'currentPeriodEnd': currentPeriodEnd?.toIso8601String(),
        'provider': provider,
      };

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

  @override
  List<Object?> get props => [status, tier, currentPeriodEnd, provider];
}
