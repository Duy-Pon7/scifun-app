import 'package:equatable/equatable.dart';

class SubjectEntity extends Equatable {
  const SubjectEntity({
    required this.maxTopics,
    required this.name,
    required this.image,
    required this.description,
    required this.id,
  });

  final int? maxTopics;
  final String? name;
  final String? image;
  final String? description;
  final String? id;

  SubjectEntity copyWith({
    int? maxTopics,
    String? name,
    String? image,
    String? description,
    String? id,
  }) {
    return SubjectEntity(
      maxTopics: maxTopics ?? this.maxTopics,
      name: name ?? this.name,
      image: image ?? this.image,
      description: description ?? this.description,
      id: id ?? this.id,
    );
  }

  factory SubjectEntity.fromJson(Map<String, dynamic> json) {
    return SubjectEntity(
      maxTopics: json["maxTopics"],
      name: json["name"],
      image: json["image"],
      description: json["description"],
      id: json["_id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "maxTopics": maxTopics,
        "name": name,
        "image": image,
        "description": description,
        "_id": id,
      };

  @override
  List<Object?> get props => [
        maxTopics,
        name,
        image,
        description,
        id,
      ];
}
