import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:sci_fun/common/helper/log_debug.dart';
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
    required String level,
    File? avatar,
  });
}

class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  final DioClient dioClient;

  UserRemoteDatasourceImpl({required this.dioClient});

  @override
  Future<UserGetModel?> getUser({required String token}) async {
    const source = 'UserRemoteDatasource.getUser';
    try {
      final res = await dioClient.get(url: '${UserApiUrls.getInfo}$token');
      if (res.statusCode == 200) {
        final user = UserGetModel.fromJson(res.data);
        logApiSuccess(
          source: source,
          data: {'token': token, 'response': res.data},
        );
        return user;
      }

      logApiFailure(
        source: source,
        data: {
          'message': AppErrors.getAuthFailure,
          'token': token,
          'statusCode': res.statusCode,
          'response': res.data,
        },
      );
      throw ServerException(message: AppErrors.getAuthFailure);
    } on DioException catch (e) {
      String message = AppErrors.getAuthFailure;
      final errors = e.response?.data;
      if (errors is Map<String, dynamic>) {
        message = errors['message']?.toString() ?? message;
      }

      logApiFailure(
        source: source,
        data: {
          'message': message,
          'token': token,
          'error': e.toString(),
          'response': e.response?.data,
        },
      );
      throw ServerException(message: message);
    }
  }

  @override
  Future<UserModel?> updateInfoUser({
    required String userId,
    required String fullname,
    required DateTime dob,
    required int sex,
    required String level,
    File? avatar,
  }) async {
    const source = 'UserRemoteDatasource.updateInfoUser';
    try {
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

      final formData = FormData.fromMap({
        'fullname': fullname,
        'sex': sex,
        'dob': DateFormat('yyyy-MM-dd').format(dob),
        'level': level,
        if (avatarMultipart != null) 'avatar': avatarMultipart,
      });

      final res = await dioClient.put(
        url: '${UserApiUrls.updateInfo}$userId',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (res.statusCode == 200) {
        final userData = res.data is Map<String, dynamic>
            ? UserModel.fromJson(res.data)
            : null;
        logApiSuccess(
          source: source,
          data: {
            'userId': userId,
            'hasAvatar': avatar != null,
            'response': res.data,
          },
        );
        return userData;
      }

      logApiFailure(
        source: source,
        data: {
          'message': AppErrors.getAuthFailure,
          'userId': userId,
          'statusCode': res.statusCode,
          'response': res.data,
        },
      );
      throw ServerException(message: AppErrors.getAuthFailure);
    } on DioException catch (e) {
      final errors = e.response?.data;
      String message = AppErrors.getAuthFailure;

      if (errors is Map<String, dynamic>) {
        message = errors['message']?.toString() ?? message;
      }

      logApiFailure(
        source: source,
        data: {
          'message': message,
          'userId': userId,
          'error': e.toString(),
          'response': e.response?.data,
        },
      );
      throw ServerException(message: message);
    }
  }
}
