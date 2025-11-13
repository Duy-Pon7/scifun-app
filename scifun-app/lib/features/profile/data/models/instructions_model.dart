import 'package:thilop10_3004/features/profile/domain/entities/instructions_entity.dart';

class InstructionsModel extends InstructionsEntity {
  InstructionsModel({
    required super.id,
    required super.title,
    required super.content,
    required super.image,
    required super.position,
  });

  factory InstructionsModel.fromJson(Map<String, dynamic> json) {
    return InstructionsModel(
      id: json["id"],
      title: json["title"],
      content: json["content"],
      image: json["image"],
      position: json["position"],
    );
  }
}
