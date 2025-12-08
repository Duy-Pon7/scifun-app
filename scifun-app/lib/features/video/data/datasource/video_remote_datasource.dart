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
    try {
      final res = await dioClient.get(
        url:
            "${VideoApiUrl.getVideoLessons}?page=$page&limit=$limit&topicId=$topicId",
      );
      if (res.statusCode == 200) {
        return VideoModel.fromJson(res.data['data']);
      } else {
        throw ServerException(message: 'Failed to load videos');
      }
    } catch (e) {
      throw ServerException(message: 'Failed to load videos: $e');
    }
  }
}
