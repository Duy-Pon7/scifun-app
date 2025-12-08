import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/features/question/domain/entity/question_entity.dart';

abstract interface class QuestionRepository {
  Future<Either<Failure, QuestionsResponseEntity>> getAllQuestions({
    required String quizId,
    int page = 1,
    int limit = 10,
  });
}
