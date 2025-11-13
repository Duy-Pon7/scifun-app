import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/features/home/data/datasource/lesson_category_remote_datasource.dart';
import 'package:sci_fun/features/home/domain/entity/response_lesson_category_entity.dart';
import 'package:sci_fun/features/home/domain/repository/lesson_category_repository.dart';

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
