import 'package:thilop10_3004/features/home/domain/entity/answer_entity.dart';

class AnswerModel extends AnswerEntity {
  AnswerModel({
    required super.id,
    required super.label,
    required super.answer,
    required super.type,
    required super.isCorrect,
    required super.group,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: json["id"],
      label: json["label"],
      answer: json["answer"],
      type: json["type"],
      isCorrect: json["is_correct"],
      group: json["group"],
    );
  }

  static List<AnswerModel> fromListJson(List<dynamic> jsonList) {
    return jsonList
        .map((json) => AnswerModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
