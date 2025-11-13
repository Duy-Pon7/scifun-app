import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/core/error/server_exception.dart';
import 'package:thilop10_3004/features/home/data/datasource/lesson_remote_datasource.dart';
import 'package:thilop10_3004/features/home/data/model/response_lesson_model.dart';
import 'package:thilop10_3004/features/home/data/model/response_progress_model.dart';
import 'package:thilop10_3004/features/home/domain/entity/lesson_entity.dart';
import 'package:thilop10_3004/features/home/domain/repository/lesson_repository.dart';

class LessonRepositoryImpl implements LessonRepository {
  final LessonRemoteDatasource lessonRemoteDatasource;

  LessonRepositoryImpl({required this.lessonRemoteDatasource});
  @override
  Future<Either<Failure, ResponseProgressModel>> getListSubject({
    required int page,
    required int subjectId,
  }) async {
    try {
      final res = await lessonRemoteDatasource.getListSubject(
          page: page, subjectId: subjectId);

      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, ResponseLessonModel>> getListLesson({
    required int page,
    int? lessonCategoryId,
    String? keyWord,
  }) async {
    try {
      final res = await lessonRemoteDatasource.getListLesson(
          page: page, lessonCategoryId: lessonCategoryId, keyWord: keyWord);
      print(res.lessons);
      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, LessonEntity>> getLessonDetail(
      {required int lessonId}) async {
    try {
      final res =
          await lessonRemoteDatasource.getLessonDetail(lessonId: lessonId);

      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}
