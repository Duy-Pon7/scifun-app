import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sci_fun/common/models/response_model.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/constants/message_constants.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/features/home/data/model/quizz_model.dart';
import 'package:sci_fun/features/home/data/model/quizz_result_model.dart';
import 'package:sci_fun/features/home/data/model/response_quizz_model.dart';

abstract interface class QuizzRemoteDatasource {
  Future<ResponseQuizzModel> getQuizzByCate({
    required int page,
    required int cateId,
  });
  Future<List<QuizzResultModel>> getQuizzResult(
      {required int page, required int quizzId});
  //getQuizzDetail?
  Future<ResponseQuizzModel> getQuizzByLesson({
    required int page,
    required int lessonId,
  });
  Future<QuizzModel> getQuizzDetail({required int quizzId});

  Future<QuizzModel> addQuizz({required Map<String, dynamic> quizzParam});
}

class QuizzRemoteDatasourceImpl implements QuizzRemoteDatasource {
  final DioClient dioClient;

  QuizzRemoteDatasourceImpl({required this.dioClient});
  @override
  Future<List<QuizzResultModel>> getQuizzResult({
    required int page,
    required int quizzId,
  }) async {
    try {
      print("page $page, quizzId: $quizzId");

      final res = await dioClient.get(
        url: '${HomeApiUrls.getResultQuizz}?page=$page&quiz_id=$quizzId',
      );

      if (res.statusCode != 200) {
        throw ServerException();
      }

      final responseData = ResponseModel<Map<String, dynamic>>.fromJson(
        res.data,
        (json) => json as Map<String, dynamic>,
      );

      if (responseData.status != 200 || responseData.data == null) {
        throw ServerException(message: MessageConstant.failure);
      }

      final quizResultsJson =
          responseData.data?['quiz_results'] as List<dynamic>?;

      if (quizResultsJson == null) {
        throw ServerException(message: MessageConstant.failure);
      }

      final List<QuizzResultModel> resultList = [];
      for (final item in quizResultsJson) {
        try {
          final model = QuizzResultModel.fromJson(item as Map<String, dynamic>);
          resultList.add(model);
        } catch (e) {
          print("❌ Lỗi parse item: $item\nError: $e");
        }
      }

      return resultList;
    } on ServerException {
      rethrow;
    } catch (error) {
      throw ServerException(message: error.toString());
    }
  }

  //? Ngữ văn
  @override
  Future<ResponseQuizzModel> getQuizzByCate(
      {required int page, required int cateId}) async {
    try {
      print("cateId: $cateId, page: $page");
      final res = await dioClient.get(
        url:
            "${HomeApiUrls.getQuizzByCate}?page=$page&limit=${dotenv.get('PAGE_SIZE')}&lesson_category_id=$cateId",
      );
      print("res: $res");
      if (res.statusCode != 200) {
        throw ServerException();
      }

      final responseData = ResponseModel<ResponseQuizzModel>.fromJson(
        res.data,
        (json) => ResponseQuizzModel.fromJson(json as Map<String, dynamic>),
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
  Future<QuizzModel> getQuizzDetail({required int quizzId}) async {
    try {
      final res = await dioClient.get(
        url: "${HomeApiUrls.getQuizzByCate}/$quizzId",
      );

      if (res.statusCode != 200) {
        throw ServerException();
      }

      final responseData = ResponseModel<QuizzModel>.fromJson(
        res.data,
        (json) => QuizzModel.fromJson(json as Map<String, dynamic>),
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
  Future<ResponseQuizzModel> getQuizzByLesson(
      {required int page, required int lessonId}) async {
    try {
      final res = await dioClient.get(
        url:
            "${HomeApiUrls.getQuizzByCate}?page=$page&limit=${dotenv.get('PAGE_SIZE')}&lesson_category_id=$lessonId",
      );

      if (res.statusCode != 200) {
        throw ServerException();
      }
      final responseData = ResponseModel<ResponseQuizzModel>.fromJson(
        res.data,
        (json) => ResponseQuizzModel.fromJson(json as Map<String, dynamic>),
      );

      if (responseData.status != 200 || responseData.data == null) {
        throw ServerException(message: MessageConstant.failure);
      }
      final respon = responseData.data!.quizzes;
      print("getQuizzByLesson $respon");
      return responseData.data!;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<QuizzModel> addQuizz(
      {required Map<String, dynamic> quizzParam}) async {
    try {
      final res = await dioClient.post(
        url: HomeApiUrls.addQuizz,
        data: quizzParam,
      );

      if (res.statusCode != 200) {
        throw ServerException();
      }

      final responseData = ResponseModel<QuizzModel>.fromJson(
        res.data,
        (json) => QuizzModel.fromJson(json as Map<String, dynamic>),
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
