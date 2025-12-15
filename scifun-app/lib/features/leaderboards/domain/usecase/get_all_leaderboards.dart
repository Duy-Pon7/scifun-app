import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/leaderboards/domain/entity/leaderboards_entity.dart';
import 'package:sci_fun/features/leaderboards/domain/repository/leaderboards_repository.dart';

class GetLeaderboard
    implements Usecase<List<LeaderboardsEntity>, GetLeaderboardParams> {
  final LeaderboardRepository leaderboardRepository;

  GetLeaderboard({required this.leaderboardRepository});

  @override
  Future<Either<Failure, List<LeaderboardsEntity>>> call(
    GetLeaderboardParams params,
  ) async {
    return await leaderboardRepository.getLeaderboard(
      subjectId: params.subjectId,
      page: params.page,
      limit: params.limit,
      period: params.period,
    );
  }
}

class GetLeaderboardParams {
  final String subjectId;
  final int page;
  final int limit;
  final String period;

  GetLeaderboardParams({
    required this.subjectId,
    this.page = 1,
    this.limit = 10,
    this.period = 'alltime',
  });
}
