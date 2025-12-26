import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:sci_fun/common/models/response_model.dart';
import 'package:sci_fun/common/models/user_get_model.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/constants/app_errors.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/core/network/dio_client.dart';

import '../../../../common/models/user_model.dart';

abstract interface class UserRemoteDatasource {
  Future<UserGetModel?> getUser({required String token});

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
  Future<UserGetModel?> getUser({required String token}) async {
    try {
      print("token in getUser: $token");

      final res = await dioClient.get(
        url: "${UserApiUrls.getInfo}$token",
      );

      print("Get User Response: ${res.data}");

      if (res.statusCode == 200) {
        return UserGetModel.fromJson(res.data);
      }

      // Log unexpected status
      log('getUser unexpected status: ${res.statusCode} ${res.data}');
      throw ServerException(message: AppErrors.getAuthFailure);
    } on DioException catch (e) {
      String mess = AppErrors.getAuthFailure;
      final errors = e.response?.data;

      // Log the DioException details for diagnosis
      log('getUser DioException: status=${e.response?.statusCode} data=${e.response?.data} message=${e.message}');

      if (errors is Map<String, dynamic>) {
        mess = errors['message'] ?? mess;
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

      MultipartFile? avatarMultipart;
      if (avatar != null) {
        final fileName = p.basename(avatar.path);
        final mimeType =
            lookupMimeType(avatar.path) ?? 'application/octet-stream';
        final parts = mimeType.split('/');

        avatarMultipart = await MultipartFile.fromFile(
          avatar.path,
          filename: fileName,
          contentType: MediaType(parts[0], parts[1]),
        );
      }

      FormData formData = FormData.fromMap({
        "fullname": fullname,
        "sex": sex,
        "dob": DateFormat("yyyy-MM-dd").format(dob),
        if (avatarMultipart != null) "avatar": avatarMultipart,
      });

      // Log a short summary of the outgoing form (do NOT log binary content)
      log('Sending updateInfoUser request: userId=$userId, fullname=$fullname, dob=${DateFormat("yyyy-MM-dd").format(dob)}, sex=$sex, hasAvatar=${avatar != null}');

      final res = await dioClient.put(
        url: "${UserApiUrls.updateInfo}$userId",
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      print("Update User Response: ${res.data}");

      if (res.statusCode == 200) {
        // Parse API response directly using UserModel.fromJson
        log('Update status 200, response: ${res.data}');

        // API returns data directly, convert to UserModel
        final userData = res.data is Map<String, dynamic>
            ? UserModel.fromJson(res.data)
            : null;

        if (userData == null) {
          log('Update returned no data');
          return null;
        }
        log('Update returned user: $userData');
        return userData;
      }

      throw ServerException(message: AppErrors.getAuthFailure);
    } on DioException catch (e) {
      final errors = e.response?.data;
      String mess = AppErrors.getAuthFailure;

      // Extra logs for diagnosis
      log('updateInfoUser DioException: status=${e.response?.statusCode} data=${e.response?.data} message=${e.message}');

      if (errors is Map<String, dynamic>) {
        mess = errors['message'] ?? mess;
      }
      throw ServerException(message: mess);
    }
  }
}
