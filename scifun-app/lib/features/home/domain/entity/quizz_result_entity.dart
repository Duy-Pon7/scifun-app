import 'package:sci_fun/features/home/domain/entity/user_answer_entity.dart';

class QuizzResultEntity {
  final int? id;
  final int? quizId;
  final int? correctAnswers;
  final int? totalQuestions;
  final int? score; // Thêm trường điểm
  final List<UserAnswerEntity>? answers;
  final DateTime? createdAt; // Thêm trường thời gian tạo
  final DateTime? updatedAt; // Thêm trường thời gian cập nhật
  final String? status;

  QuizzResultEntity({
    required this.id,
    required this.quizId,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.score,
    required this.answers,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });
}
