import 'package:dio/dio.dart';
import 'package:sci_fun/common/helper/log_debug.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/features/analytics/data/model/progress_stats_model.dart';

abstract interface class ProgressStatsRemoteDatasource {
  Future<ProgressStatsModel> getProgressStats();
}

class ProgressStatsRemoteDatasourceImpl
    implements ProgressStatsRemoteDatasource {
  ProgressStatsRemoteDatasourceImpl({required this.dioClient});

  final DioClient dioClient;

  @override
  Future<ProgressStatsModel> getProgressStats() async {
    const source = 'ProgressStatsRemoteDatasource.getProgressStats';

    try {
      final res = await dioClient.get(
        url: SubmissionApiUrl.getProgressStats,
      );

      if (res.statusCode == 200) {
        final dynamic data = res.data['data'];
        if (data is! Map<String, dynamic>) {
          const message = 'Invalid progress stats response format';
          logApiFailure(
            source: source,
            data: {
              'message': message,
              'statusCode': res.statusCode,
              'response': res.data,
            },
          );
          throw ServerException(message: message);
        }

        final stats = ProgressStatsModel.fromJson(data);
        logApiSuccess(
          source: source,
          data: {'response': res.data},
        );
        return stats;
      }

      const message = 'Failed to load progress stats';
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'statusCode': res.statusCode,
          'response': res.data,
        },
      );
      throw ServerException(message: message);
    } on DioException catch (e) {
      final message = e.response?.data is Map<String, dynamic>
          ? (e.response?.data['message']?.toString() ??
              'Failed to load progress stats')
          : 'Failed to load progress stats';
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'error': e.toString(),
          'response': e.response?.data,
        },
      );
      throw ServerException(message: message);
    } catch (e) {
      final message = 'Failed to load progress stats: $e';
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'error': e.toString(),
        },
      );
      throw ServerException(message: message);
    }
  }
}
