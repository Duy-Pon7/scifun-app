import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/features/question/data/model/question_model.dart';

abstract interface class QuestionRemoteDatasource {
  Future<QuestionsResponseModel> getAllQuestions({
    required String quizId,
    int page = 1,
    int limit = 10,
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
