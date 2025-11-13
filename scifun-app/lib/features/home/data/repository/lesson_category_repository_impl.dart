import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/core/error/server_exception.dart';
import 'package:thilop10_3004/features/home/data/datasource/lesson_category_remote_datasource.dart';
import 'package:thilop10_3004/features/home/domain/entity/response_lesson_category_entity.dart';
import 'package:thilop10_3004/features/home/domain/repository/lesson_category_repository.dart';

class LessonCategoryRepositoryImpl implements LessonCategoryRepository {
  final LessonCategoryRemoteDatasource lessonCategoryRemoteDatasource;

  LessonCategoryRepositoryImpl({required this.lessonCategoryRemoteDatasource});

  @override
  Future<Either<Failure, ResponseLessonCategoryEntity>> getLessonCate({
    required int page,
    required int subjectId,
  }) async {
    try {
      final res = await lessonCategoryRemoteDatasource.getLessonCate(
          page: page, subjectId: subjectId);

      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}
