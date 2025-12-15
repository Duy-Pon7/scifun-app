import 'package:sci_fun/features/leaderboards/domain/entity/leaderboards_entity.dart';

class LeaderboardsModel extends LeaderboardsEntity {
  const LeaderboardsModel({
    required super.completedTopics,
    required super.previousRank,
    required super.userAvatar,
    required super.userName,
    required super.userId,
    required super.totalScore,
    required super.subjectId,
    required super.averageScore,
    required super.createdAt,
    required super.rank,
    required super.progress,
    required super.subjectName,
    required super.completedQuizzes,
  });

  @override
  LeaderboardsModel copyWith({
    int? completedTopics,
    int? previousRank,
    String? userAvatar,
    String? userName,
    String? userId,
    double? totalScore,
    String? subjectId,
    double? averageScore,
    DateTime? createdAt,
    int? rank,
    int? progress,
    String? subjectName,
    int? completedQuizzes,
  }) {
    return LeaderboardsModel(
      completedTopics: completedTopics ?? this.completedTopics,
      previousRank: previousRank ?? this.previousRank,
      userAvatar: userAvatar ?? this.userAvatar,
      userName: userName ?? this.userName,
      userId: userId ?? this.userId,
      totalScore: totalScore ?? this.totalScore,
      subjectId: subjectId ?? this.subjectId,
      averageScore: averageScore ?? this.averageScore,
      createdAt: createdAt ?? this.createdAt,
      rank: rank ?? this.rank,
      progress: progress ?? this.progress,
      subjectName: subjectName ?? this.subjectName,
      completedQuizzes: completedQuizzes ?? this.completedQuizzes,
    );
  }

  factory LeaderboardsModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardsModel(
      completedTopics: json["completedTopics"],
      previousRank: json["previousRank"],
      userAvatar: json["userAvatar"],
      userName: json["userName"],
      userId: json["userId"],
      totalScore: json["totalScore"],
      subjectId: json["subjectId"],
      averageScore: json["averageScore"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      rank: json["rank"],
      progress: (json["progress"] as num?)?.toInt() ?? 0,
      subjectName: json["subjectName"],
      completedQuizzes: json["completedQuizzes"],
    );
  }

  @override
  List<Object?> get props => [
        completedTopics,
        previousRank,
        userAvatar,
        userName,
        userId,
        totalScore,
        subjectId,
        averageScore,
        createdAt,
        rank,
        progress,
        subjectName,
        completedQuizzes,
      ];
}

class RebuildLeaderboardResult {
  final int notified;
  final int updated;
  final String period;
  final String subjectId;

  RebuildLeaderboardResult({
    required this.notified,
    required this.updated,
    required this.period,
    required this.subjectId,
  });

  factory RebuildLeaderboardResult.fromJson(Map<String, dynamic> json) {
    return RebuildLeaderboardResult(
      notified: json['notified'],
      updated: json['updated'],
      period: json['period'],
      subjectId: json['subjectId'],
    );
  }
}
