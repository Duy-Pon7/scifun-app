import 'package:sci_fun/features/quizz/domain/entity/quizz_entity.dart';
import 'package:sci_fun/features/topic/data/model/topic_model.dart';

class QuizzModel extends QuizzEntity {
  const QuizzModel({
    required super.duration,
    required super.questionCount,
    required super.accessTier,
    required super.description,
    required super.lastAttemptAt,
    required super.topic,
    required super.id,
    required super.title,
    required super.uniqueUserCount,
    required super.favoriteCount,
  });

  factory QuizzModel.fromJson(Map<String, dynamic> json) {
    return QuizzModel(
      duration: (json["duration"] as num?)?.toInt(),
      questionCount: (json["questionCount"] as num?)?.toInt(),
      accessTier: json["accessTier"],
      description: json["description"],
      lastAttemptAt: json["lastAttemptAt"],
      topic: json["topic"] != null &&
              (json["topic"] as Map<String, dynamic>).isNotEmpty
          ? TopicModel.fromJson(json["topic"])
          : null,
      id: json["_id"],
      title: json["title"],
      uniqueUserCount: (json["uniqueUserCount"] as num?)?.toInt(),
      favoriteCount: (json["favoriteCount"] as num?)?.toInt(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "duration": duration,
        "questionCount": questionCount,
        "accessTier": accessTier,
        "description": description,
        "lastAttemptAt": lastAttemptAt,
        "topic": topic?.toJson(),
        "_id": id,
        "title": title,
        "uniqueUserCount": uniqueUserCount,
        "favoriteCount": favoriteCount,
      };

  @override
  List<Object?> get props => [
        duration,
        questionCount,
        accessTier,
        description,
        lastAttemptAt,
        topic,
        id,
        title,
        uniqueUserCount,
        favoriteCount,
      ];
}
