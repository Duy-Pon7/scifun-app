import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:thilop10_3004/common/models/response_model.dart';
import 'package:thilop10_3004/core/constants/api_urls.dart';
import 'package:thilop10_3004/core/constants/message_constants.dart';
import 'package:thilop10_3004/core/error/server_exception.dart';
import 'package:thilop10_3004/core/network/dio_client.dart';
import 'package:thilop10_3004/features/home/data/model/response_lesson_category_model.dart';

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
    try {
      final res = await dioClient.get(
        url:
            "${HomeApiUrls.getLessonCategory}?page=$page&limit=${dotenv.get('PAGE_SIZE')}&subject_id=$subjectId",
      );

      if (res.statusCode != 200) {
        throw ServerException();
      }

      final responseData = ResponseModel<ResponseLessonCategoryModel>.fromJson(
        res.data,
        (json) =>
            ResponseLessonCategoryModel.fromJson(json as Map<String, dynamic>),
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
