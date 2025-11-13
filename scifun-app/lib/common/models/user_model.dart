import 'package:intl/intl.dart';
import 'package:thilop10_3004/common/entities/user.dart';
import 'package:thilop10_3004/common/models/province_model.dart';
import 'package:thilop10_3004/common/models/ward_model.dart';

class UserModel extends User {
  UserModel({
    required super.avatar,
    required super.status,
    required super.birthday,
    required super.fullname,
    required super.email,
    required super.phone,
    required super.id,
    required super.province,
    required super.ward,
    required super.gender,
    required super.package,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      fullname: json["fullname"] ?? json["name"],
      phone: json["phone"],
      gender: json["gender"],
      //! Lỗi JSON.
      province: json["province"] == null
          ? null
          : ProvinceModel.fromJson(json["province"]),
      ward: json["ward"] == null ? null : WardModel.fromJson(json["ward"]),
      email: json["email"],
      birthday: DateTime.tryParse(json["birthday"] ?? ""),
      avatar: json["avatar"] ?? json["image"],
      status: json["status"],
      package: json["package"] == null
          ? null
          : PackageModel.fromJson(json["package"]),
    );
  }
}

class PackageModel extends Package {
  PackageModel({
    required super.type,
    required super.endDate,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      type: json["type"],
      endDate: json["end_date"] != null
          ? DateFormat('dd-MM-yyyy HH:mm').parse(json["end_date"])
          : null,
    );
  }
}
