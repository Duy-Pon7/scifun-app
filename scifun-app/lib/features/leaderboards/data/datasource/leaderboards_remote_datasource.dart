import 'package:dio/dio.dart';
import 'package:sci_fun/common/helper/log_debug.dart';
import 'package:sci_fun/core/error/server_exception.dart';
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
    const source = 'LeaderboardRemoteDatasource.getLeaderboard';
    try {
      final res = await dioClient.get(
        url:
            '/leaderboards/list/$subjectId?page=$page&limit=$limit&period=$period',
      );

      if (res.statusCode == 200) {
        final List<dynamic> data = res.data['data'];
        final leaderboard = data
            .map((json) =>
                LeaderboardsModel.fromJson(json as Map<String, dynamic>))
            .toList();
        logApiSuccess(
          source: source,
          data: {
            'subjectId': subjectId,
            'period': period,
            'count': leaderboard.length,
            'response': res.data,
          },
        );
        return leaderboard;
      }

      final message = 'Failed to load leaderboard: HTTP ${res.statusCode}';
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'subjectId': subjectId,
          'period': period,
          'statusCode': res.statusCode,
          'response': res.data,
        },
      );
      throw ServerException(message: message);
    } on DioException catch (e) {
      final message = e.response?.data is Map<String, dynamic>
          ? (e.response?.data['message']?.toString() ??
              'Failed to load leaderboard')
          : 'Failed to load leaderboard';
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'subjectId': subjectId,
          'period': period,
          'error': e.toString(),
          'response': e.response?.data,
        },
      );
      throw ServerException(message: message);
    } catch (e) {
      final message = 'Failed to load leaderboard: $e';
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'subjectId': subjectId,
          'period': period,
          'error': e.toString(),
        },
      );
      throw ServerException(message: message);
    }
  }

  @override
  Future<RebuildLeaderboardResult> rebuildLeaderboard({
    required String subjectId,
  }) async {
    const source = 'LeaderboardRemoteDatasource.rebuildLeaderboard';
    try {
      final res = await dioClient.post(url: '/leaderboards/rebuild/$subjectId');

      if (res.statusCode == 200) {
        final result = RebuildLeaderboardResult.fromJson(
          res.data['data'] as Map<String, dynamic>,
        );
        logApiSuccess(
          source: source,
          data: {'subjectId': subjectId, 'response': res.data},
        );
        return result;
      }

      final message = 'Failed to rebuild leaderboard: HTTP ${res.statusCode}';
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'subjectId': subjectId,
          'statusCode': res.statusCode,
          'response': res.data,
        },
      );
      throw ServerException(message: message);
    } on DioException catch (e) {
      final message = e.response?.data is Map<String, dynamic>
          ? (e.response?.data['message']?.toString() ??
              'Failed to rebuild leaderboard')
          : 'Failed to rebuild leaderboard';
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'subjectId': subjectId,
          'error': e.toString(),
          'response': e.response?.data,
        },
      );
      throw ServerException(message: message);
    } catch (e) {
      final message = 'Failed to rebuild leaderboard: $e';
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'subjectId': subjectId,
          'error': e.toString()
        },
      );
      throw ServerException(message: message);
    }
  }
}
