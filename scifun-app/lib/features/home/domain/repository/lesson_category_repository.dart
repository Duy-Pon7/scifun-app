import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/features/home/domain/entity/response_lesson_category_entity.dart';

abstract interface class LessonCategoryRepository {
  Future<Either<Failure, ResponseLessonCategoryEntity>> getLessonCate({
    required int page,
    required int subjectId,
  });
}
