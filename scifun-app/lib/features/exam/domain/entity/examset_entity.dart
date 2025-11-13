import 'package:sci_fun/features/home/domain/entity/quizz_entity.dart';

class ExamsetEntity {
  final int id;
  final String code;
  final String title;
  final String description;
  final String status;
  final List<QuizzEntity> quizzes;

  ExamsetEntity({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.status,
    required this.quizzes,
  });
}
