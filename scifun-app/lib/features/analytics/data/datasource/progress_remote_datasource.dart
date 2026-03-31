import 'package:dio/dio.dart';
import 'package:sci_fun/common/helper/log_debug.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/features/analytics/data/model/progress_model.dart';

abstract interface class ProgressRemoteDatasource {
  Future<ProgressModel> getProgress(String subjectId);
}

class ProgressRemoteDatasourceImpl implements ProgressRemoteDatasource {
  final DioClient dioClient;

  ProgressRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<ProgressModel> getProgress(String subjectId) async {
    const source = 'ProgressRemoteDatasource.getProgress';
    try {
      final res = await dioClient.get(
        url: '${SubmissionApiUrl.getUserProgress}/$subjectId',
      );

      if (res.statusCode == 200) {
        final dynamic data = res.data['data'];
        final progress = ProgressModel.fromJson(data as Map<String, dynamic>);
        logApiSuccess(
          source: source,
          data: {'subjectId': subjectId, 'response': res.data},
        );
        return progress;
      }

      final message = 'Failed to load user progress';
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
              'Failed to load user progress')
          : 'Failed to load user progress';
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
      final message = 'Failed to load user progress: $e';
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
