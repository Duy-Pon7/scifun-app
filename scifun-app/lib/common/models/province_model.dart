import 'package:sci_fun/common/entities/address_entity.dart';

class ProvinceModel extends ProvinceEntity {
  ProvinceModel({
    required super.id,
    required super.name,
  });

  factory ProvinceModel.fromJson(Map<String, dynamic> json) {
    return ProvinceModel(
      id: int.tryParse(json['id'].toString()),
      name: json["name"],
    );
  }
  factory ProvinceModel.fromEntity(ProvinceEntity entity) {
    return ProvinceModel(
      id: entity.id,
      name: entity.name,
    );
  }
}
