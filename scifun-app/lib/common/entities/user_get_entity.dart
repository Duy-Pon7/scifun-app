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
    this.isGuest,
    this.daysRemaining,
    this.level,
    this.subscription,
  });

  static int? _resolvePositiveDaysFromDate(DateTime? date) {
    if (date == null) {
      return null;
    }

    final diffMs = date.toUtc().millisecondsSinceEpoch -
        DateTime.now().toUtc().millisecondsSinceEpoch;

    if (diffMs <= 0) {
      return 0;
    }

    return (diffMs / Duration.millisecondsPerDay).ceil();
  }

  static int? resolveDaysRemaining(Map<String, dynamic> json) {
    final apiDaysRemaining = (json['daysRemaining'] as num?)?.toInt();
    if (apiDaysRemaining != null) {
      return apiDaysRemaining < 0 ? 0 : apiDaysRemaining;
    }

    final isGuest = json['isGuest'] == true;
    if (!isGuest) {
      final subscription = json['subscription'];
      if (subscription is Map<String, dynamic>) {
        final subscriptionEnd = DateTime.tryParse(
          subscription['currentPeriodEnd']?.toString() ?? '',
        );
        return _resolvePositiveDaysFromDate(subscriptionEnd);
      }

      return null;
    }

    final rawExpiredAt = json['expiredAt']?.toString().trim();
    if (rawExpiredAt == null || rawExpiredAt.isEmpty) {
      return null;
    }

    final expiredAt = DateTime.tryParse(rawExpiredAt);
    return _resolvePositiveDaysFromDate(expiredAt);
  }

  final String? id;
  final String? email;
  final String? fullname;
  final String? avatar;
  final int? sex;
  final DateTime? dob;
  final String? role;
  final bool? isGuest;
  final int? daysRemaining;
  final String? level;
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
      isGuest: json['isGuest'] == true,
      daysRemaining: resolveDaysRemaining(json),
      level: json['level'],
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
        'isGuest': isGuest,
        'daysRemaining': daysRemaining,
        'level': level,
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
    bool? isGuest,
    int? daysRemaining,
    String? level,
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
      isGuest: isGuest ?? this.isGuest,
      daysRemaining: daysRemaining ?? this.daysRemaining,
      level: level ?? this.level,
      subscription: subscription ?? this.subscription,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        fullname,
        avatar,
        sex,
        dob,
        role,
        isGuest,
        daysRemaining,
        level,
        subscription,
      ];
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
