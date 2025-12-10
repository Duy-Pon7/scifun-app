import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/features/quizz/data/model/quizz_model.dart';

abstract interface class QuizzRemoteDatasource {
  Future<List<QuizzModel>> getQuizzes(
    String? searchQuery, {
    required String topicId,
    required int page,
    required int limit,
  });

  Future<List<QuizzModel>> getTrendQuizzes();
}

class QuizzRemoteDatasourceImpl implements QuizzRemoteDatasource {
  final DioClient dioClient;

  QuizzRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<List<QuizzModel>> getQuizzes(
    String? searchQuery, {
    required String topicId,
    required int page,
    required int limit,
  }) async {
    try {
      final res = await dioClient.get(
        url:
            "${QuizApiUrl.getQuizzes}?page=$page&limit=$limit&topicId=$topicId&search=$searchQuery",
      );

      if (res.statusCode == 200) {
        final List<dynamic> data = res.data['data']['quizzes'];
        return data
            .map((quizJson) =>
                QuizzModel.fromJson(quizJson as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load Quizzes');
      }
    } catch (e) {
      throw Exception('Failed to load Quizzes: $e');
    }
  }

  @override
  Future<List<QuizzModel>> getTrendQuizzes() async {
    try {
      final res = await dioClient.get(
        url: QuizApiUrl.getTrendQuizzes,
      );

      if (res.statusCode == 200) {
        final List<dynamic> data = res.data['data']['data'];
        return data
            .map((quizJson) =>
                QuizzModel.fromJson(quizJson as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load Trend Quizzes');
      }
    } catch (e) {
      throw Exception('Failed to load Trend Quizzes: $e');
    }
  }
}
