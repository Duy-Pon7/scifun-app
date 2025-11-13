import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:thilop10_3004/common/models/response_model.dart';
import 'package:thilop10_3004/core/constants/api_urls.dart';
import 'package:thilop10_3004/core/constants/message_constants.dart';
import 'package:thilop10_3004/core/error/server_exception.dart';
import 'package:thilop10_3004/core/network/dio_client.dart';
import 'package:thilop10_3004/features/home/data/model/news_model.dart';

abstract interface class NewsRemoteDatasource {
  Future<List<NewsModel>> getAllNews({required int page});
  Future<NewsModel> getNewsDetail({required int newsId});
}

class NewsRemoteDatasourceImpl implements NewsRemoteDatasource {
  final DioClient dioClient;

  NewsRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<List<NewsModel>> getAllNews({required int page}) async {
    try {
      final res = await dioClient.get(
        url:
            "${HomeApiUrls.getNews}?page=$page&limit=${dotenv.get('PAGE_SIZE')}",
      );
      if (res.statusCode != 200) {
        throw ServerException();
      }

      final responseData = ResponseModel<List<NewsModel>>.fromJson(
        res.data,
        (json) => NewsModel.fromListJson(json as List<dynamic>),
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
  Future<NewsModel> getNewsDetail({required int newsId}) async {
    try {
      final res = await dioClient.get(
        url: "${HomeApiUrls.getNews}/$newsId",
      );

      if (res.statusCode != 200) {
        throw ServerException();
      }

      final responseData = ResponseModel<NewsModel>.fromJson(
        res.data,
        (json) => NewsModel.fromJson(json as Map<String, dynamic>),
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
