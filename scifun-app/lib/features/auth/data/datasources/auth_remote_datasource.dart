import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:sci_fun/common/models/response_model.dart';
import 'package:sci_fun/common/models/user_check_model.dart';
import 'package:sci_fun/common/models/user_model.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/constants/app_errors.dart';
import 'package:sci_fun/core/constants/app_successes.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/core/network/dio_client.dart';

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
  Future<UserCheckModel> checkEmailPhone(
      {required String phone, required String email});

  Future<String> otpVerifyOtp({required String email, required String otp});
  Future<String> verificationOtp({
    required String email,
    required String otp,
  });
  Future<UserModel?> resetPassword({
    required String email,
    required String newPass,
    required String newPassConfirm,
  });
  Future<bool> resendOtp({
    required String email,
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

  AuthRemoteDatasourceImpl({required this.dioClient});

  String _getErrorMessage(Map<String, dynamic> errors) {
    String mess = AppErrors.commonError;
    if (errors.containsKey('message_validate')) {
      final validates = errors['message_validate'] as Map<String, dynamic>;
      if (validates.containsKey('email')) {
        mess = validates['email'].first;
      } else if (validates.containsKey('password')) {
        mess = validates['password'].first;
      } else if (validates.containsKey('old_password')) {
        mess = validates['old_password'].first;
      } else if (validates.containsKey('birthday')) {
        mess = validates['birthday'].first;
      } else if (validates.containsKey('gender')) {
        mess = validates['gender'].first;
      } else if (validates.containsKey('fullname')) {
        mess = validates['fullname'].first;
      } else if (validates.containsKey('phone')) {
        mess = validates['phone'].first;
      } else if (validates.containsKey('otp')) {
        mess = validates['otp'].first;
      }
    } else if (errors.containsKey('message')) {
      mess = errors['message'] as String;
    }
    return mess;
  }

  @override
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      print("🔄 Attempting login for email: $email");
      final res = await dioClient.post(
        url: AuthApiUrls.login,
        data: {"email": email, "password": password, "device_token": "z"},
      );
      print("✅ Login Response status: ${res.statusCode}");
      print("✅ Login Response data: ${res.data}");

      if (res.statusCode == 200) {
        final userModel = UserModel.fromJson(res.data);
        print("✅ UserModel created: ${userModel.token}");

        if (userModel.token == null) {
          print("❌ Token is null");
          throw ServerException(message: AppErrors.failureLogin);
        }
        return userModel;
      }

      print("❌ Unexpected status code: ${res.statusCode}");
      return null;
    } on DioException catch (e) {
      print("❌ DioException: ${e.message}");
      print("❌ Response data: ${e.response?.data}");
      print("❌ Response status: ${e.response?.statusCode}");

      String mess = AppErrors.commonError;
      final errors = e.response?.data;
      if (errors != null) {
        mess = errors is Map<String, dynamic>
            ? _getErrorMessage(errors)
            : AppErrors.commonError;
      }
      throw ServerException(message: mess);
    } catch (e) {
      print("❌ Unexpected error: $e");
      throw ServerException(message: AppErrors.commonError);
    }
  }

  @override
  Future<UserModel?> signup({
    required String password,
    required String passwordConfimation,
    required String fullname,
    required String email,
  }) async {
    print("🔄 Attempting signup for email: $email");
    try {
      final res = await dioClient.post(
        url: AuthApiUrls.signup,
        data: {"email": email, "password": password, "fullname": fullname},
      );
      print("✅ Signup Response status: ${res.statusCode}");
      print("✅ Signup Response data: ${res.data}");

      if (res.statusCode == 200) {
        final userModel = UserModel.fromJson(res.data);
        return userModel;
      }

      throw ServerException(message: AppErrors.getAuthFailure);
    } on DioException catch (e) {
      print("❌ DioException in signup: ${e.message}");
      print("❌ Response data: ${e.response?.data}");
      print("❌ Response status: ${e.response?.statusCode}");

      String mess = AppErrors.commonError;
      final errors = e.response?.data;
      if (errors != null) {
        mess = errors is Map<String, dynamic>
            ? _getErrorMessage(errors)
            : AppErrors.commonError;
      }
      throw ServerException(message: mess);
    } catch (e) {
      print("❌ Unexpected error in signup: $e");
      throw ServerException(message: AppErrors.commonError);
    }
  }

  @override
  Future<String> sendEmail({required String email}) async {
    try {
      final res = await dioClient.post(url: AuthApiUrls.sendEmail, data: {
        "type": "email",
        "value": email,
      });
      if (res.statusCode == 200) {
        return AppSuccesses.successfullSendEmail;
      }
      return AppErrors.failureSendEmail;
    } on DioException catch (e) {
      String mess = AppErrors.commonError;
      final errors = e.response?.data;
      if (errors != null) {
        mess = errors is Map<String, dynamic>
            ? _getErrorMessage(errors)
            : AppErrors.commonError;
      }
      throw ServerException(message: mess);
    }
  }

  @override
  Future<String> otpVerifyOtp(
      {required String email, required String otp}) async {
    try {
      print("otp in datasource $otp");
      final res = await dioClient.post(url: AuthApiUrls.verifyOtp, data: {
        "value": email,
        "type": "email",
        "otp": otp,
      });
      if (res.statusCode == 200) {
        return AppSuccesses.successfullSendEmail;
      }
      return AppErrors.failureSendEmail;
    } on DioException catch (e) {
      String mess = AppErrors.commonError;
      final errors = e.response?.data;
      if (errors != null) {
        mess = errors is Map<String, dynamic>
            ? _getErrorMessage(errors)
            : AppErrors.commonError;
      }
      throw ServerException(message: mess);
    }
  }

  @override
  Future<UserModel?> resetPassword({
    required String email,
    required String newPass,
    required String newPassConfirm,
  }) async {
    return await _getUser(
      () => dioClient.put(
        url: AuthApiUrls.resetPassword,
        data: {
          "type": "email",
          "email": email,
          "password": newPass,
          "password_confirmation": newPassConfirm
        },
      ),
    );
  }

  @override
  Future<UserModel?> getAuth() async {
    return await _getUser(
      () => dioClient.get(url: AuthApiUrls.getAuth),
    );
  }

  @override
  Future<String> changePassword({
    required String oldPass,
    required String newPass,
    required String newPassConfirm,
  }) async {
    try {
      final res = await dioClient.put(
        url: UserApiUrls.changePassword,
        data: {
          "old_password": oldPass,
          "password": newPass,
          "password_confirmation": newPassConfirm,
        },
      );

      if (res.statusCode == 200) {
        // Trả về message từ backend hoặc gắn cố định nếu bạn muốn
        return res.data['message'] ?? "Đổi mật khẩu thành công";
      }

      throw ServerException(message: AppErrors.getAuthFailure);
    } on DioException catch (e) {
      String mess = AppErrors.commonError;
      final errors = e.response?.data;
      if (errors != null) {
        mess = errors is Map<String, dynamic>
            ? _getErrorMessage(errors)
            : AppErrors.commonError;
      }
      throw ServerException(message: mess);
    }
  }

  Future<UserModel?> _getUser(
    Future<Response<dynamic>> Function() func,
  ) async {
    try {
      final res = await func();
      print("Get User Response status: ${res}");
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
      String mess = AppErrors.commonError;
      final errors = e.response?.data;
      if (errors != null) {
        mess = errors is Map<String, dynamic>
            ? _getErrorMessage(errors)
            : AppErrors.commonError;
      }
      throw ServerException(message: mess);
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
      if (res.statusCode == 200) {
        final data = res.data['data'];
        return UserCheckModel.fromJson(data);
      }

      throw ServerException(message: AppErrors.getAuthFailure);
    } on DioException catch (e) {
      String mess = AppErrors.commonError;
      final errors = e.response?.data;
      if (errors != null) {
        mess = errors is Map<String, dynamic>
            ? _getErrorMessage(errors)
            : AppErrors.commonError;
      }
      throw ServerException(message: mess);
    }
  }

  @override
  Future<bool> resendOtp({
    required String email,
  }) async {
    try {
      final res = await dioClient.post(
        url: AuthApiUrls.resendOtp,
        data: {
          "type": "email",
          "value": email,
        },
      );
      if (res.statusCode == 200) {
        final data = res.data['data'];
        return data as bool;
      }

      throw ServerException(message: AppErrors.getAuthFailure);
    } on DioException catch (e) {
      String mess = AppErrors.commonError;
      final errors = e.response?.data;
      if (errors != null) {
        mess = errors is Map<String, dynamic>
            ? _getErrorMessage(errors)
            : AppErrors.commonError;
      }
      throw ServerException(message: mess);
    }
  }

  @override
  Future<String> verificationOtp({
    required String email,
    required String otp,
  }) async {
    try {
      print("otp in datasource $otp");
      final res = await dioClient.post(
        url: AuthApiUrls.verificationOtp,
        data: {"email": email, "otp": otp},
      );
      print("Response status: ${res.statusCode}");
      print("Response data: ${res.data}");
      if (res.statusCode == 200) {
        final status = res.data['status'];
        final message = res.data['message'] ?? AppErrors.commonError;

        if (status == 200) {
          // OTP đúng
          return message;
        } else {
          // OTP sai hoặc backend báo lỗi
          throw ServerException(message: message);
        }
      }

      throw ServerException(message: AppErrors.getAuthFailure);
    } on DioException catch (e) {
      print("DioException: ${e.message}");
      print("Response data: ${e.response?.data}");
      print("Response status: ${e.response?.statusCode}");

      String mess = AppErrors.commonError;
      final errors = e.response?.data;
      if (errors != null) {
        mess = errors is Map<String, dynamic>
            ? _getErrorMessage(errors)
            : AppErrors.commonError;
      }
      throw ServerException(message: mess);
    }
  }
}
