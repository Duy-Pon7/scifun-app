import 'package:dio/dio.dart';
import 'package:sci_fun/common/helper/log_debug.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/features/topic/data/model/topic_model.dart';

abstract interface class TopicRemoteDatasource {
  Future<List<TopicModel>> getAllTopics(
    String? searchQuery, {
    String? subjectId,
    required int page,
    required int limit,
  });
}

class TopicRemoteDatasourceImpl implements TopicRemoteDatasource {
  final DioClient dioClient;

  TopicRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<List<TopicModel>> getAllTopics(
    String? searchQuery, {
    String? subjectId,
    required int page,
    required int limit,
  }) async {
    const source = 'TopicRemoteDatasource.getAllTopics';
    try {
      final res = await dioClient.get(
        url:
            '${TopicApiUrl.getTopics}?page=$page&limit=$limit&subjectId=$subjectId&search=$searchQuery',
      );

      if (res.statusCode == 200) {
        final List<dynamic> data = res.data['data']['topics'];
        final topics = data
            .map((topicJson) =>
                TopicModel.fromJson(topicJson as Map<String, dynamic>))
            .toList();
        logApiSuccess(
          source: source,
          data: {'count': topics.length, 'response': res.data},
        );
        return topics;
      }

      final message = 'Failed to load topics (HTTP ${res.statusCode})';
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
          ? (e.response?.data['message']?.toString() ?? 'Failed to load topics')
          : 'Failed to load topics';
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
      final message = 'Failed to load topics: $e';
      logApiFailure(
        source: source,
        data: {'message': message, 'error': e.toString()},
      );
      throw ServerException(message: message);
    }
  }
}
