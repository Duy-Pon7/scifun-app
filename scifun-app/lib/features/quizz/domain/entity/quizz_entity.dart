import 'package:equatable/equatable.dart';
import 'package:sci_fun/features/topic/domain/entity/topic_entity.dart';

class QuizzEntity extends Equatable {
  const QuizzEntity({
    required this.duration,
    required this.questionCount,
    required this.accessTier,
    required this.description,
    required this.lastAttemptAt,
    required this.topic,
    required this.id,
    required this.title,
    required this.uniqueUserCount,
    required this.favoriteCount,
  });

  final int? duration;
  final int? questionCount;
  final String? accessTier;
  final String? description;
  final int? lastAttemptAt;
  final TopicEntity? topic;
  final String? id;
  final String? title;
  final int? uniqueUserCount;
  final int? favoriteCount;

  QuizzEntity copyWith({
    int? duration,
    int? questionCount,
    String? accessTier,
    String? description,
    int? lastAttemptAt,
    TopicEntity? topic,
    String? id,
    String? title,
    int? uniqueUserCount,
    int? favoriteCount,
  }) {
    return QuizzEntity(
      duration: duration ?? this.duration,
      questionCount: questionCount ?? this.questionCount,
      accessTier: accessTier ?? this.accessTier,
      description: description ?? this.description,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      topic: topic ?? this.topic,
      id: id ?? this.id,
      title: title ?? this.title,
      uniqueUserCount: uniqueUserCount ?? this.uniqueUserCount,
      favoriteCount: favoriteCount ?? this.favoriteCount,
    );
  }

  factory QuizzEntity.fromJson(Map<String, dynamic> json) {
    return QuizzEntity(
      duration: json["duration"],
      questionCount: json["questionCount"],
      accessTier: json["accessTier"],
      description: json["description"],
      lastAttemptAt: json["lastAttemptAt"],
      topic: json["topic"] == null ? null : TopicEntity.fromJson(json["topic"]),
      id: json["_id"],
      title: json["title"],
      uniqueUserCount: json["uniqueUserCount"],
      favoriteCount: json["favoriteCount"],
    );
  }

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
