import 'package:sci_fun/common/models/response_model.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/constants/message_constants.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/features/subject/data/model/subject_model.dart';

abstract interface class SubjectRemoteDatasource {
  Future<SubjectModel> getAllSubjects();
}

class SubjectRemoteDatasourceImpl implements SubjectRemoteDatasource {
  final DioClient dioClient;

  SubjectRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<SubjectModel> getAllSubjects() async {
    try {
      final res = await dioClient.get(
          url: "${SubjectApiUrl.getSubjects}?page=1&limit=10");
      if (res.statusCode != 200) {
        throw ServerException();
      }

      final responseData = ResponseModel<SubjectModel>.fromJson(res.data,
          (json) => SubjectModel.fromJson(json as Map<String, dynamic>));

      if (responseData.status != 200 || responseData.data == null) {
        throw ServerException(message: MessageConstant.failedGetInfo);
      }

      return responseData.data!;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException();
    }
  }
}
