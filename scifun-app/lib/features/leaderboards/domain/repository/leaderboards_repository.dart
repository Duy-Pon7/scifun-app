import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/features/leaderboards/domain/entity/leaderboards_entity.dart';

abstract interface class LeaderboardRepository {
  Future<Either<Failure, List<LeaderboardsEntity>>> getLeaderboard({
    required String subjectId,
    int page,
    int limit,
    String period,
  });

  Future<Either<Failure, RebuildLeaderboardResult>> rebuildLeaderboard({
    required String subjectId,
  });
}
