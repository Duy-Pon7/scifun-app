import 'package:thilop10_3004/common/models/province_model.dart';
import 'package:thilop10_3004/common/models/response_model.dart';
import 'package:thilop10_3004/core/constants/api_urls.dart';
import 'package:thilop10_3004/core/constants/message_constants.dart';
import 'package:thilop10_3004/core/error/server_exception.dart';
import 'package:thilop10_3004/core/network/dio_client.dart';

abstract interface class AddressRemoteDatasource {
  Future<List<ProvinceModel>> getProvinces();
  Future<List<ProvinceModel>> getWards({required int wardId});
}

class AddressRemoteDatasourceImpl implements AddressRemoteDatasource {
  final DioClient dioClient;

  AddressRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<List<ProvinceModel>> getProvinces() async {
    try {
      final res = await dioClient.get(
        url: AddressApiUrl.getProvinces,
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

      // ✅ Chuyển từng phần tử trong danh sách thành ProvinceModel
      final provinces = responseData.data!
          .map((e) => ProvinceModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return provinces;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<ProvinceModel>> getWards({required int wardId}) async {
    try {
      final res = await dioClient.get(
        url: "${AddressApiUrl.getWards}/$wardId",
      );

      if (res.statusCode != 200) {
        throw ServerException();
      }

      final responseData = ResponseModel<List<dynamic>>.fromJson(
        res.data,
        (json) => json as List<dynamic>,
      );
      print("ward $res");
      if (responseData.status != 200 ||
          responseData.data == null ||
          responseData.data!.isEmpty) {
        throw ServerException(message: MessageConstant.failure);
      }

      // ✅ Chuyển từng phần tử trong danh sách thành ProvinceModel
      final wards = responseData.data!
          .map((e) => ProvinceModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return wards;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException();
    }
  }
}
