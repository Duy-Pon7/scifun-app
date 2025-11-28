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
  // Future<UserModel?> changeUser(
  //     {required String fullname,
  //     required DateTime birthday,
  //     required int gender,
  //     required int provinceId,
  //     required int wardId,
  //     required String email,
  //     File? image});

  Future<UserModel?> getUser({required String token});
}

class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  final DioClient dioClient;

  UserRemoteDatasourceImpl({required this.dioClient});

  // String _getErrorMessage(Map<String, dynamic> errors) {
  //   String mess = AppErrors.commonError;
  //   if (errors.containsKey('message_validate')) {
  //     final validates = errors['message_validate'] as Map<String, dynamic>;
  //     if (validates.containsKey('email')) {
  //       mess = validates['email'].first;
  //     } else if (validates.containsKey('password')) {
  //       mess = validates['password'].first;
  //     } else if (validates.containsKey('birthday')) {
  //       mess = validates['birthday'].first;
  //     } else if (validates.containsKey('gender')) {
  //       mess = validates['gender'].first;
  //     } else if (validates.containsKey('fullname')) {
  //       mess = validates['fullname'].first;
  //     } else if (validates.containsKey('phone')) {
  //       mess = validates['phone'].first;
  //     } else if (validates.containsKey('otp')) {
  //       mess = validates['otp'].first;
  //     }
  //   } else if (errors.containsKey('message')) {
  //     mess = errors['message'] as String;
  //   }
  //   return mess;
  // }

  @override
  Future<UserModel?> getUser({required String token}) async {
    try {
      final res = await dioClient.get(url: UserApiUrls.getInfo);
      print("Get User Response: ${res.data}");
      if (res.statusCode == 200) {
        final returnedData = ResponseModel<UserModel>.fromJson(
          res.data,
          (json) => UserModel.fromJson(
            json as Map<String, dynamic>,
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

  // @override
  // Future<UserModel?> changeUser({
  //   required String fullname,
  //   required int gender,
  //   required DateTime birthday,
  //   required int provinceId,
  //   required int wardId,
  //   required String email,
  //   File? image,
  // }) async {
  //   log("PUT ${UserApiUrls.reviseInfo}");
  //   log(
  //     "BODY => fullname: $fullname, gender: $gender, provinceId: $provinceId, wardId: $wardId",
  //   );

  //   final formData = FormData.fromMap({
  //     "fullname": fullname,
  //     "email": email,
  //     "birthday": birthday.toIso8601String().split('T').first,
  //     "gender": gender,
  //     "province_id": provinceId,
  //     "ward_id": wardId,
  //     if (image != null)
  //       "avatar": await MultipartFile.fromFile(
  //         image.path,
  //         filename: image.path.split('/').last,
  //       ),
  //   });

  //   return await _getUser(
  //     () => dioClient.post(
  //       url: UserApiUrls.reviseInfo,
  //       data: formData,
  //       options: Options(contentType: 'multipart/form-data'), // 👈 quan trọng
  //     ),
  //   );
  // }

  // Future<UserModel?> _getUser(
  //   Future<Response<dynamic>> Function() func,
  // ) async {
  //   try {
  //     final res = await func();
  //     if (res.statusCode == 200) {
  //       final returnedData = ResponseModel<UserModel>.fromJson(
  //         res.data,
  //         (json) => UserModel.fromJson(
  //           json as Map<String, dynamic>,
  //         ),
  //       );
  //       if (returnedData.data == null) {
  //         return null;
  //       }
  //       log(returnedData.data.toString());
  //       return returnedData.data!;
  //     }
  //     throw ServerException(message: AppErrors.getAuthFailure);
  //   } on DioException catch (e) {
  //     String mess = AppErrors.commonError;
  //     final errors = e.response?.data;
  //     if (errors != null) {
  //       mess = errors is Map<String, dynamic>
  //           ? _getErrorMessage(errors)
  //           : AppErrors.commonError;
  //     }
  //     throw ServerException(message: mess);
  //   }
  // }
}
