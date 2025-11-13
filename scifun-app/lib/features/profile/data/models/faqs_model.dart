import 'package:thilop10_3004/features/profile/domain/entities/faqs_entity.dart';

class FaqsModel extends FaqsEntity {
  FaqsModel(
      {required super.id,
      required super.question,
      required super.answer,
      required super.status,
      });

  factory FaqsModel.fromJson(Map<String, dynamic> json) {
    return FaqsModel(
      id: json["id"],
      question: json["question"],
      answer: json["answer"],
      status: json["status"],
    );
  }
}
