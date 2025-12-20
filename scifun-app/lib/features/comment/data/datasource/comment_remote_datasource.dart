import 'package:dio/dio.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/features/comment/data/model/comment_model.dart';

abstract interface class CommentRemoteDatasource {
  Future<List<CommentModel>> getComments({int page, int limit});
  Future<List<CommentModel>> getReplies(String parentId, {int page, int limit});
  Future<CommentModel> getCommentDetail(String id);
}

class CommentRemoteDatasourceImpl implements CommentRemoteDatasource {
  final DioClient dioClient;

  CommentRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<List<CommentModel>> getComments({int page = 1, int limit = 10}) async {
    try {
      final res = await dioClient.get(
          url: "${CommentApiUrl.getComments}?page=$page&limit=$limit");
      if (res.statusCode == 200) {
        final List<dynamic> data = res.data['data']['items'];
        return data
            .map((json) => CommentModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
            message: 'Không thể tải bình luận (HTTP ${res.statusCode})');
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
      throw ServerException(message: 'Có lỗi xảy ra khi tải bình luận.');
    }
  }

  @override
  Future<List<CommentModel>> getReplies(String parentId,
      {int page = 1, int limit = 10}) async {
    try {
      final res = await dioClient.get(
          url: "${CommentApiUrl.getReplies(parentId)}?page=$page&limit=$limit");
      if (res.statusCode == 200) {
        final List<dynamic> data = res.data['data']['items'];
        return data
            .map((json) => CommentModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
            message: 'Không thể tải câu trả lời (HTTP ${res.statusCode})');
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
      throw ServerException(message: 'Có lỗi xảy ra khi tải câu trả lời.');
    }
  }

  @override
  Future<CommentModel> getCommentDetail(String id) async {
    try {
      final res = await dioClient.get(url: CommentApiUrl.getCommentById(id));
      if (res.statusCode == 200) {
        final dynamic data = res.data['data'];
        if (data is Map<String, dynamic>) {
          return CommentModel.fromJson(data);
        }
        // Some APIs wrap the item, try to extract
        if (data is Map && data['item'] is Map) {
          return CommentModel.fromJson(data['item'] as Map<String, dynamic>);
        }
        throw ServerException(
            message: 'Dữ liệu chi tiết bình luận không đúng định dạng');
      } else {
        throw ServerException(
            message:
                'Không thể tải chi tiết bình luận (HTTP ${res.statusCode})');
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
      throw ServerException(
          message: 'Có lỗi xảy ra khi tải chi tiết bình luận.');
    }
  }
}
