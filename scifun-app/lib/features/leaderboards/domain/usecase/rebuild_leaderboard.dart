import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/leaderboards/domain/entity/leaderboards_entity.dart';
import 'package:sci_fun/features/leaderboards/domain/repository/leaderboards_repository.dart';

class RebuildLeaderboard
    implements Usecase<RebuildLeaderboardResult, RebuildLeaderboardParams> {
  final LeaderboardRepository leaderboardRepository;

  RebuildLeaderboard({required this.leaderboardRepository});

  @override
  Future<Either<Failure, RebuildLeaderboardResult>> call(
    RebuildLeaderboardParams params,
  ) async {
    return await leaderboardRepository.rebuildLeaderboard(
      subjectId: params.subjectId,
    );
  }
}

class RebuildLeaderboardParams {
  final String subjectId;

  RebuildLeaderboardParams({required this.subjectId});
}
