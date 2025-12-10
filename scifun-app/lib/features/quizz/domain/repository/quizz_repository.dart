import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/features/quizz/domain/entity/quizz_entity.dart';

abstract interface class QuizzRepository {
  Future<Either<Failure, List<QuizzEntity>>> getAllQuizzes(
    String? searchQuery, {
    required String topicId,
    required int page,
    required int limit,
  });

  Future<Either<Failure, List<QuizzEntity>>> getTrendQuizzes();
}
