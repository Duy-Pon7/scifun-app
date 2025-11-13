import 'package:thilop10_3004/features/profile/domain/entities/packages_entity.dart';

class PackagesModel extends PackagesEntity {
  PackagesModel(
      {required super.id,
      required super.name,
      required super.price,
      required super.description});

  factory PackagesModel.fromJson(Map<String, dynamic> json) {
    return PackagesModel(
      id: json["id"],
      name: json["name"],
      price: json["price"],
      description: json["description"] == null
          ? []
          : List<String>.from(json["description"]!.map((x) => x)),
    );
  }
}
