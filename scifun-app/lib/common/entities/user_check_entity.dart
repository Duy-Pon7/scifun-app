class UserCheckEntity {
  UserCheckEntity({
    required this.emailExists,
    required this.phoneExists,
    required this.type,
    required this.emailUser,
    required this.phoneUser,
  });

  final bool? emailExists;
  final bool? phoneExists;
  final String? type;
  final UserC? emailUser;
  final UserC? phoneUser;
}

class UserC {
  UserC({
    required this.id,
    required this.fullname,
    required this.avatar,
    required this.email,
    required this.phone,
    required this.emailVerifiedAt,
  });

  final int? id;
  final String? fullname;
  final dynamic avatar;
  final String? email;
  final String? phone;
  final DateTime? emailVerifiedAt;
}
