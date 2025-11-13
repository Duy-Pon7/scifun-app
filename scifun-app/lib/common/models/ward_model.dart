import 'package:sci_fun/common/entities/ward_entity.dart';

class WardModel extends WardEntity {
  WardModel({
    required super.id,
    required super.name,
  });

  factory WardModel.fromJson(Map<String, dynamic> json) {
    return WardModel(
      id: int.tryParse(json['id'].toString()),
      name: json["name"],
    );
  }
  factory WardModel.fromEntity(WardEntity entity) {
    return WardModel(
      id: entity.id,
      name: entity.name,
    );
  }
}
