import 'package:sci_fun/features/subject/domain/entity/subject_entity.dart';

class SubjectModel extends SubjectEntity {
  const SubjectModel({
    required super.maxTopics,
    required super.name,
    required super.image,
    required super.description,
    required super.id,
  });

  @override
  SubjectModel copyWith({
    int? maxTopics,
    String? name,
    String? image,
    String? description,
    String? id,
  }) {
    return SubjectModel(
      maxTopics: maxTopics ?? this.maxTopics,
      name: name ?? this.name,
      image: image ?? this.image,
      description: description ?? this.description,
      id: id ?? this.id,
    );
  }

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      maxTopics: json["maxTopics"],
      name: json["name"],
      image: json["image"],
      description: json["description"],
      id: json["_id"],
    );
  }

  @override
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
