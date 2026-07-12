import 'package:sci_fun/features/analytics/domain/entities/progress_stats_entity.dart';

class ProgressStatsModel extends ProgressStatsEntity {
  const ProgressStatsModel({
    required super.day,
    required super.week,
    required super.month,
  });

  factory ProgressStatsModel.fromJson(Map<String, dynamic> json) {
    return ProgressStatsModel(
      day: _parsePeriods(json['day']),
      week: _parsePeriods(json['week']),
      month: _parsePeriods(json['month']),
    );
  }

  static List<ProgressStatsPeriodModel> _parsePeriods(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map<String, dynamic>>()
        .map(ProgressStatsPeriodModel.fromJson)
        .toList();
  }
}

class ProgressStatsPeriodModel extends ProgressStatsPeriodEntity {
  const ProgressStatsPeriodModel({
    required super.periodLabel,
    required super.totalSubmissions,
    required super.completedQuizzes,
    required super.averageScore,
  });

  factory ProgressStatsPeriodModel.fromJson(Map<String, dynamic> json) {
    return ProgressStatsPeriodModel(
      periodLabel: (json['periodLabel'] ?? '').toString(),
      totalSubmissions: (json['totalSubmissions'] as num?)?.toInt() ?? 0,
      completedQuizzes: (json['completedQuizzes'] as num?)?.toInt() ?? 0,
      averageScore: (json['averageScore'] as num?)?.toDouble() ?? 0,
    );
  }
}
