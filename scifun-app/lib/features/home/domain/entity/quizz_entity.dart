import 'package:thilop10_3004/features/home/domain/entity/category_subject_entity.dart';
import 'package:thilop10_3004/features/home/domain/entity/question_entity.dart';
import 'package:thilop10_3004/features/home/domain/entity/quizz_result_entity.dart';

class QuizzEntity {
  final int? id;
  final String? code;
  final String? name;
  final String? type;
  final List<QuestionEntity>? questions;
  final CategorySubjectEntity? categorySubject;
  final QuizzResultEntity? quizResult;

  QuizzEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.type,
    required this.questions,
    required this.categorySubject,
    required this.quizResult,
  });
}
