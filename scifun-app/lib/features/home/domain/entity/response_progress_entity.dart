import 'package:thilop10_3004/features/home/data/model/lesson_model.dart';
import 'package:thilop10_3004/features/home/data/model/progress_model.dart';

class ResponseProgressEntity {
  final ProgressModel progress;
  final List<LessonModel> lessons;

  ResponseProgressEntity({
    required this.progress,
    required this.lessons,
  });
}
