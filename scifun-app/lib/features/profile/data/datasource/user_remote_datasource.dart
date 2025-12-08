import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sci_fun/common/models/response_model.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/constants/app_errors.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/core/network/dio_client.dart';

import '../../../../common/models/user_model.dart';

abstract interface class UserRemoteDatasource {
  Future<UserModel?> getUser({required String token});

  Future<UserModel?> updateInfoUser({
    required String userId,
    required String fullname,
    required DateTime dob,
    required int sex,
    File? avatar,
  });
}

class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  final DioClient dioClient;

  UserRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<UserModel?> getUser({required String token}) async {
    try {
      print("token in getUser: $token");
      final res = await dioClient.get(
        url: "${UserApiUrls.getInfo}$token",
      );
      print("Get User Response: ${res.data}");
      if (res.statusCode == 200) {
        final returnedData = ResponseModel<UserModel>.fromJson(
          res.data,
          (json) => UserModel.fromJson(
            {
              'status': res.data['status'],
              'message': res.data['message'],
              'token': res.data['token'],
              'data': json,
            },
          ),
        );
        if (returnedData.data == null) {
          return null;
        }
        log(returnedData.data.toString());
        return returnedData.data!;
      }
      throw ServerException(message: AppErrors.getAuthFailure);
    } on DioException catch (e) {
      String mess = AppErrors.getAuthFailure;
      final errors = e.response?.data;
      if (errors != null && errors is Map<String, dynamic>) {
        mess = errors['message'] ?? AppErrors.getAuthFailure;
      }
      throw ServerException(message: mess);
    }
  }

  @override
  Future<UserModel?> updateInfoUser({
    required String userId,
    required String fullname,
    required DateTime dob,
    required int sex,
    File? avatar,
  }) async {
    try {
      log("PUT ${UserApiUrls.updateInfo}$userId");
      log("BODY => fullname: $fullname, dob: $dob, sex: $sex");

      final formData = FormData.fromMap({
        "fullname": fullname,
        "dob": dob.toIso8601String().split('T').first,
        "sex": sex,
        if (avatar != null)
          "avatar": await MultipartFile.fromFile(
            avatar.path,
            filename: avatar.path.split('/').last,
          ),
      });

      final res = await dioClient.put(
        url: "${UserApiUrls.updateInfo}$userId",
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      print("Update User Response: ${res.data}");
      if (res.statusCode == 200) {
        final returnedData = ResponseModel<UserModel>.fromJson(
          res.data,
          (json) => UserModel.fromJson(
            {
              'status': res.data['status'],
              'message': res.data['message'],
              'token': res.data['token'],
              'data': json,
            },
          ),
        );
        if (returnedData.data == null) {
          return null;
        }
        log(returnedData.data.toString());
        return returnedData.data!;
      }
      throw ServerException(message: AppErrors.getAuthFailure);
    } on DioException catch (e) {
      String mess = AppErrors.getAuthFailure;
      final errors = e.response?.data;
      if (errors != null && errors is Map<String, dynamic>) {
        mess = errors['message'] ?? AppErrors.getAuthFailure;
      }
      throw ServerException(message: mess);
    }
  }
}
