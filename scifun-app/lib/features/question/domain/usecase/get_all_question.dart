import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/question/domain/entity/question_entity.dart';
import 'package:sci_fun/features/question/domain/repository/question_repository.dart';

class GetAllQuestions
    implements Usecase<QuestionsResponseEntity, QuestionsParams> {
  final QuestionRepository questionRepository;

  GetAllQuestions({required this.questionRepository});

  @override
  Future<Either<Failure, QuestionsResponseEntity>> call(
      QuestionsParams params) async {
    return await questionRepository.getAllQuestions(
      quizId: params.quizId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class QuestionsParams {
  final String quizId;
  final int page;
  final int limit;

  QuestionsParams({
    required this.quizId,
    this.page = 1,
    this.limit = 10,
  });
}
