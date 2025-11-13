import 'package:thilop10_3004/common/models/response_model.dart';
import 'package:thilop10_3004/core/constants/api_urls.dart';
import 'package:thilop10_3004/core/constants/message_constants.dart';
import 'package:thilop10_3004/core/error/server_exception.dart';
import 'package:thilop10_3004/core/network/dio_client.dart';
import 'package:thilop10_3004/features/analytics/data/model/school_data_model.dart';
import 'package:thilop10_3004/features/analytics/data/model/school_scores_model.dart';

abstract interface class SchoolRemoteDatasource {
  Future<SchoolScoresModel> getSchoolScore();
  Future<List<SchoolModel>> getListSchool({
    required int page,
    required int provinceId,
  });
  Future<List<SchoolDataModel>> getSchoolData(
      {required int year, required int provinceId});
}

class SchoolRemoteDatasourceImpl implements SchoolRemoteDatasource {
  final DioClient dioClient;

  SchoolRemoteDatasourceImpl({required this.dioClient});
  @override
  Future<List<SchoolDataModel>> getSchoolData(
      {required int year, required int provinceId}) async {
    print("year $year, provinceID $provinceId");
    try {
      final res = await dioClient.get(
        url:
            '${SchoolApiUrl.getSchoolScoreData}?year=$year&province_id=$provinceId',
      );

      if (res.statusCode != 200) {
        throw ServerException();
      }
      // Parse chung qua ResponseModel
      final responseData = ResponseModel<List<SchoolDataModel>>.fromJson(
        res.data,
        (json) => (json as List<dynamic>)
            .map((e) => SchoolDataModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

      print("res $res");
      if (responseData.status != 200 || responseData.data == null) {
        throw ServerException(message: MessageConstant.failure);
      }
      return responseData.data!;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<SchoolModel>> getListSchool({
    required int page,
    required int provinceId,
  }) async {
    try {
      final res = await dioClient.get(
        url: '${SchoolApiUrl.getListSchool}?page=$page&province_id=$provinceId',
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

      final schoolResultsJson = responseData.data?['schools'] as List<dynamic>?;

      if (schoolResultsJson == null) {
        throw ServerException(message: MessageConstant.failure);
      }
      print("schoolResultsJson: $schoolResultsJson");
      final List<SchoolModel> resultList = [];
      for (final item in schoolResultsJson) {
        try {
          final model = SchoolModel.fromJson(item as Map<String, dynamic>);
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

  @override
  Future<SchoolScoresModel> getSchoolScore() async {
    print("đang chạy");
    try {
      final res = await dioClient.get(
        url: SchoolApiUrl.getSchoolScore,
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

      // ✅ Parse dữ liệu sang SchoolScoresModel
      final schoolScore = SchoolScoresModel.fromJson(responseData.data!);

      return schoolScore;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
