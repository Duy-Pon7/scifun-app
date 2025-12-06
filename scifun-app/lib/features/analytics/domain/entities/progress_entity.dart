import 'package:equatable/equatable.dart';

class ProgressEntity extends Equatable {
  const ProgressEntity({
    required this.id,
    required this.userId,
    required this.subjectId,
    required this.subjectName,
    required this.progress,
    required this.totalTopics,
    required this.completedTopics,
    required this.totalQuizzes,
    required this.completedQuizzes,
    required this.averageScore,
    required this.topics,
    required this.lastUpdatedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? userId;
  final String? subjectId;
  final String? subjectName;
  final int? progress;
  final int? totalTopics;
  final int? completedTopics;
  final int? totalQuizzes;
  final int? completedQuizzes;
  final int? averageScore;
  final List<TopicEntity> topics;
  final DateTime? lastUpdatedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProgressEntity copyWith({
    String? id,
    String? userId,
    String? subjectId,
    String? subjectName,
    int? progress,
    int? totalTopics,
    int? completedTopics,
    int? totalQuizzes,
    int? completedQuizzes,
    int? averageScore,
    List<TopicEntity>? topics,
    DateTime? lastUpdatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProgressEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      progress: progress ?? this.progress,
      totalTopics: totalTopics ?? this.totalTopics,
      completedTopics: completedTopics ?? this.completedTopics,
      totalQuizzes: totalQuizzes ?? this.totalQuizzes,
      completedQuizzes: completedQuizzes ?? this.completedQuizzes,
      averageScore: averageScore ?? this.averageScore,
      topics: topics ?? this.topics,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ProgressEntity.fromJson(Map<String, dynamic> json) {
    return ProgressEntity(
      id: json["id"],
      userId: json["userId"],
      subjectId: json["subjectId"],
      subjectName: json["subjectName"],
      progress: json["progress"],
      totalTopics: json["totalTopics"],
      completedTopics: json["completedTopics"],
      totalQuizzes: json["totalQuizzes"],
      completedQuizzes: json["completedQuizzes"],
      averageScore: json["averageScore"],
      topics: json["topics"] == null
          ? []
          : List<TopicEntity>.from(
              json["topics"]!.map((x) => TopicEntity.fromJson(x))),
      lastUpdatedAt: DateTime.tryParse(json["lastUpdatedAt"] ?? ""),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

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

class TopicEntity extends Equatable {
  const TopicEntity({
    required this.topicId,
    required this.name,
    required this.progress,
    required this.totalQuizzes,
    required this.completedQuizzes,
    required this.averageScore,
    required this.quizzes,
  });

  final String? topicId;
  final String? name;
  final int? progress;
  final int? totalQuizzes;
  final int? completedQuizzes;
  final int? averageScore;
  final List<dynamic> quizzes;

  TopicEntity copyWith({
    String? topicId,
    String? name,
    int? progress,
    int? totalQuizzes,
    int? completedQuizzes,
    int? averageScore,
    List<dynamic>? quizzes,
  }) {
    return TopicEntity(
      topicId: topicId ?? this.topicId,
      name: name ?? this.name,
      progress: progress ?? this.progress,
      totalQuizzes: totalQuizzes ?? this.totalQuizzes,
      completedQuizzes: completedQuizzes ?? this.completedQuizzes,
      averageScore: averageScore ?? this.averageScore,
      quizzes: quizzes ?? this.quizzes,
    );
  }

  factory TopicEntity.fromJson(Map<String, dynamic> json) {
    return TopicEntity(
      topicId: json["topicId"],
      name: json["name"],
      progress: json["progress"],
      totalQuizzes: json["totalQuizzes"],
      completedQuizzes: json["completedQuizzes"],
      averageScore: json["averageScore"],
      quizzes: json["quizzes"] == null
          ? []
          : List<dynamic>.from(json["quizzes"]!.map((x) => x)),
    );
  }

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
