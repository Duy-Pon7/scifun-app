import 'package:thilop10_3004/features/home/domain/entity/lesson_category_entity.dart';

class LessonCategoryModel extends LessonCategoryEntity {
  LessonCategoryModel({
    required super.id,
    required super.name,
    required super.description,
  });

  factory LessonCategoryModel.fromJson(Map<String, dynamic> json) {
    return LessonCategoryModel(
      id: json['id'],
      name: json["name"],
      description: json["description"],
    );
  }

  static List<LessonCategoryModel> fromListJson(List<dynamic> jsonList) {
    return jsonList
        .map((json) => LessonCategoryModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
