import 'package:thilop10_3004/features/home/domain/entity/progress_entity.dart';

class ProgressModel extends ProgressEntity {
  ProgressModel({
    required super.totalQuizzes,
    required super.completedQuizzes,
    required super.completionPercentage,
  });

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      totalQuizzes: json['total_quizzes'],
      completedQuizzes: json['completed_quizzes'],
      completionPercentage: json['completion_percentage'],
    );
  }
}
