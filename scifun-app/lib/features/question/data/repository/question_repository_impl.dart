import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/features/question/data/datasource/question_remote_datasource.dart';
import 'package:sci_fun/features/question/domain/entity/question_entity.dart';
import 'package:sci_fun/features/question/domain/repository/question_repository.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  final QuestionRemoteDatasource questionRemoteDatasource;

  QuestionRepositoryImpl({required this.questionRemoteDatasource});

  @override
  Future<Either<Failure, QuestionsResponseEntity>> getAllQuestions({
    required String quizId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final res = await questionRemoteDatasource.getAllQuestions(
        quizId: quizId,
        page: page,
        limit: limit,
      );
      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}
