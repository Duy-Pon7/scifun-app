import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/features/quizz/data/model/quizz_model.dart';
import 'package:sci_fun/features/quizz/data/model/quizz_trend_model.dart';
import 'package:sci_fun/features/quizz/data/model/quizz_result_model.dart';

abstract interface class QuizzRemoteDatasource {
  Future<List<QuizzModel>> getQuizzes(
    String? searchQuery, {
    required String topicId,
    required int page,
    required int limit,
  });

  Future<QuizzTrendModel> getTrendQuizzes();
  Future<QuizzResultModel> getSubmissionDetail(String submissionId);
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
  Future<QuizzTrendModel> getTrendQuizzes() async {
    try {
      final res = await dioClient.get(
        url: QuizApiUrl.getTrendQuizzes,
      );

      if (res.statusCode == 200) {
        return QuizzTrendModel.fromJson(res.data['data']);
      } else {
        throw Exception('Failed to load Trend Quizzes');
      }
    } catch (e) {
      throw Exception('Failed to load Trend Quizzes: $e');
    }
  }

  @override
  Future<QuizzResultModel> getSubmissionDetail(String submissionId) async {
    try {
      final res = await dioClient.get(
        url: "${SubmissionApiUrl.getSubmissionDetail}/$submissionId",
      );

      if (res.statusCode == 200) {
        return QuizzResultModel.fromJson(res.data['data']);
      } else {
        throw Exception('Failed to load Submission detail');
      }
    } catch (e) {
      throw Exception('Failed to load Submission detail: $e');
    }
  }
}
