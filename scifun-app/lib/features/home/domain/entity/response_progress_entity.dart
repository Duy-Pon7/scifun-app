import 'package:sci_fun/features/home/data/model/lesson_model.dart';
import 'package:sci_fun/features/home/data/model/progress_model.dart';

class ResponseProgressEntity {
  final ProgressModel progress;
  final List<LessonModel> lessons;

  ResponseProgressEntity({
    required this.progress,
    required this.lessons,
  });
}
