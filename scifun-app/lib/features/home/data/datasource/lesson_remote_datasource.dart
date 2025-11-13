import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:thilop10_3004/common/models/response_model.dart';
import 'package:thilop10_3004/core/constants/api_urls.dart';
import 'package:thilop10_3004/core/constants/message_constants.dart';
import 'package:thilop10_3004/core/error/server_exception.dart';
import 'package:thilop10_3004/core/network/dio_client.dart';
import 'package:thilop10_3004/features/home/data/model/lesson_model.dart';
import 'package:thilop10_3004/features/home/data/model/response_lesson_model.dart';
import 'package:thilop10_3004/features/home/data/model/response_progress_model.dart';

abstract interface class LessonRemoteDatasource {
  Future<ResponseLessonModel> getListLesson({
    required int page,
    int? lessonCategoryId,
    String? keyWord,
  });
  Future<ResponseProgressModel> getListSubject({
    required int page,
    required int subjectId,
  });
  Future<LessonModel> getLessonDetail({required int lessonId});
}

class LessonRemoteDatasourceImpl implements LessonRemoteDatasource {
  final DioClient dioClient;

  LessonRemoteDatasourceImpl({required this.dioClient});
  @override
  Future<ResponseProgressModel> getListSubject({
    required int page,
    required int subjectId,
  }) async {
    try {
      final res = await dioClient.get(
        url:
            "${HomeApiUrls.getLesson}?page=$page&limit=${dotenv.get('PAGE_SIZE')}&subject_id=$subjectId",
      );
      if (res.statusCode != 200) {
        throw ServerException();
      }
      final responseData = ResponseModel<ResponseProgressModel>.fromJson(
        res.data,
        (json) => ResponseProgressModel.fromJson(json as Map<String, dynamic>),
      );
      if (responseData.status != 200 || responseData.data == null) {
        throw ServerException(message: MessageConstant.failure);
      }

      return responseData.data!;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<ResponseLessonModel> getListLesson({
    required int page,
    int? lessonCategoryId,
    String? keyWord,
  }) async {
    try {
      print("key $keyWord");
      // Tạo query parameters động
      final queryParams = {
        'page': page.toString(),
        'limit': dotenv.get('PAGE_SIZE'),
      };

      if (lessonCategoryId != null) {
        queryParams['lesson_category_id'] = lessonCategoryId.toString();
      }
      if (keyWord != null && keyWord.trim().isNotEmpty) {
        queryParams['keyword'] = keyWord;
      }

      final uri = Uri.parse(HomeApiUrls.getLesson)
          .replace(queryParameters: queryParams);
      final res = await dioClient.get(url: uri.toString());

      if (res.statusCode != 200) {
        throw ServerException();
      }
      final responseData = ResponseModel<ResponseLessonModel>.fromJson(
        res.data,
        (json) => ResponseLessonModel.fromJson(json as Map<String, dynamic>),
      );
      print(jsonEncode(res.data)); // Kiểm tra dữ liệu đã parse
      if (responseData.status != 200 || responseData.data == null) {
        throw ServerException(message: MessageConstant.failure);
      }

      return responseData.data!;
    } on ServerException {
      rethrow;
    } catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<LessonModel> getLessonDetail({required int lessonId}) async {
    print("Fetching lesson detail for ID: $lessonId");
    try {
      final res = await dioClient.get(
        url: "${HomeApiUrls.getLesson}/$lessonId",
      );

      if (res.statusCode != 200) {
        throw ServerException();
      }

      final responseData = ResponseModel<LessonModel>.fromJson(
        res.data,
        (json) => LessonModel.fromJson(json as Map<String, dynamic>),
      );

      if (responseData.status != 200 || responseData.data == null) {
        throw ServerException(message: MessageConstant.failure);
      }

      return responseData.data!;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException();
    }
  }
}
