import 'package:dio/dio.dart';
import 'package:sci_fun/common/helper/log_debug.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/features/video/data/model/video_model.dart';

abstract interface class VideoRemoteDatasource {
  Future<VideoModel> getVideosByTopic(
    String topicId,
    int page,
    int limit,
  );
}

class VideoRemoteDatasourceImpl implements VideoRemoteDatasource {
  final DioClient dioClient;

  VideoRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<VideoModel> getVideosByTopic(
    String topicId,
    int page,
    int limit,
  ) async {
    const source = 'VideoRemoteDatasource.getVideosByTopic';
    try {
      final res = await dioClient.get(
        url:
            '${VideoApiUrl.getVideoLessons}?page=$page&limit=$limit&topicId=$topicId',
      );

      if (res.statusCode == 200) {
        final video = VideoModel.fromJson(res.data['data']);
        logApiSuccess(
          source: source,
          data: {'topicId': topicId, 'response': res.data},
        );
        return video;
      }

      final message = 'Failed to load videos (HTTP ${res.statusCode})';
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
          ? (e.response?.data['message']?.toString() ?? 'Failed to load videos')
          : 'Failed to load videos';
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
      final message = 'Failed to load videos: $e';
      logApiFailure(
        source: source,
        data: {'message': message, 'error': e.toString()},
      );
      throw ServerException(message: message);
    }
  }
}
