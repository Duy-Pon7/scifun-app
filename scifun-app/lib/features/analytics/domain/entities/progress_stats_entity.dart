import 'package:equatable/equatable.dart';

class ProgressStatsEntity extends Equatable {
  const ProgressStatsEntity({
    required this.day,
    required this.week,
    required this.month,
  });

  final List<ProgressStatsPeriodEntity> day;
  final List<ProgressStatsPeriodEntity> week;
  final List<ProgressStatsPeriodEntity> month;

  const ProgressStatsEntity.empty()
      : day = const [],
        week = const [],
        month = const [];

  ProgressStatsEntity copyWith({
    List<ProgressStatsPeriodEntity>? day,
    List<ProgressStatsPeriodEntity>? week,
    List<ProgressStatsPeriodEntity>? month,
  }) {
    return ProgressStatsEntity(
      day: day ?? this.day,
      week: week ?? this.week,
      month: month ?? this.month,
    );
  }

  Map<String, dynamic> toJson() => {
        'day': day.map((item) => item.toJson()).toList(),
        'week': week.map((item) => item.toJson()).toList(),
        'month': month.map((item) => item.toJson()).toList(),
      };

  @override
  List<Object?> get props => [day, week, month];
}

class ProgressStatsPeriodEntity extends Equatable {
  const ProgressStatsPeriodEntity({
    required this.periodLabel,
    required this.totalSubmissions,
    required this.completedQuizzes,
    required this.averageScore,
  });

  final String periodLabel;
  final int totalSubmissions;
  final int completedQuizzes;
  final double averageScore;

  ProgressStatsPeriodEntity copyWith({
    String? periodLabel,
    int? totalSubmissions,
    int? completedQuizzes,
    double? averageScore,
  }) {
    return ProgressStatsPeriodEntity(
      periodLabel: periodLabel ?? this.periodLabel,
      totalSubmissions: totalSubmissions ?? this.totalSubmissions,
      completedQuizzes: completedQuizzes ?? this.completedQuizzes,
      averageScore: averageScore ?? this.averageScore,
    );
  }

  Map<String, dynamic> toJson() => {
        'periodLabel': periodLabel,
        'totalSubmissions': totalSubmissions,
        'completedQuizzes': completedQuizzes,
        'averageScore': averageScore,
      };

  @override
  List<Object?> get props => [
        periodLabel,
        totalSubmissions,
        completedQuizzes,
        averageScore,
      ];
}
