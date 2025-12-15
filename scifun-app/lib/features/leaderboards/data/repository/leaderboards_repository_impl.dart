import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/features/leaderboards/data/datasource/leaderboards_remote_datasource.dart';
import 'package:sci_fun/features/leaderboards/data/model/leaderboards_model.dart'
    as model;
import 'package:sci_fun/features/leaderboards/domain/entity/leaderboards_entity.dart';
import 'package:sci_fun/features/leaderboards/domain/repository/leaderboards_repository.dart';

class LeaderboardRepositoryImpl implements LeaderboardRepository {
  final LeaderboardRemoteDatasource leaderboardRemoteDatasource;

  LeaderboardRepositoryImpl({
    required this.leaderboardRemoteDatasource,
  });

  @override
  Future<Either<Failure, List<LeaderboardsEntity>>> getLeaderboard({
    required String subjectId,
    int page = 1,
    int limit = 10,
    String period = 'alltime',
  }) async {
    try {
      final List<model.LeaderboardsModel> res =
          await leaderboardRemoteDatasource.getLeaderboard(
        subjectId: subjectId,
        page: page,
        limit: limit,
        period: period,
      );

      final List<LeaderboardsEntity> entities =
          res.map((m) => m as LeaderboardsEntity).toList();

      return Right(entities);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RebuildLeaderboardResult>> rebuildLeaderboard({
    required String subjectId,
  }) async {
    try {
      final model.RebuildLeaderboardResult res =
          await leaderboardRemoteDatasource.rebuildLeaderboard(
        subjectId: subjectId,
      );

      final RebuildLeaderboardResult result = RebuildLeaderboardResult(
        notified: res.notified,
        updated: res.updated,
        period: res.period,
        subjectId: res.subjectId,
      );

      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
