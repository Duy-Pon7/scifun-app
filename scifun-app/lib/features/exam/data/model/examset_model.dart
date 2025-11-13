import 'package:thilop10_3004/features/exam/domain/entity/examset_entity.dart';
import 'package:thilop10_3004/features/home/data/model/quizz_model.dart';

class ExamsetModel extends ExamsetEntity {
  ExamsetModel({
    required super.id,
    required super.title,
    required super.code,
    required super.status,
    required super.description,
    required super.quizzes,
  });
  factory ExamsetModel.fromJson(Map<String, dynamic> json) {
    return ExamsetModel(
      id: json['id'],
      code: json['code'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      quizzes: json["quizzes"] == null
          ? []
          : List<QuizzModel>.from(
              json["quizzes"]!.map((x) => QuizzModel.fromJson(x))),
    );
  }
}
