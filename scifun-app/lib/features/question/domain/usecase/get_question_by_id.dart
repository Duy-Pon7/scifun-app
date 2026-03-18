import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/question/domain/entity/question_entity.dart';
import 'package:sci_fun/features/question/domain/repository/question_repository.dart';

class GetQuestionById implements Usecase<QuestionEntity, QuestionByIdParams> {
  final QuestionRepository questionRepository;

  GetQuestionById({required this.questionRepository});

  @override
  Future<Either<Failure, QuestionEntity>> call(
    QuestionByIdParams params,
  ) async {
    return await questionRepository.getQuestionById(
      questionId: params.questionId,
    );
  }
}

class QuestionByIdParams {
  final String questionId;

  const QuestionByIdParams({
    required this.questionId,
  });
}
