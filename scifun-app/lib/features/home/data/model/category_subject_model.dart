import 'package:sci_fun/features/home/domain/entity/category_subject_entity.dart';

class CategorySubjectModel extends CategorySubjectEntity {
  CategorySubjectModel({
    required super.id,
    required super.name,
    required super.avatar,
    required super.type,
  });

  factory CategorySubjectModel.fromJson(Map<String, dynamic> json) {
    return CategorySubjectModel(
      id: json["id"],
      name: json["name"],
      avatar: json["avatar"],
      type: json["type"],
    );
  }
}
