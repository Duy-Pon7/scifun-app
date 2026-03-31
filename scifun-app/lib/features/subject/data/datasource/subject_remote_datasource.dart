import 'package:dio/dio.dart';
import 'package:sci_fun/common/helper/log_debug.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/features/subject/data/model/subject_model.dart';

abstract interface class SubjectRemoteDatasource {
  Future<List<SubjectModel>> getAllSubjects(String? searchQuery);
}

class SubjectRemoteDatasourceImpl implements SubjectRemoteDatasource {
  final DioClient dioClient;

  SubjectRemoteDatasourceImpl({required this.dioClient});

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
  Future<List<SubjectModel>> getAllSubjects(String? searchQuery) async {
    const source = 'SubjectRemoteDatasource.getAllSubjects';
    try {
      final res = await dioClient.get(
        url:
            '${SubjectApiUrl.getSubjects}?page=1&limit=100&search=$searchQuery',
      );

      if (res.statusCode == 200) {
        final List<dynamic> data = res.data['data']['subjects'];
        final subjects = data
            .map((subjectJson) =>
                SubjectModel.fromJson(subjectJson as Map<String, dynamic>))
            .toList();
        logApiSuccess(
          source: source,
          data: {'count': subjects.length, 'response': res.data},
        );
        return subjects;
      }

      final message =
          'Khong the tai danh sach mon hoc (HTTP ${res.statusCode})';
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
      const message = 'Co loi xay ra khi tai mon hoc.';
      logApiFailure(
        source: source,
        data: {'message': message, 'error': e.toString()},
      );
      throw ServerException(message: message);
    }
  }
}
