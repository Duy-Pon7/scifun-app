import 'package:dio/dio.dart';
import 'package:thilop10_3004/common/models/response_model.dart';
import 'package:thilop10_3004/common/models/settings_model.dart';
import 'package:thilop10_3004/core/constants/api_urls.dart';
import 'package:thilop10_3004/core/constants/message_constants.dart';
import 'package:thilop10_3004/core/error/server_exception.dart';
import 'package:thilop10_3004/core/network/dio_client.dart';

abstract interface class SettingsRemoteDatasource {
  Future<List<SettingsModel>> getSettings();
}

class SettingsRemoteDatasourceImpl implements SettingsRemoteDatasource {
  final DioClient dioClient;

  SettingsRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<List<SettingsModel>> getSettings() async {
    try {
      final res = await dioClient.get(url: SettingsApiUrl.getSettings);

      if (res.statusCode != 200) {
        throw ServerException();
      }

      print("Settings response: ${res.data}");

      final responseData = ResponseModel<List<SettingsModel>>.fromJson(
        res.data,
        (json) => (json as List)
            .map((e) => SettingsModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

      if (responseData.status != 200 || responseData.data == null) {
        throw ServerException(message: MessageConstant.failedGetInfo);
      }

      return responseData.data!;
    } on ServerException {
      rethrow;
    } catch (e) {
      print("Lỗi không xác định khi lấy settings: $e");
      throw ServerException();
    }
  }
}
