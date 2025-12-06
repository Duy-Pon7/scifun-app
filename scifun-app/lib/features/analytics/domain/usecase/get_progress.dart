import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/analytics/domain/entities/progress_entity.dart';
import 'package:sci_fun/features/analytics/domain/repository/progress_repository.dart';

class GetProgress implements Usecase<ProgressEntity, ProgressParams> {
  final ProgressRepository progressRepository;

  GetProgress({required this.progressRepository});

  @override
  Future<Either<Failure, ProgressEntity>> call(ProgressParams params) async {
    return progressRepository.getProgress(params.subjectId);
  }
}

class ProgressParams {
  final String subjectId;

  ProgressParams({required this.subjectId});
}
