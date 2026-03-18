import 'package:equatable/equatable.dart';

class TopicEntity extends Equatable {
  const TopicEntity({
    required this.name,
    required this.description,
    required this.id,
    required this.subject,
    required this.image,
    required this.level,
  });

  final String? name;
  final String? description;
  final String? id;
  final TopicEntity? subject;
  final String? image;
  final String? level;

  TopicEntity copyWith({
    String? name,
    String? description,
    String? id,
    TopicEntity? subject,
    String? image,
    String? level,
  }) {
    return TopicEntity(
      name: name ?? this.name,
      description: description ?? this.description,
      id: id ?? this.id,
      subject: subject ?? this.subject,
      image: image ?? this.image,
      level: level ?? this.level,
    );
  }

  factory TopicEntity.fromJson(Map<String, dynamic> json) {
    return TopicEntity(
      name: json["name"],
      description: json["description"],
      id: json["_id"],
      subject: json["subject"] == null
          ? null
          : TopicEntity.fromJson(json["subject"]),
      image: json["image"],
      level: json["level"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "_id": id,
        "subject": subject?.toJson(),
        "image": image,
        "level": level,
      };

  @override
  List<Object?> get props => [
        name,
        description,
        id,
        subject,
        image,
        level,
      ];
}
