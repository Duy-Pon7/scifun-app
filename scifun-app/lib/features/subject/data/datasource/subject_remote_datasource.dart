import 'package:dio/dio.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/features/subject/data/model/subject_model.dart';

abstract interface class SubjectRemoteDatasource {
  Future<List<SubjectModel>> getAllSubjects(String? searchQuery);
}

class SubjectRemoteDatasourceImpl implements SubjectRemoteDatasource {
  final DioClient dioClient;

  SubjectRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<List<SubjectModel>> getAllSubjects(
    String? searchQuery,
  ) async {
    try {
      final res = await dioClient.get(
          url:
              "${SubjectApiUrl.getSubjects}?page=1&limit=10&search=$searchQuery");
      if (res.statusCode == 200) {
        final List<dynamic> data = res.data['data']['subjects'];
        return data
            .map((subjectJson) =>
                SubjectModel.fromJson(subjectJson as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
            message:
                'Không thể tải danh sách môn học (HTTP ${res.statusCode})');
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
      throw ServerException(message: 'Có lỗi xảy ra khi tải môn học.');
    }
  }
}
