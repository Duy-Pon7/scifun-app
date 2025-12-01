import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/features/topic/data/model/topic_model.dart';

abstract interface class TopicRemoteDatasource {
  Future<List<TopicModel>> getAllTopics(
    String? searchQuery, {
    required String subjectId,
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
    required String subjectId,
    required int page,
    required int limit,
  }) async {
    try {
      final res = await dioClient.get(
        url:
            "${TopicApiUrl.getTopics}?page=$page&limit=$limit&subjectId=$subjectId&search=$searchQuery",
      );
      if (res.statusCode == 200) {
        final List<dynamic> data = res.data['data']['topics'];
        return data
            .map((topicJson) =>
                TopicModel.fromJson(topicJson as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load Topics');
      }
    } catch (e) {
      throw Exception('Failed to load Topics: $e');
    }
  }
}
