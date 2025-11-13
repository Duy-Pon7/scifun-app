import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/features/exam/data/model/examset_model.dart';
import 'package:sci_fun/features/home/domain/entity/quizz_entity.dart';

abstract interface class ExamsetRepository {
  Future<Either<Failure, List<ExamsetModel>>> getExamsets({
    required int page,
  });
  Future<Either<Failure, QuizzEntity>> getQuizzExamsets(
      {required int examSetId, required int subjectId});
}
