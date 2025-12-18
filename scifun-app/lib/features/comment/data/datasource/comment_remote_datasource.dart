import 'package:sci_fun/core/constants/api_urls.dart';
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
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      throw Exception('Failed to load comments: $e');
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
        throw Exception('Failed to load replies');
      }
    } catch (e) {
      throw Exception('Failed to load replies: $e');
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
        throw Exception('Unexpected comment detail format');
      } else {
        throw Exception('Failed to load comment detail');
      }
    } catch (e) {
      throw Exception('Failed to load comment detail: $e');
    }
  }
}
