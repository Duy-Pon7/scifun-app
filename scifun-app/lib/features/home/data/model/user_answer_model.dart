import 'package:sci_fun/features/home/domain/entity/user_answer_entity.dart';

class UserAnswerModel extends UserAnswerEntity {
  UserAnswerModel({
    required super.questionId,
    required super.question,
    required super.userAnswerIds,
    required super.isCorrect,
    required super.textAnswer,
  });

  factory UserAnswerModel.fromJson(Map<String, dynamic> json) {
    return UserAnswerModel(
      questionId: json["question_id"] ?? 0,
      question: json["question"] ?? '',
      userAnswerIds: (json["user_answer_ids"] as List?)
              ?.where((x) => x != null)
              .map((x) => x as int)
              .toList() ??
          [],
      isCorrect: json["is_correct"] ?? false,
      textAnswer: json["text_answer"],
    );
  }

  static List<UserAnswerModel> fromListJson(List<dynamic> jsonList) {
    return jsonList
        .map((json) => UserAnswerModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
