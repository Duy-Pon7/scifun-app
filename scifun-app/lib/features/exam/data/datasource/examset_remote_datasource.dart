import 'package:thilop10_3004/common/models/response_model.dart';
import 'package:thilop10_3004/core/constants/api_urls.dart';
import 'package:thilop10_3004/core/constants/message_constants.dart';
import 'package:thilop10_3004/core/error/server_exception.dart';
import 'package:thilop10_3004/core/network/dio_client.dart';
import 'package:thilop10_3004/features/exam/data/model/examset_model.dart';
import 'package:thilop10_3004/features/home/data/model/quizz_model.dart';

abstract interface class ExamsetRemoteDatasource {
  Future<List<ExamsetModel>> getAllExamsets({required int page});
  Future<QuizzModel> getQuizzExamsets(
      {required int examSetId, required int subjectId});
}

class ExamsetRemoteDatasourceImpl implements ExamsetRemoteDatasource {
  final DioClient dioClient;

  ExamsetRemoteDatasourceImpl({required this.dioClient});
  @override
  Future<QuizzModel> getQuizzExamsets(
      {required int examSetId, required int subjectId}) async {
    try {
      final res = await dioClient.get(
        url:
            "${ExamsetApiUrl.getExamsetQuizz}?subject_id=$subjectId&exam_set_id=$examSetId",
      );
      if (res.statusCode != 200) {
        throw ServerException();
      }

      final responseData = ResponseModel<List<dynamic>>.fromJson(
        res.data,
        (json) => json as List<dynamic>,
      );

      if (responseData.status != 200 ||
          responseData.data == null ||
          responseData.data!.isEmpty) {
        throw ServerException(message: MessageConstant.failure);
      }
      print(res);
      final quiz =
          QuizzModel.fromJson(responseData.data!.first as Map<String, dynamic>);
      return quiz;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<ExamsetModel>> getAllExamsets({required int page}) async {
    try {
      final res = await dioClient.get(
        url: "${ExamsetApiUrl.getExamset}?page=$page&limit=10",
      );

      if (res.statusCode != 200) {
        throw ServerException();
      }
      final dataList = res.data["data"]["exam_sets"];
      if (dataList == null || dataList is! List) {
        throw ServerException(message: "Dữ liệu không hợp lệ.");
      }

      final List<ExamsetModel> examsets = dataList.map<ExamsetModel>((item) {
        return ExamsetModel.fromJson(item as Map<String, dynamic>);
      }).toList();

      return examsets;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
