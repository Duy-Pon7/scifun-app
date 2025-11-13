import 'package:sci_fun/features/home/data/model/user_answer_model.dart';
import 'package:sci_fun/features/home/domain/entity/quizz_result_entity.dart';

class QuizzResultModel extends QuizzResultEntity {
  QuizzResultModel(
      {required super.id,
      required super.quizId,
      required super.correctAnswers,
      required super.totalQuestions,
      required super.answers,
      required super.createdAt,
      required super.updatedAt,
      required super.status,
      required super.score});

  factory QuizzResultModel.fromJson(Map<String, dynamic> json) {
    return QuizzResultModel(
      id: json["id"] ?? 0,
      quizId: json["quiz_id"] ?? 0,
      correctAnswers: json["correct_answers"] ?? 0,
      totalQuestions: json["total_questions"] ?? 0,
      answers: (json["answers"] as List<dynamic>?)
              ?.map((x) => UserAnswerModel.fromJson(x))
              .toList() ??
          [],
      score: json["score"] ?? 0,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      status: json["status"],
    );
  }
  static List<QuizzResultModel> fromListJson(List<dynamic> jsonList) {
    return jsonList
        .map((json) => QuizzResultModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
