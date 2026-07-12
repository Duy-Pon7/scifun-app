import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/features/analytics/domain/entities/progress_stats_entity.dart';

abstract interface class ProgressStatsRepository {
  Future<Either<Failure, ProgressStatsEntity>> getProgressStats();
}
