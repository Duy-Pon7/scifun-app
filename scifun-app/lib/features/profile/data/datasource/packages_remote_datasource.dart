import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sci_fun/common/models/response_model.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/constants/message_constants.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/features/profile/data/models/instructions_model.dart';
import 'package:sci_fun/features/profile/data/models/package_history_model.dart';
import 'package:sci_fun/features/profile/data/models/packages_model.dart';

abstract interface class PackagesRemoteDatasource {
  Future<List<NotificationModel>> getHistoryPackage({
    required int page,
  });
  Future<List<PackagesModel>> getpackages();
  Future<List<InstructionsModel>> getInstructions();
  Future<void> buyPackages({required int id, required File image});
}

class PackagesRemoteDatasourceImpl implements PackagesRemoteDatasource {
  final DioClient dioClient;

  PackagesRemoteDatasourceImpl({required this.dioClient});
  @override
  Future<List<InstructionsModel>> getInstructions() async {
    final res = await dioClient.get(url: PackagesApiUrl.instructionsPackages);
    if (res.statusCode != 200) {
      throw ServerException();
    }

    final responseData = ResponseModel<List<InstructionsModel>>.fromJson(
      res.data,
      (json) => (json as List)
          .map((e) => InstructionsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

    if (responseData.status != 200 || responseData.data == null) {
      throw ServerException(message: MessageConstant.failedGetInfo);
    }

    return responseData.data!;
  }

  @override
  Future<void> buyPackages({required int id, required File image}) async {
    try {
      final formData = FormData.fromMap({
        'id': id,
        'payment_confirmation_image': await MultipartFile.fromFile(image.path,
            filename: image.path.split('/').last),
      });

      final res = await dioClient.post(
        url: PackagesApiUrl.buyPackages,
        data: formData,
      );

      if (res.statusCode != 200) {
        throw ServerException();
      }

      final responseData = ResponseModel<dynamic>.fromJson(
        res.data,
        (data) => data,
      );

      if (responseData.status != 200) {
        throw ServerException(
            message: responseData.message ?? MessageConstant.failedGetInfo);
      }

      print("Mua gói thành công");
    } on ServerException {
      rethrow;
    } catch (e) {
      print("Lỗi không xác định khi mua gói: $e");
      throw ServerException();
    }
  }

  @override
  Future<List<PackagesModel>> getpackages() async {
    try {
      final res = await dioClient.get(url: PackagesApiUrl.getPackages);
      if (res.statusCode != 200) {
        throw ServerException();
      }


      final responseData = ResponseModel<List<PackagesModel>>.fromJson(
        res.data,
        (json) => (json as List)
            .map((e) => PackagesModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

      if (responseData.status != 200 || responseData.data == null) {
        throw ServerException(message: MessageConstant.failedGetInfo);
      }

      return responseData.data!;
    } on ServerException {
      rethrow;
    } catch (e) {
      print("Lỗi không xác định: $e");
      throw ServerException();
    }
  }

  @override
  Future<List<NotificationModel>> getHistoryPackage({required int page}) async {
    try {
      final res = await dioClient.get(
        url: '${PackagesApiUrl.historyPackages}?page=$page',
      );

      if (res.statusCode == 200) {
        final json = res.data;

        final data = json['data'] as Map<String, dynamic>? ?? {};
        final notificationsJson = data['notifications'] as List<dynamic>? ?? [];

        final notifications = notificationsJson
            .map((e) => NotificationModel.fromJson(e))
            .toList();

        return notifications;
      } else {
        throw ServerException(message: res.statusMessage ?? 'Unknown error');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
