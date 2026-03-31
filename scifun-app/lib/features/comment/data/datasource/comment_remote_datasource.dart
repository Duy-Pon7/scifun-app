import 'package:dio/dio.dart';
import 'package:sci_fun/common/helper/log_debug.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/features/comment/data/model/comment_model.dart';

abstract interface class CommentRemoteDatasource {
  Future<List<CommentModel>> getComments({int page, int limit});
  Future<List<CommentModel>> getReplies(String parentId, {int page, int limit});
  Future<CommentModel> getCommentDetail(String id);
}

class CommentRemoteDatasourceImpl implements CommentRemoteDatasource {
  final DioClient dioClient;

  CommentRemoteDatasourceImpl({required this.dioClient});

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
  Future<List<CommentModel>> getComments({int page = 1, int limit = 10}) async {
    const source = 'CommentRemoteDatasource.getComments';
    try {
      final res = await dioClient.get(
        url: '${CommentApiUrl.getComments}?page=$page&limit=$limit',
      );

      if (res.statusCode == 200) {
        final List<dynamic> data = res.data['data']['items'];
        final comments = data
            .map((json) => CommentModel.fromJson(json as Map<String, dynamic>))
            .toList();
        logApiSuccess(
          source: source,
          data: {'count': comments.length, 'response': res.data},
        );
        return comments;
      }

      final message = 'Khong the tai binh luan (HTTP ${res.statusCode})';
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
      const message = 'Co loi xay ra khi tai binh luan.';
      logApiFailure(
        source: source,
        data: {'message': message, 'error': e.toString()},
      );
      throw ServerException(message: message);
    }
  }

  @override
  Future<List<CommentModel>> getReplies(
    String parentId, {
    int page = 1,
    int limit = 10,
  }) async {
    const source = 'CommentRemoteDatasource.getReplies';
    try {
      final res = await dioClient.get(
        url: '${CommentApiUrl.getReplies(parentId)}?page=$page&limit=$limit',
      );

      if (res.statusCode == 200) {
        final List<dynamic> data = res.data['data']['items'];
        final replies = data
            .map((json) => CommentModel.fromJson(json as Map<String, dynamic>))
            .toList();
        logApiSuccess(
          source: source,
          data: {'count': replies.length, 'response': res.data},
        );
        return replies;
      }

      final message = 'Khong the tai cau tra loi (HTTP ${res.statusCode})';
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
      const message = 'Co loi xay ra khi tai cau tra loi.';
      logApiFailure(
        source: source,
        data: {'message': message, 'error': e.toString()},
      );
      throw ServerException(message: message);
    }
  }

  @override
  Future<CommentModel> getCommentDetail(String id) async {
    const source = 'CommentRemoteDatasource.getCommentDetail';
    try {
      final res = await dioClient.get(url: CommentApiUrl.getCommentById(id));

      if (res.statusCode == 200) {
        final dynamic data = res.data['data'];

        if (data is Map<String, dynamic>) {
          final comment = CommentModel.fromJson(data);
          logApiSuccess(
            source: source,
            data: {'commentId': id, 'response': res.data},
          );
          return comment;
        }

        if (data is Map && data['item'] is Map) {
          final comment =
              CommentModel.fromJson(data['item'] as Map<String, dynamic>);
          logApiSuccess(
            source: source,
            data: {'commentId': id, 'response': res.data},
          );
          return comment;
        }

        const message = 'Du lieu chi tiet binh luan khong dung dinh dang';
        logApiFailure(
          source: source,
          data: {'message': message, 'response': res.data},
        );
        throw ServerException(message: message);
      }

      final message =
          'Khong the tai chi tiet binh luan (HTTP ${res.statusCode})';
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
      const message = 'Co loi xay ra khi tai chi tiet binh luan.';
      logApiFailure(
        source: source,
        data: {'message': message, 'error': e.toString()},
      );
      throw ServerException(message: message);
    }
  }
}
