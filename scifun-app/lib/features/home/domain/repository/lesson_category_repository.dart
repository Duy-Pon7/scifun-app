import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/features/home/domain/entity/response_lesson_category_entity.dart';

abstract interface class LessonCategoryRepository{
  Future<Either<Failure, ResponseLessonCategoryEntity>> getLessonCate({required int page, required int subjectId,});
}