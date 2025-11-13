import 'package:thilop10_3004/features/subject/domain/entity/subject_item_entity.dart';

class SubjectItemModel extends SubjectItemEntity {
  SubjectItemModel({
    required super.id,
    required super.name,
    required super.avatar,
  });

  factory SubjectItemModel.fromJson(Map<String, dynamic> json) {
    return SubjectItemModel(
      id: json['id'],
      name: json["name"],
      avatar: json["avatar"],
    );
  }

  static List<SubjectItemModel> fromListJson(List<dynamic> jsonList) {
    return jsonList
        .map((json) => SubjectItemModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
