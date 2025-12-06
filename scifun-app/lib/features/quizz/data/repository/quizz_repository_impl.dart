import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/features/quizz/domain/repository/quizz_repository.dart';
import 'package:sci_fun/features/quizz/data/datasource/quizz_remote_datasource.dart';
import 'package:sci_fun/features/quizz/domain/entity/quizz_entity.dart';

class QuizzRepositoryImpl implements QuizzRepository {
  final QuizzRemoteDatasource quizzRemoteDatasource;

  QuizzRepositoryImpl({required this.quizzRemoteDatasource});

  @override
  Future<Either<Failure, List<QuizzEntity>>> getAllQuizzes(
    String? searchQuery, {
    required String topicId,
    required int page,
    required int limit,
  }) async {
    try {
      final res = await quizzRemoteDatasource.getQuizzes(
        searchQuery,
        topicId: topicId,
        page: page,
        limit: limit,
      );
      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}
