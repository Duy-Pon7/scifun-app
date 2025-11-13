import 'package:sci_fun/features/home/data/model/lesson_category_model.dart';
import 'package:sci_fun/features/home/domain/entity/response_lesson_category_entity.dart';

class ResponseLessonCategoryModel extends ResponseLessonCategoryEntity {
  ResponseLessonCategoryModel({required super.lessonCategories});

  factory ResponseLessonCategoryModel.fromJson(Map<String, dynamic> json) {
    return ResponseLessonCategoryModel(
      lessonCategories:
          LessonCategoryModel.fromListJson(json['lesson-categories']),
    );
  }
}
