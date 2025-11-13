import 'package:sci_fun/features/home/data/model/lesson_category_model.dart';
import 'package:sci_fun/features/home/data/model/quizz_model.dart';
import 'package:sci_fun/features/home/data/model/quizz_result_model.dart';
import 'package:sci_fun/features/home/domain/entity/lesson_entity.dart';

class LessonModel extends LessonEntity {
  LessonModel({
    required super.id,
    required super.name,
    required super.level,
    required super.status,
    required super.content,
    required super.description,
    required super.link,
    required super.lessonCategory,
    required super.quizz,
    required super.isCompleted,
    required super.latestQuizResult,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json["id"],
      name: json["name"],
      level: json["level"],
      status: json["status"],
      content: json["content"],
      isCompleted: json["is_completed"],
      description: json["description"],
      link: json["link"],
      lessonCategory: json["lesson_category"] == null
          ? null
          : LessonCategoryModel.fromJson(json["lesson_category"]),
      quizz: json['quizzes'] != null
          ? QuizzModel.fromListJson(json['quizzes'])
          : [],
      latestQuizResult: json["latest_quiz_result"] == null
          ? null
          : QuizzResultModel.fromJson(json["latest_quiz_result"]),
    );
  }

  static List<LessonModel> fromListJson(List<dynamic> jsonList) {
    return jsonList
        .map((json) => LessonModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
