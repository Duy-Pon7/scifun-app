import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sci_fun/common/helper/log_debug.dart';
import 'package:sci_fun/common/models/response_model.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/constants/message_constants.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/features/home/data/model/response_lesson_category_model.dart';

abstract interface class LessonCategoryRemoteDatasource {
  Future<ResponseLessonCategoryModel> getLessonCate({
    required int page,
    required int subjectId,
  });
}

class LessonCategoryRemoteDatasourceImpl
    implements LessonCategoryRemoteDatasource {
  final DioClient dioClient;

  LessonCategoryRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<ResponseLessonCategoryModel> getLessonCate({
    required int page,
    required int subjectId,
  }) async {
    const source = 'LessonCategoryRemoteDatasource.getLessonCate';
    try {
      final res = await dioClient.get(
        url:
            '${HomeApiUrls.getLessonCategory}?page=$page&limit=${dotenv.get('PAGE_SIZE')}&subject_id=$subjectId',
      );

      if (res.statusCode != 200) {
        logApiFailure(
          source: source,
          data: {
            'message': MessageConstant.failure,
            'page': page,
            'subjectId': subjectId,
            'statusCode': res.statusCode,
            'response': res.data,
          },
        );
        throw ServerException();
      }

      final responseData = ResponseModel<ResponseLessonCategoryModel>.fromJson(
        res.data,
        (json) =>
            ResponseLessonCategoryModel.fromJson(json as Map<String, dynamic>),
      );
      logResponseData(responseData, source: source);

      if (responseData.status != 200 || responseData.data == null) {
        logApiFailure(
          source: source,
          data: {
            'message': MessageConstant.failure,
            'page': page,
            'subjectId': subjectId,
            'response': res.data,
          },
        );
        throw ServerException(message: MessageConstant.failure);
      }

      logApiSuccess(
        source: source,
        data: {'page': page, 'subjectId': subjectId, 'response': res.data},
      );
      return responseData.data!;
    } on ServerException {
      rethrow;
    } catch (e) {
      logApiFailure(
        source: source,
        data: {
          'message': MessageConstant.failure,
          'page': page,
          'subjectId': subjectId,
          'error': e.toString(),
        },
      );
      throw ServerException();
    }
  }
}
