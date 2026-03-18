import 'package:dio/dio.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/features/question/data/model/question_model.dart';

abstract interface class QuestionRemoteDatasource {
  Future<QuestionsResponseModel> getAllQuestions({
    required String quizId,
    int page = 1,
    int limit = 10,
  });

  Future<QuestionModel> getQuestionById({
    required String questionId,
  });

  Future<Map<String, dynamic>> submitQuizAnswers({
    required String userId,
    required String quizId,
    required List<Map<String, dynamic>> answers,
  });

  Future<Map<String, dynamic>> getSubmissionDetail({
    required String submissionId,
  });
}

class QuestionRemoteDatasourceImpl implements QuestionRemoteDatasource {
  final DioClient dioClient;

  QuestionRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<QuestionsResponseModel> getAllQuestions({
    required String quizId,
    int page = 1,
    int limit = 10,
  }) async {
    print(
        "Fetching questions for quizId: $quizId, page: $page, limit: $limit"); // Debug print
    try {
      final res = await dioClient.get(
        url:
            "${QuestionApiUrl.getQuestions}?page=$page&limit=$limit&quizId=$quizId",
      );
      if (res.statusCode == 200) {
        final responseData = res.data['data'] as Map<String, dynamic>;
        final total = responseData['total'] as int;
        // API returns {total, data} but we need to add pagination fields
        final data = {
          'total': total,
          'data': responseData['data'],
          'limit': limit,
          'totalPages': (total + limit - 1) ~/ limit,
          'page': page,
        };
        return QuestionsResponseModel.fromJson(data);
      } else {
        throw Exception('Failed to load questions');
      }
    } catch (e) {
      print("Error fetching questions: $e"); // Debug print
      throw Exception('Failed to load questions: $e');
    }
  }

  @override
  Future<QuestionModel> getQuestionById({
    required String questionId,
  }) async {
    try {
      final res = await dioClient.get(
        url: "${QuestionApiUrl.getQuestionById}/$questionId",
      );
      final responseBody = res.data;
      if (res.statusCode == 200 && responseBody is Map<String, dynamic>) {
        final questionData = responseBody['data'];
        if (questionData is Map<String, dynamic>) {
          return QuestionModel.fromJson(questionData);
        }
      }
      throw ServerException(message: 'Failed to load question detail');
    } on DioException catch (e) {
      final dynamic errorData = e.response?.data;
      final String? apiMessage =
          errorData is Map<String, dynamic> ? errorData['message'] : null;
      throw ServerException(
        message: apiMessage ?? 'Failed to load question detail',
      );
    } on ServerException {
      rethrow;
    } catch (_) {
      throw ServerException(message: 'Failed to load question detail');
    }
  }

  @override
  Future<Map<String, dynamic>> submitQuizAnswers({
    required String userId,
    required String quizId,
    required List<Map<String, dynamic>> answers,
  }) async {
    print("Submitting answers for userId: $userId, quizId: $quizId");
    print("Answers payload: $answers");
    try {
      final res = await dioClient.post(
        url: SubmissionApiUrl.postSubmission,
        data: {
          "userId": userId,
          "quizId": quizId,
          "answers": answers,
        },
      );
      print("Submission response: ${res.data}");
      if (res.statusCode == 200) {
        return res.data['data'] ?? res.data;
      } else {
        throw Exception('Failed to submit answers: ${res.statusCode}');
      }
    } catch (e) {
      print("Error submitting answers: $e");
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getSubmissionDetail({
    required String submissionId,
  }) async {
    print("Fetching submission detail for submissionId: $submissionId");
    try {
      final res = await dioClient.get(
        url: "${SubmissionApiUrl.getSubmissionDetail}/$submissionId",
      );
      print("Submission detail response: ${res.data}");
      if (res.statusCode == 200) {
        return res.data['data'] ?? res.data;
      } else {
        throw Exception('Failed to get submission detail');
      }
    } catch (e) {
      print("Error fetching submission detail: $e");
      rethrow;
    }
  }
}
