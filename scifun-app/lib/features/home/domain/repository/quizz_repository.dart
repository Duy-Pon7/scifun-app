import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/features/home/domain/entity/quizz_entity.dart';
import 'package:sci_fun/features/home/domain/entity/quizz_result_entity.dart';
import 'package:sci_fun/features/home/domain/entity/response_quizz_entity.dart';

abstract interface class QuizzRepository {
  Future<Either<Failure, List<QuizzResultEntity>>> getQuizzResult(
      {required int page, required int quizzId});
  Future<Either<Failure, ResponseQuizzEntity>> getQuizzByCate(
      {required int page, required int cateId});
  Future<Either<Failure, ResponseQuizzEntity>> getQuizzByLesson(
      {required int page, required int lessonId});

  Future<Either<Failure, QuizzEntity>> getQuizzDetail({required int quizzId});

  Future<Either<Failure, QuizzEntity>> addQuizz(
      {required Map<String, dynamic> quizzParam});
}
