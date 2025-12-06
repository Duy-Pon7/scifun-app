import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/features/analytics/domain/entities/progress_entity.dart';

abstract interface class ProgressRepository {
  Future<Either<Failure, ProgressEntity>> getProgress(String subjectId);
}
