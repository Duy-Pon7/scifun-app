import 'package:dio/dio.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/core/error/server_exception.dart';
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
        throw ServerException(
            message:
                'Không thể tải danh sách bài tập (HTTP ${res.statusCode})');
      }
    } on DioException catch (e) {
      String msg;
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          msg = 'Yêu cầu tới máy chủ quá lâu, vui lòng thử lại.';
          break;
        case DioExceptionType.badResponse:
          msg = 'Máy chủ trả về lỗi (${e.response?.statusCode}).';
          break;
        case DioExceptionType.cancel:
          msg = 'Yêu cầu đã bị huỷ.';
          break;
        default:
          msg = 'Không thể kết nối tới máy chủ. Kiểm tra kết nối mạng.';
      }
      throw ServerException(message: msg);
    } catch (_) {
      throw ServerException(message: 'Có lỗi xảy ra khi tải dữ liệu bài tập.');
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
        throw ServerException(
            message: 'Không thể tải Trend Quizzes (HTTP ${res.statusCode})');
      }
    } on DioException catch (e) {
      String msg;
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          msg = 'Yêu cầu tới máy chủ quá lâu, vui lòng thử lại.';
          break;
        case DioExceptionType.badResponse:
          msg = 'Máy chủ trả về lỗi (${e.response?.statusCode}).';
          break;
        case DioExceptionType.cancel:
          msg = 'Yêu cầu đã bị huỷ.';
          break;
        default:
          msg = 'Không thể kết nối tới máy chủ. Kiểm tra kết nối mạng.';
      }
      throw ServerException(message: msg);
    } catch (_) {
      throw ServerException(message: 'Có lỗi xảy ra khi tải Trend Quizzes.');
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
        throw ServerException(
            message: 'Không thể tải chi tiết bài nộp (HTTP ${res.statusCode})');
      }
    } on DioException catch (e) {
      String msg;
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          msg = 'Yêu cầu tới máy chủ quá lâu, vui lòng thử lại.';
          break;
        case DioExceptionType.badResponse:
          msg = 'Máy chủ trả về lỗi (${e.response?.statusCode}).';
          break;
        case DioExceptionType.cancel:
          msg = 'Yêu cầu đã bị huỷ.';
          break;
        default:
          msg = 'Không thể kết nối tới máy chủ. Kiểm tra kết nối mạng.';
      }
      throw ServerException(message: msg);
    } catch (_) {
      throw ServerException(message: 'Có lỗi xảy ra khi tải chi tiết bài nộp.');
    }
  }
}
