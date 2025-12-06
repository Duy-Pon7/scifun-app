import 'package:sci_fun/features/analytics/domain/entities/progress_entity.dart';

class ProgressModel extends ProgressEntity {
  const ProgressModel({
    required super.id,
    required super.userId,
    required super.subjectId,
    required super.subjectName,
    required super.progress,
    required super.totalTopics,
    required super.completedTopics,
    required super.totalQuizzes,
    required super.completedQuizzes,
    required super.averageScore,
    required super.topics,
    required super.lastUpdatedAt,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      id: json["id"],
      userId: json["userId"],
      subjectId: json["subjectId"],
      subjectName: json["subjectName"],
      progress: (json["progress"] as num?)?.toInt(),
      totalTopics: json["totalTopics"],
      completedTopics: json["completedTopics"],
      totalQuizzes: json["totalQuizzes"],
      completedQuizzes: json["completedQuizzes"],
      averageScore: (json["averageScore"] as num?)?.toInt(),
      topics: json["topics"] == null
          ? []
          : List<TopicModel>.from(
              json["topics"]!.map((x) => TopicModel.fromJson(x))),
      lastUpdatedAt: DateTime.tryParse(json["lastUpdatedAt"] ?? ""),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "subjectId": subjectId,
        "subjectName": subjectName,
        "progress": progress,
        "totalTopics": totalTopics,
        "completedTopics": completedTopics,
        "totalQuizzes": totalQuizzes,
        "completedQuizzes": completedQuizzes,
        "averageScore": averageScore,
        "topics": topics.map((x) => x.toJson()).toList(),
        "lastUpdatedAt": lastUpdatedAt?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        userId,
        subjectId,
        subjectName,
        progress,
        totalTopics,
        completedTopics,
        totalQuizzes,
        completedQuizzes,
        averageScore,
        topics,
        lastUpdatedAt,
        createdAt,
        updatedAt,
      ];
}

class TopicModel extends TopicEntity {
  const TopicModel({
    required super.topicId,
    required super.name,
    required super.progress,
    required super.totalQuizzes,
    required super.completedQuizzes,
    required super.averageScore,
    required super.quizzes,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      topicId: json["topicId"],
      name: json["name"],
      progress: (json["progress"] as num?)?.toInt(),
      totalQuizzes: json["totalQuizzes"],
      completedQuizzes: json["completedQuizzes"],
      averageScore: (json["averageScore"] as num?)?.toInt(),
      quizzes: json["quizzes"] == null
          ? []
          : List<dynamic>.from(json["quizzes"]!.map((x) => x)),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "topicId": topicId,
        "name": name,
        "progress": progress,
        "totalQuizzes": totalQuizzes,
        "completedQuizzes": completedQuizzes,
        "averageScore": averageScore,
        "quizzes": quizzes.map((x) => x).toList(),
      };

  @override
  List<Object?> get props => [
        topicId,
        name,
        progress,
        totalQuizzes,
        completedQuizzes,
        averageScore,
        quizzes,
      ];
}
