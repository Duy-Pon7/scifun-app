import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/question/domain/repository/question_repository.dart';

class GetSubmissionDetail
    implements Usecase<Map<String, dynamic>, GetSubmissionDetailParams> {
  final QuestionRepository questionRepository;

  GetSubmissionDetail({required this.questionRepository});

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
      GetSubmissionDetailParams params) async {
    return await questionRepository.getSubmissionDetail(
      submissionId: params.submissionId,
    );
  }
}

class GetSubmissionDetailParams {
  final String submissionId;

  GetSubmissionDetailParams({
    required this.submissionId,
  });
}
