import 'package:dio/dio.dart';
import 'package:sci_fun/common/helper/log_debug.dart';
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
    const source = 'QuestionRemoteDatasource.getAllQuestions';
    try {
      final res = await dioClient.get(
        url:
            '${QuestionApiUrl.getQuestions}?page=$page&limit=$limit&quizId=$quizId',
      );

      if (res.statusCode == 200) {
        final responseData = res.data['data'] as Map<String, dynamic>;
        logResponseData(
          responseData,
          source: source,
        );

        final total = responseData['total'] as int;
        final data = {
          'total': total,
          'data': responseData['data'],
          'limit': limit,
          'totalPages': (total + limit - 1) ~/ limit,
          'page': page,
        };

        final result = QuestionsResponseModel.fromJson(data);
        logApiSuccess(
          source: source,
          data: {
            'quizId': quizId,
            'page': page,
            'limit': limit,
            'total': total,
            'response': res.data,
          },
        );
        return result;
      }

      final message = 'Failed to load questions';
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'quizId': quizId,
          'statusCode': res.statusCode,
          'response': res.data,
        },
      );
      throw ServerException(message: message);
    } on DioException catch (e) {
      final message = e.response?.data is Map<String, dynamic>
          ? (e.response?.data['message']?.toString() ??
              'Failed to load questions')
          : 'Failed to load questions';
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'quizId': quizId,
          'error': e.toString(),
          'response': e.response?.data,
        },
      );
      throw ServerException(message: message);
    } on ServerException {
      rethrow;
    } catch (e) {
      final message = 'Failed to load questions: $e';
      logApiFailure(
        source: source,
        data: {'message': message, 'quizId': quizId, 'error': e.toString()},
      );
      throw ServerException(message: message);
    }
  }

  @override
  Future<QuestionModel> getQuestionById({
    required String questionId,
  }) async {
    const source = 'QuestionRemoteDatasource.getQuestionById';
    try {
      final res = await dioClient.get(
        url: '${QuestionApiUrl.getQuestionById}/$questionId',
      );
      final responseBody = res.data;
      if (res.statusCode == 200 && responseBody is Map<String, dynamic>) {
        final questionData = responseBody['data'];
        if (questionData is Map<String, dynamic>) {
          final question = QuestionModel.fromJson(questionData);
          logApiSuccess(
            source: source,
            data: {'questionId': questionId, 'response': res.data},
          );
          return question;
        }
      }

      const message = 'Failed to load question detail';
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'questionId': questionId,
          'statusCode': res.statusCode,
          'response': responseBody,
        },
      );
      throw ServerException(message: message);
    } on DioException catch (e) {
      final dynamic errorData = e.response?.data;
      final String message = errorData is Map<String, dynamic>
          ? (errorData['message']?.toString() ??
              'Failed to load question detail')
          : 'Failed to load question detail';
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'questionId': questionId,
          'error': e.toString(),
          'response': e.response?.data,
        },
      );
      throw ServerException(message: message);
    } on ServerException {
      rethrow;
    } catch (e) {
      const message = 'Failed to load question detail';
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'questionId': questionId,
          'error': e.toString()
        },
      );
      throw ServerException(message: message);
    }
  }

  @override
  Future<Map<String, dynamic>> submitQuizAnswers({
    required String userId,
    required String quizId,
    required List<Map<String, dynamic>> answers,
  }) async {
    const source = 'QuestionRemoteDatasource.submitQuizAnswers';
    try {
      final res = await dioClient.post(
        url: SubmissionApiUrl.postSubmission,
        data: {
          'userId': userId,
          'quizId': quizId,
          'answers': answers,
        },
      );

      if (res.statusCode == 200) {
        final data = (res.data['data'] ?? res.data) as Map<String, dynamic>;
        logApiSuccess(
          source: source,
          data: {'quizId': quizId, 'userId': userId, 'response': res.data},
        );
        return data;
      }

      final message = 'Failed to submit answers: ${res.statusCode}';
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'quizId': quizId,
          'userId': userId,
          'statusCode': res.statusCode,
          'response': res.data,
        },
      );
      throw ServerException(message: message);
    } on DioException catch (e) {
      final message = e.response?.data is Map<String, dynamic>
          ? (e.response?.data['message']?.toString() ??
              'Failed to submit answers')
          : 'Failed to submit answers';
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'quizId': quizId,
          'userId': userId,
          'error': e.toString(),
          'response': e.response?.data,
        },
      );
      throw ServerException(message: message);
    } catch (e) {
      final message = 'Failed to submit answers: $e';
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'quizId': quizId,
          'userId': userId,
          'error': e.toString(),
        },
      );
      throw ServerException(message: message);
    }
  }

  @override
  Future<Map<String, dynamic>> getSubmissionDetail({
    required String submissionId,
  }) async {
    const source = 'QuestionRemoteDatasource.getSubmissionDetail';
    try {
      final res = await dioClient.get(
        url: '${SubmissionApiUrl.getSubmissionDetail}/$submissionId',
      );

      if (res.statusCode == 200) {
        final data = (res.data['data'] ?? res.data) as Map<String, dynamic>;
        logApiSuccess(
          source: source,
          data: {'submissionId': submissionId, 'response': res.data},
        );
        return data;
      }

      final message = 'Failed to get submission detail';
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'submissionId': submissionId,
          'statusCode': res.statusCode,
          'response': res.data,
        },
      );
      throw ServerException(message: message);
    } on DioException catch (e) {
      final message = e.response?.data is Map<String, dynamic>
          ? (e.response?.data['message']?.toString() ??
              'Failed to get submission detail')
          : 'Failed to get submission detail';
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'submissionId': submissionId,
          'error': e.toString(),
          'response': e.response?.data,
        },
      );
      throw ServerException(message: message);
    } catch (e) {
      final message = 'Failed to get submission detail: $e';
      logApiFailure(
        source: source,
        data: {
          'message': message,
          'submissionId': submissionId,
          'error': e.toString()
        },
      );
      throw ServerException(message: message);
    }
  }
}
