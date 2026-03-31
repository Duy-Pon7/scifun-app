import 'package:dio/dio.dart';
import 'package:sci_fun/common/helper/log_debug.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/features/quizz/data/model/quizz_model.dart';
import 'package:sci_fun/features/quizz/data/model/quizz_result_model.dart';
import 'package:sci_fun/features/quizz/data/model/quizz_trend_model.dart';

abstract interface class QuizzRemoteDatasource {
  Future<List<QuizzModel>> getQuizzes(
    String? searchQuery, {
    required String topicId,
    required int page,
    required int limit,
  });

  Future<QuizzTrendModel> getTrendQuizzes({String? subjectId});
  Future<QuizzResultModel> getSubmissionDetail(String submissionId);
}

class QuizzRemoteDatasourceImpl implements QuizzRemoteDatasource {
  final DioClient dioClient;

  QuizzRemoteDatasourceImpl({required this.dioClient});

  String _resolveDioMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Yeu cau toi may chu qua lau, vui long thu lai.';
      case DioExceptionType.badResponse:
        return 'May chu tra ve loi (${e.response?.statusCode}).';
      case DioExceptionType.cancel:
        return 'Yeu cau da bi huy.';
      default:
        return 'Khong the ket noi toi may chu. Kiem tra ket noi mang.';
    }
  }

  @override
  Future<List<QuizzModel>> getQuizzes(
    String? searchQuery, {
    required String topicId,
    required int page,
    required int limit,
  }) async {
    const source = 'QuizzRemoteDatasource.getQuizzes';
    try {
      final res = await dioClient.get(
        url:
            '${QuizApiUrl.getQuizzes}?page=$page&limit=$limit&topicId=$topicId&search=$searchQuery',
      );

      if (res.statusCode == 200) {
        final List<dynamic> data = res.data['data']['quizzes'];
        final quizzes = data
            .map((quizJson) =>
                QuizzModel.fromJson(quizJson as Map<String, dynamic>))
            .toList();
        logApiSuccess(
          source: source,
          data: {'count': quizzes.length, 'response': res.data},
        );
        return quizzes;
      }

      final message =
          'Khong the tai danh sach bai tap (HTTP ${res.statusCode})';
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
      final message = _resolveDioMessage(e);
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
      const message = 'Co loi xay ra khi tai du lieu bai tap.';
      logApiFailure(
        source: source,
        data: {'message': message, 'error': e.toString()},
      );
      throw ServerException(message: message);
    }
  }

  @override
  Future<QuizzTrendModel> getTrendQuizzes({String? subjectId}) async {
    const source = 'QuizzRemoteDatasource.getTrendQuizzes';
    try {
      final normalizedSubjectId = (subjectId ?? '').trim();
      final querySubId = Uri.encodeQueryComponent(normalizedSubjectId);
      final trendUrl = normalizedSubjectId.isEmpty
          ? QuizApiUrl.getTrendQuizzes
          : '${QuizApiUrl.getTrendQuizzes}?subId=$querySubId';

      final res = await dioClient.get(url: trendUrl);

      if (res.statusCode == 200) {
        final model = QuizzTrendModel.fromJson(res.data['data']);
        logApiSuccess(
          source: source,
          data: {'subjectId': normalizedSubjectId, 'response': res.data},
        );
        return model;
      }

      final message = 'Khong the tai Trend Quizzes (HTTP ${res.statusCode})';
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
      final message = _resolveDioMessage(e);
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
      const message = 'Co loi xay ra khi tai Trend Quizzes.';
      logApiFailure(
        source: source,
        data: {'message': message, 'error': e.toString()},
      );
      throw ServerException(message: message);
    }
  }

  @override
  Future<QuizzResultModel> getSubmissionDetail(String submissionId) async {
    const source = 'QuizzRemoteDatasource.getSubmissionDetail';
    try {
      final res = await dioClient.get(
        url: '${SubmissionApiUrl.getSubmissionDetail}/$submissionId',
      );

      if (res.statusCode == 200) {
        final model = QuizzResultModel.fromJson(res.data['data']);
        logApiSuccess(
          source: source,
          data: {'submissionId': submissionId, 'response': res.data},
        );
        return model;
      }

      final message = 'Khong the tai chi tiet bai nop (HTTP ${res.statusCode})';
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
      final message = _resolveDioMessage(e);
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
      const message = 'Co loi xay ra khi tai chi tiet bai nop.';
      logApiFailure(
        source: source,
        data: {'message': message, 'error': e.toString()},
      );
      throw ServerException(message: message);
    }
  }
}
