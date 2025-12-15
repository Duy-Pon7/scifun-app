import 'package:equatable/equatable.dart';

class LeaderboardsEntity extends Equatable {
  const LeaderboardsEntity({
    required this.completedTopics,
    required this.previousRank,
    required this.userAvatar,
    required this.userName,
    required this.userId,
    required this.totalScore,
    required this.subjectId,
    required this.averageScore,
    required this.createdAt,
    required this.rank,
    required this.progress,
    required this.subjectName,
    required this.completedQuizzes,
  });

  final int? completedTopics;
  final int? previousRank;
  final String? userAvatar;
  final String? userName;
  final String? userId;
  final double? totalScore;
  final String? subjectId;
  final double? averageScore;
  final DateTime? createdAt;
  final int? rank;
  final int? progress;
  final String? subjectName;
  final int? completedQuizzes;

  LeaderboardsEntity copyWith({
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
    return LeaderboardsEntity(
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
