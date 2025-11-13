import 'package:dartz/dartz.dart';
import 'package:sci_fun/common/models/user_check_model.dart';
import 'package:sci_fun/core/constants/app_errors.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/core/services/share_prefs_service.dart';
import 'package:sci_fun/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:sci_fun/common/models/user_model.dart';
import 'package:sci_fun/common/entities/user_entity.dart';
import 'package:sci_fun/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource authRemoteDatasource;
  final SharePrefsService sharePrefsService;

  AuthRepositoryImpl({
    required this.authRemoteDatasource,
    required this.sharePrefsService,
  });
  @override
  Future<Either<Failure, bool>> resendOtp({
    required String email,
  }) async {
    try {
      final result = await authRemoteDatasource.resendOtp(email: email);
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, String>> verificationOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final result =
          await authRemoteDatasource.verificationOtp(email: email, otp: otp);
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserCheckModel>> checkEmailPhone({
    required String phone,
    required String email,
  }) async {
    try {
      final usercheck = await authRemoteDatasource.checkEmailPhone(
        phone: phone,
        email: email,
      );
      return Right(usercheck);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> login({
    required String email,
    required String password,
  }) async {
    try {
      final loginRes = await authRemoteDatasource.login(
        email: email,
        password: password,
      );

      if (loginRes == null) {
        return Left(Failure(message: AppErrors.failureLogin));
      }

      await sharePrefsService.saveAuthToken(loginRes.token); // 👈 Lưu token

      return Right(loginRes);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> signup({
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
      () => authRemoteDatasource.signup(
        password: password,
        passwordConfimation: passwordConfimation,
        phone: phone,
        fullname: fullname,
        provinceId: provinceId,
        wardId: wardId,
        birthday: birthday,
        email: email,
      ),
    );
  }

  @override
  Future<Either<Failure, String>> sendEmail({required String email}) async {
    try {
      final message = await authRemoteDatasource.sendEmail(email: email);
      return Right(message);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, String>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final message =
          await authRemoteDatasource.otpVerifyOtp(email: email, otp: otp);
      return Right(message);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> resetPassword({
    required String email,
    required String newPass,
    required String newPassConfirm,
  }) async {
    return await _getUser(
      () => authRemoteDatasource.resetPassword(
        email: email,
        newPass: newPass,
        newPassConfirm: newPassConfirm,
      ),
    );
  }

  @override
  Future<Either<Failure, String>> changePassword({
    required String oldPass,
    required String newPass,
    required String newPassConfirm,
  }) async {
    try {
      final message = await authRemoteDatasource.changePassword(
        oldPass: oldPass,
        newPass: newPass,
        newPassConfirm: newPassConfirm,
      );
      return Right(message);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getAuth() async {
    return await _getUser(authRemoteDatasource.getAuth);
  }

  Future<Either<Failure, UserEntity?>> _getUser(
    Future<UserModel?> Function() func,
  ) async {
    try {
      final UserModel? user = await func();
      return Right(user);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}
