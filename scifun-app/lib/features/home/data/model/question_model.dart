import 'package:thilop10_3004/features/home/data/model/answer_model.dart';
import 'package:thilop10_3004/features/home/domain/entity/question_entity.dart';

class QuestionModel extends QuestionEntity {
  QuestionModel({
    required super.id,
    required super.question,
    required super.questionType,
    required super.solution,
    required super.answerMode,
    required super.answers,
    required super.score,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json["id"],
      question: json["question"],
      questionType: json["question_type"],
      solution: json["solution"],
      answerMode: json["answer_mode"],
      score: json["score"],
      answers: AnswerModel.fromListJson(json["answers"]),
    );
  }

  static List<QuestionModel> fromListJson(List<dynamic> jsonList) {
    return jsonList
        .map((json) => QuestionModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
