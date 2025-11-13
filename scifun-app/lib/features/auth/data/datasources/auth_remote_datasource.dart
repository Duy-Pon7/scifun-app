import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:thilop10_3004/common/models/response_model.dart';
import 'package:thilop10_3004/common/models/user_check_model.dart';
import 'package:thilop10_3004/common/models/user_model.dart';
import 'package:thilop10_3004/core/constants/api_urls.dart';
import 'package:thilop10_3004/core/constants/app_errors.dart';
import 'package:thilop10_3004/core/constants/app_successes.dart';
import 'package:thilop10_3004/core/error/server_exception.dart';
import 'package:thilop10_3004/core/network/dio_client.dart';
import 'package:thilop10_3004/features/auth/data/repositories/auth_repository_impl.dart';

abstract interface class AuthRemoteDatasource {
  Future<LoginResponseModel?> login({
    required String phone,
    required String password,
  });

  Future<UserModel?> signup({
    required String phone,
    required String password,
    required String passwordConfimation,
    required String fullname,
    required int provinceId,
    required int wardId,
    required DateTime birthday,
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
  Future<LoginResponseModel?> login({
    required String phone,
    required String password,
  }) async {
    try {
      final res = await dioClient.post(
        url: AuthApiUrls.login,
        data: {"username": phone, "password": password, "device_token": "z"},
      );

      if (res.statusCode == 200) {
        final data = res.data;

        final token = data['access_token'];
        final packageJson = data['package'];

        if (token == null || packageJson == null) {
          throw ServerException(message: AppErrors.failureLogin);
        }

        return LoginResponseModel(
          token: token,
          package: PackageModel.fromJson(packageJson),
        );
      }

      return null;
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
  Future<UserModel?> signup({
    required String phone,
    required String password,
    required String passwordConfimation,
    required String fullname,
    required int provinceId,
    required int wardId,
    required DateTime birthday,
    required String email,
  }) async {
    return await _getUser(
      () => dioClient.post(
        url: AuthApiUrls.signup,
        data: {
          "fullname": fullname,
          "password": password,
          "password_confirmation": passwordConfimation,
          "phone": phone,
          "province_id": provinceId,
          "ward_id": wardId,
          "birthday": DateFormat("yyyy-MM-dd").format(birthday),
          "email": email,
        },
      ),
    );
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
      final res = await dioClient.post(
        url: AuthApiUrls.verificationOtp,
        data: {
          "type": "email",
          "value": email,
          "otp": otp,
        },
      );

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
