import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/question/domain/repository/question_repository.dart';

class SubmitQuiz implements Usecase<Map<String, dynamic>, SubmitQuizParams> {
  final QuestionRepository questionRepository;

  SubmitQuiz({required this.questionRepository});

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
      SubmitQuizParams params) async {
    return await questionRepository.submitQuizAnswers(
      userId: params.userId,
      quizId: params.quizId,
      answers: params.answers,
    );
  }
}

class SubmitQuizParams {
  final String userId;
  final String quizId;
  final List<Map<String, dynamic>> answers;

  SubmitQuizParams({
    required this.userId,
    required this.quizId,
    required this.answers,
  });
}
