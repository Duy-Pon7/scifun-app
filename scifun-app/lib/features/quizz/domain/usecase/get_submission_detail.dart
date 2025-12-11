import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/quizz/domain/repository/quizz_repository.dart';
import 'package:sci_fun/features/quizz/domain/entity/quizz_result_entity.dart';

class GetSubmissionDetail implements Usecase<QuizzResult, SubmissionParams> {
  final QuizzRepository quizzRepository;

  GetSubmissionDetail({required this.quizzRepository});

  @override
  Future<Either<Failure, QuizzResult>> call(SubmissionParams params) async {
    return await quizzRepository.getSubmissionDetail(params.submissionId);
  }
}

class SubmissionParams {
  final String submissionId;

  SubmissionParams(this.submissionId);
}
