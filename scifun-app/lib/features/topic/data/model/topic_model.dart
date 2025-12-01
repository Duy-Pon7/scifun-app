import 'package:sci_fun/features/topic/domain/entity/topic_entity.dart';

class TopicModel extends TopicEntity {
  const TopicModel({
    required super.name,
    required super.description,
    required super.id,
    required super.subject,
    required super.image,
  });

  // @override
  // TopicModel copyWith({
  //   String? name,
  //   String? description,
  //   String? id,
  //   TopicModel? subject,
  //   String? image,
  // }) {
  //   return TopicModel(
  //     name: name ?? this.name,
  //     description: description ?? this.description,
  //     id: id ?? this.id,
  //     subject: subject ?? this.subject,
  //     image: image ?? this.image,
  //   );
  // }

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      name: json["name"],
      description: json["description"],
      id: json["_id"],
      subject:
          json["subject"] == null ? null : TopicModel.fromJson(json["subject"]),
      image: json["image"],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "_id": id,
        "subject": subject?.toJson(),
        "image": image,
      };

  @override
  List<Object?> get props => [
        name,
        description,
        id,
        subject,
        image,
      ];
}
