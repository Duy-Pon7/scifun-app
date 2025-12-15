import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/features/leaderboards/data/model/leaderboards_model.dart';

abstract interface class LeaderboardRemoteDatasource {
  Future<List<LeaderboardsModel>> getLeaderboard({
    required String subjectId,
    int page,
    int limit,
    String period,
  });
  Future<RebuildLeaderboardResult> rebuildLeaderboard({
    required String subjectId,
  });
}

class LeaderboardRemoteDatasourceImpl implements LeaderboardRemoteDatasource {
  final DioClient dioClient;

  LeaderboardRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<List<LeaderboardsModel>> getLeaderboard({
    required String subjectId,
    int page = 1,
    int limit = 10,
    String period = 'alltime',
  }) async {
    try {
      print(
          'Fetching leaderboard: subjectId=$subjectId, page=$page, limit=$limit, period=$period');
      final res = await dioClient.get(
        url:
            "/leaderboards/list/$subjectId?page=$page&limit=$limit&period=$period",
      );

      if (res.statusCode == 200) {
        final List<dynamic> data = res.data['data'];

        return data
            .map((json) =>
                LeaderboardsModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load leaderboard: HTTP ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load leaderboard: $e');
    }
  }

  @override
  Future<RebuildLeaderboardResult> rebuildLeaderboard({
    required String subjectId,
  }) async {
    try {
      final res = await dioClient.post(
        url: "/leaderboards/rebuild/$subjectId",
      );

      print('Rebuild leaderboard response: ${res.data}');

      if (res.statusCode == 200) {
        return RebuildLeaderboardResult.fromJson(
          res.data['data'] as Map<String, dynamic>,
        );
      } else {
        throw Exception(
            'Failed to rebuild leaderboard: HTTP ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to rebuild leaderboard: $e');
    }
  }
}
