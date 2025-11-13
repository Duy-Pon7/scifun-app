import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/features/exam/data/model/examset_model.dart';
import 'package:thilop10_3004/features/home/domain/entity/quizz_entity.dart';

abstract interface class ExamsetRepository {
  Future<Either<Failure, List<ExamsetModel>>> getExamsets({
    required int page,
  });
  Future<Either<Failure, QuizzEntity>> getQuizzExamsets(
      {required int examSetId, required int subjectId});
}
