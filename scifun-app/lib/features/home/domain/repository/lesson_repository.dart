import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/features/home/domain/entity/lesson_entity.dart';
import 'package:sci_fun/features/home/domain/entity/response_lesson_entity.dart';
import 'package:sci_fun/features/home/domain/entity/response_progress_entity.dart';

abstract interface class LessonRepository {
  Future<Either<Failure, ResponseLessonEntity>> getListLesson({
    required int page,
    int? lessonCategoryId,
    String? keyWord,
  });
  Future<Either<Failure, ResponseProgressEntity>> getListSubject({
    required int page,
    required int subjectId,
  });
  Future<Either<Failure, LessonEntity>> getLessonDetail({
    required int lessonId,
  });
}
