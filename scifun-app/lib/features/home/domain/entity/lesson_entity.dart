import 'package:thilop10_3004/features/home/domain/entity/lesson_category_entity.dart';
import 'package:thilop10_3004/features/home/domain/entity/quizz_entity.dart';
import 'package:thilop10_3004/features/home/domain/entity/quizz_result_entity.dart';

class LessonEntity {
  final int? id;
  final String? name;
  final String? level;
  final String? status;
  final String? content;
  final String? description;
  final String? link;
  final LessonCategoryEntity? lessonCategory;
  final List<QuizzEntity> quizz;
  final bool? isCompleted;
  final QuizzResultEntity? latestQuizResult;

  LessonEntity({
    required this.id,
    required this.name,
    required this.level,
    required this.status,
    required this.content,
    required this.description,
    required this.link,
    required this.lessonCategory,
    required this.quizz,
    required this.isCompleted,
    required this.latestQuizResult,
  });
}
