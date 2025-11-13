import 'package:sci_fun/features/home/data/model/category_subject_model.dart';
import 'package:sci_fun/features/home/data/model/question_model.dart';
import 'package:sci_fun/features/home/data/model/quizz_result_model.dart';
import 'package:sci_fun/features/home/domain/entity/quizz_entity.dart';

class QuizzModel extends QuizzEntity {
  QuizzModel({
    required super.id,
    required super.code,
    required super.name,
    required super.type,
    required super.categorySubject,
    required super.questions,
    required super.quizResult,
  });

  factory QuizzModel.fromJson(Map<String, dynamic> json) {
    return QuizzModel(
      id: json["id"],
      name: json["name"],
      code: json["code"],
      type: json["type"],
      categorySubject: json["category_subject"] == null
          ? null
          : CategorySubjectModel.fromJson(json["category_subject"]),
      questions: QuestionModel.fromListJson(json["questions"]),
      quizResult: json["quiz_result"] == null
          ? null
          : QuizzResultModel.fromJson(json["quiz_result"]),
    );
  }

  static List<QuizzModel> fromListJson(List<dynamic> jsonList) {
    return jsonList
        .map((json) => QuizzModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
