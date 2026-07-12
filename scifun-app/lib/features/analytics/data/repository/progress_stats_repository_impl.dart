import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/features/analytics/data/datasource/progress_stats_remote_datasource.dart';
import 'package:sci_fun/features/analytics/domain/entities/progress_stats_entity.dart';
import 'package:sci_fun/features/analytics/domain/repository/progress_stats_repository.dart';

class ProgressStatsRepositoryImpl implements ProgressStatsRepository {
  ProgressStatsRepositoryImpl({required this.progressStatsRemoteDatasource});

  final ProgressStatsRemoteDatasource progressStatsRemoteDatasource;

  @override
  Future<Either<Failure, ProgressStatsEntity>> getProgressStats() async {
    try {
      final res = await progressStatsRemoteDatasource.getProgressStats();
      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}
