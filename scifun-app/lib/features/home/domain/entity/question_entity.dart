import 'package:sci_fun/features/home/domain/entity/answer_entity.dart';

class QuestionEntity {
  final int? id;
  final String? question;
  final String? questionType;
  final String? solution;
  final String? answerMode;
  final String? score;
  final List<AnswerEntity>? answers;

  QuestionEntity({
    required this.id,
    required this.question,
    required this.questionType,
    required this.solution,
    required this.answerMode,
    required this.score,
    required this.answers,
  });
}
