import 'package:thilop10_3004/features/home/data/model/lesson_model.dart';
import 'package:thilop10_3004/features/home/data/model/progress_model.dart';
import 'package:thilop10_3004/features/home/domain/entity/response_progress_entity.dart';

class ResponseProgressModel extends ResponseProgressEntity {
  ResponseProgressModel({
    required super.progress,
    required super.lessons,
  });

  factory ResponseProgressModel.fromJson(Map<String, dynamic> json) {
    return ResponseProgressModel(
      progress: ProgressModel.fromJson(json['progress']),
      lessons: (json['lessons'] as List)
          .map((e) => LessonModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
