import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/exam/domain/repository/examset_repository.dart';
import 'package:sci_fun/features/home/domain/entity/quizz_entity.dart';

class GetQuizzExamsets implements Usecase<QuizzEntity, QuizzParam> {
  final ExamsetRepository quizzRepository;

  GetQuizzExamsets({required this.quizzRepository});

  @override
  Future<Either<Failure, QuizzEntity>> call(QuizzParam param) async {
    return await quizzRepository.getQuizzExamsets(
      examSetId: param.examSetId,
      subjectId: param.subjectId,
    );
  }
}

class QuizzParam {
  final int examSetId;
  final int subjectId;

  QuizzParam({required this.examSetId, required this.subjectId});
}
