import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sci_fun/common/helper/log_debug.dart';
import 'package:sci_fun/common/models/response_model.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/constants/message_constants.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/features/home/data/model/news_model.dart';

abstract interface class NewsRemoteDatasource {
  Future<List<NewsModel>> getAllNews({required int page});
  Future<NewsModel> getNewsDetail({required int newsId});
}

class NewsRemoteDatasourceImpl implements NewsRemoteDatasource {
  final DioClient dioClient;

  NewsRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<List<NewsModel>> getAllNews({required int page}) async {
    const source = 'NewsRemoteDatasource.getAllNews';
    try {
      final res = await dioClient.get(
        url:
            '${HomeApiUrls.getNews}?page=$page&limit=${dotenv.get('PAGE_SIZE')}',
      );
      if (res.statusCode != 200) {
        logApiFailure(
          source: source,
          data: {
            'message': MessageConstant.failure,
            'page': page,
            'statusCode': res.statusCode,
            'response': res.data,
          },
        );
        throw ServerException();
      }

      final responseData = ResponseModel<List<NewsModel>>.fromJson(
        res.data,
        (json) => NewsModel.fromListJson(json as List<dynamic>),
      );
      logResponseData(responseData, source: source);

      if (responseData.status != 200 || responseData.data == null) {
        logApiFailure(
          source: source,
          data: {
            'message': MessageConstant.failure,
            'page': page,
            'response': res.data,
          },
        );
        throw ServerException(message: MessageConstant.failure);
      }

      logApiSuccess(
        source: source,
        data: {
          'page': page,
          'count': responseData.data!.length,
          'response': res.data
        },
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
          'error': e.toString()
        },
      );
      throw ServerException();
    }
  }

  @override
  Future<NewsModel> getNewsDetail({required int newsId}) async {
    const source = 'NewsRemoteDatasource.getNewsDetail';
    try {
      final res = await dioClient.get(url: '${HomeApiUrls.getNews}/$newsId');

      if (res.statusCode != 200) {
        logApiFailure(
          source: source,
          data: {
            'message': MessageConstant.failure,
            'newsId': newsId,
            'statusCode': res.statusCode,
            'response': res.data,
          },
        );
        throw ServerException();
      }

      final responseData = ResponseModel<NewsModel>.fromJson(
        res.data,
        (json) => NewsModel.fromJson(json as Map<String, dynamic>),
      );
      logResponseData(responseData, source: source);

      if (responseData.status != 200 || responseData.data == null) {
        logApiFailure(
          source: source,
          data: {
            'message': MessageConstant.failure,
            'newsId': newsId,
            'response': res.data,
          },
        );
        throw ServerException(message: MessageConstant.failure);
      }

      logApiSuccess(
        source: source,
        data: {'newsId': newsId, 'response': res.data},
      );
      return responseData.data!;
    } on ServerException {
      rethrow;
    } catch (e) {
      logApiFailure(
        source: source,
        data: {
          'message': MessageConstant.failure,
          'newsId': newsId,
          'error': e.toString()
        },
      );
      throw ServerException();
    }
  }
}
