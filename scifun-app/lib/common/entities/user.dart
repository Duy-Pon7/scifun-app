import 'package:thilop10_3004/common/entities/address_entity.dart';
import 'package:thilop10_3004/common/entities/ward_entity.dart';

class User {
  User({
    required this.id,
    required this.fullname,
    required this.phone,
    required this.gender,
    required this.email,
    required this.province,
    required this.ward,
    required this.birthday,
    required this.avatar,
    required this.status,
    required this.package,
  });

  final int? id;
  final String? fullname;
  final String? email;
  final String? phone;
  final int? gender;
  final ProvinceEntity? province;
  final WardEntity? ward;
  final DateTime? birthday;
  final String? avatar;
  final int? status;
  final Package? package;

  User copyWith({
    int? id,
    String? fullname,
    String? email,
    String? phone,
    String? address,
    int? gender,
    ProvinceEntity? provinceId,
    WardEntity? wardId,
    DateTime? birthday,
    String? avatar,
    int? status,
    Package? package,
  }) =>
      User(
        id: id ?? this.id,
        fullname: fullname ?? this.fullname,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        gender: gender ?? this.gender,
        province: province ?? this.province,
        ward: ward ?? this.ward,
        birthday: birthday ?? this.birthday,
        avatar: avatar ?? this.avatar,
        status: status ?? this.status,
        package: package ?? this.package,
      );
}

class Package {
  Package({
    required this.type,
    required this.endDate,
  });
  final String? type;
  final DateTime? endDate;
}
