import 'package:thilop10_3004/features/home/data/model/lesson_model.dart';
import 'package:thilop10_3004/features/home/domain/entity/response_lesson_entity.dart';

class ResponseLessonModel extends ResponseLessonEntity {
  ResponseLessonModel({required super.lessons});

  factory ResponseLessonModel.fromJson(Map<String, dynamic> json) {
    return ResponseLessonModel(
      lessons: LessonModel.fromListJson(json['lessons']),
    );
  }
}
