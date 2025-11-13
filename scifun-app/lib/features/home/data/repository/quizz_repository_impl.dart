import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/core/error/server_exception.dart';
import 'package:thilop10_3004/features/home/data/datasource/quizz_remote_datasource.dart';
import 'package:thilop10_3004/features/home/domain/entity/quizz_entity.dart';
import 'package:thilop10_3004/features/home/domain/entity/quizz_result_entity.dart';
import 'package:thilop10_3004/features/home/domain/entity/response_quizz_entity.dart';
import 'package:thilop10_3004/features/home/domain/repository/quizz_repository.dart';

class QuizzRepositoryImpl implements QuizzRepository {
  final QuizzRemoteDatasource quizzRemoteDatasource;

  QuizzRepositoryImpl({required this.quizzRemoteDatasource});

  @override
  Future<Either<Failure, List<QuizzResultEntity>>> getQuizzResult(
      {required int page, required int quizzId}) async {
    try {
      final res = await quizzRemoteDatasource.getQuizzResult(
          page: page, quizzId: quizzId);

      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, ResponseQuizzEntity>> getQuizzByCate(
      {required int page, required int cateId}) async {
    try {
      final res = await quizzRemoteDatasource.getQuizzByCate(
          page: page, cateId: cateId);

      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, ResponseQuizzEntity>> getQuizzByLesson(
      {required int page, required int lessonId}) async {
    try {
      final res = await quizzRemoteDatasource.getQuizzByLesson(
          page: page, lessonId: lessonId);

      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, QuizzEntity>> getQuizzDetail(
      {required int quizzId}) async {
    try {
      final res = await quizzRemoteDatasource.getQuizzDetail(quizzId: quizzId);

      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, QuizzEntity>> addQuizz(
      {required Map<String, dynamic> quizzParam}) async {
    try {
      final res = await quizzRemoteDatasource.addQuizz(quizzParam: quizzParam);

      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}
