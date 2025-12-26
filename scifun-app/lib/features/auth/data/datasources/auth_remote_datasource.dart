import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:sci_fun/common/models/response_model.dart';
import 'package:sci_fun/common/models/user_check_model.dart';
import 'package:sci_fun/common/models/user_model.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/constants/app_errors.dart';
import 'package:sci_fun/core/constants/app_successes.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/core/services/share_prefs_service.dart';

abstract interface class AuthRemoteDatasource {
  Future<UserModel?> login({
    required String email,
    required String password,
  });

  Future<UserModel?> signup({
    required String password,
    required String passwordConfimation,
    required String fullname,
    required String email,
  });

  Future<String> sendEmail({required String email});
  Future<String> forgotPassword({required String email});
  Future<UserCheckModel> checkEmailPhone({
    required String phone,
    required String email,
  });

  Future<String> verificationOtp({
    required String email,
    required String otp,
  });

  Future<bool> resendOtp({
    required String email,
  });

  Future<String> resetPassword({
    required String email,
    required String newPassword,
  });

  Future<String> changePassword({
    required String oldPass,
    required String newPass,
    required String newPassConfirm,
  });

  Future<UserModel?> getAuth();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final DioClient dioClient;
  final SharePrefsService sharePrefsService;

  AuthRemoteDatasourceImpl({
    required this.dioClient,
    required this.sharePrefsService,
  });

  String _extractServerMessage(dynamic data) {
    if (data == null) return AppErrors.commonError;

    if (data is Map<String, dynamic> && data['message'] is String) {
      return data['message'];
    }

    if (data is Map<String, dynamic> && data['message'] is List) {
      return data['message'].first.toString();
    }

    if (data is Map<String, dynamic> && data['message'] is Map) {
      final map = data['message'] as Map;
      if (map.isNotEmpty) {
        final firstValue = map.values.first;
        if (firstValue is List && firstValue.isNotEmpty) {
          return firstValue.first.toString();
        }
      }
    }

    return AppErrors.commonError;
  }

  @override
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await dioClient.post(
        url: AuthApiUrls.login,
        data: {
          "email": email,
          "password": password,
          "device_token": "z",
        },
      );

      final userModel = UserModel.fromJson(res.data);
      await sharePrefsService.saveAuthToken(userModel.token);
      await sharePrefsService.saveUserData(userModel.data?.id);

      return userModel;
    } on DioException catch (e) {
      throw ServerException(
        message: _extractServerMessage(e.response?.data),
      );
    }
  }

  @override
  Future<UserModel?> signup({
    required String password,
    required String passwordConfimation,
    required String fullname,
    required String email,
  }) async {
    try {
      final res = await dioClient.post(
        url: AuthApiUrls.signup,
        data: {
          "email": email,
          "password": password,
          "fullname": fullname,
        },
      );

      // Debug log: inspect server response for signup
      log('Signup response: ${res.data}');

      final data = res.data;

      if (data is Map<String, dynamic>) {
        // If backend returns an explicit status field, treat 200 as success
        final status = data['status'];
        if (status == null || status == 200) {
          return UserModel.fromJson(data);
        }

        // Non-success status -> throw with server message
        throw ServerException(message: _extractServerMessage(data));
      }

      // Fallback: try to parse whatever we got
      return UserModel.fromJson(res.data);
    } on DioException catch (e) {
      throw ServerException(
        message: _extractServerMessage(e.response?.data),
      );
    } catch (e) {
      // Parsing or unexpected errors -> wrap and surface friendly message
      log('Signup parsing error: $e');
      throw ServerException(message: AppErrors.commonError);
    }
  }

  @override
  Future<String> sendEmail({required String email}) async {
    try {
      await dioClient.post(
        url: AuthApiUrls.sendEmail,
        data: {
          "type": "email",
          "value": email,
        },
      );
      return AppSuccesses.successfullSendEmail;
    } on DioException catch (e) {
      throw ServerException(
        message: _extractServerMessage(e.response?.data),
      );
    }
  }

  @override
  Future<String> forgotPassword({required String email}) async {
    try {
      final res = await dioClient.post(
        url: AuthApiUrls.forgotPassword,
        data: {
          "email": email,
        },
      );

      return res.data['message'];
    } on DioException catch (e) {
      throw ServerException(
        message: _extractServerMessage(e.response?.data),
      );
    }
  }

  @override
  Future<UserModel?> getAuth() async {
    if (sharePrefsService.getAuthToken() == null) return null;

    try {
      final res = await dioClient.get(url: AuthApiUrls.getAuth);

      final returnedData = ResponseModel<UserModel>.fromJson(
        res.data,
        (json) => UserModel.fromJson(json as Map<String, dynamic>),
      );

      log(returnedData.data.toString());
      return returnedData.data;
    } on DioException catch (e) {
      throw ServerException(
        message: _extractServerMessage(e.response?.data),
      );
    }
  }

  @override
  Future<String> changePassword({
    required String oldPass,
    required String newPass,
    required String newPassConfirm,
  }) async {
    final userId = sharePrefsService.getUserData();
    if (userId == null) {
      throw ServerException(message: AppErrors.commonError);
    }

    try {
      final res = await dioClient.put(
        url: '${AuthApiUrls.updatePassword}/$userId',
        data: {
          "oldPassword": oldPass,
          "newPassword": newPass,
          "confirmPassword": newPassConfirm,
        },
      );

      return res.data['message'] ?? "Đổi mật khẩu thành công";
    } on DioException catch (e) {
      throw ServerException(
        message: _extractServerMessage(e.response?.data),
      );
    }
  }

  @override
  Future<UserCheckModel> checkEmailPhone({
    required String phone,
    required String email,
  }) async {
    try {
      final res = await dioClient.post(
        url: AuthApiUrls.checkEmailPhone,
        data: {
          "phone": phone,
          "email": email,
        },
      );

      return UserCheckModel.fromJson(res.data['data']);
    } on DioException catch (e) {
      throw ServerException(
        message: _extractServerMessage(e.response?.data),
      );
    }
  }

  @override
  Future<bool> resendOtp({required String email}) async {
    try {
      final res = await dioClient.post(
        url: AuthApiUrls.resendOtp,
        data: {
          "type": "email",
          "value": email,
        },
      );

      return res.data['data'] as bool;
    } on DioException catch (e) {
      throw ServerException(
        message: _extractServerMessage(e.response?.data),
      );
    }
  }

  @override
  Future<String> verificationOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final res = await dioClient.post(
        url: AuthApiUrls.verificationOtp,
        data: {
          "email": email,
          "otp": otp,
        },
      );

      return res.data['message'];
    } on DioException catch (e) {
      throw ServerException(
        message: _extractServerMessage(e.response?.data),
      );
    }
  }

  @override
  Future<String> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      final res = await dioClient.post(
        url: AuthApiUrls.resetPassword,
        data: {
          "email": email,
          "newPassword": newPassword,
        },
      );

      return res.data['message'] ?? AppSuccesses.resetPasswordSuccess;
    } on DioException catch (e) {
      throw ServerException(
        message: _extractServerMessage(e.response?.data),
      );
    }
  }
}
