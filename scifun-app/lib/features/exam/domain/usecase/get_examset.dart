import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/features/exam/data/model/examset_model.dart';
import 'package:sci_fun/features/exam/domain/repository/examset_repository.dart';
import 'package:sci_fun/core/utils/usecase.dart';

class GetExamset implements Usecase<List<ExamsetModel>, PaginationParam<void>> {
  final ExamsetRepository repository;

  GetExamset(this.repository);

  @override
  Future<Either<Failure, List<ExamsetModel>>> call(
      PaginationParam<void> params) async {
    return await repository.getExamsets(
      page: params.page,
    );
  }
}
