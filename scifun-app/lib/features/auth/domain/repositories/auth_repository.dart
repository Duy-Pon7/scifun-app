import 'package:dartz/dartz.dart';
import 'package:sci_fun/common/entities/user_entity.dart';
import 'package:sci_fun/common/entities/user_check_entity.dart';
import 'package:sci_fun/core/error/failure.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserEntity?>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity?>> signup({
    required String phone,
    required String password,
    required String passwordConfimation,
    required String fullname,
    required int provinceId,
    required int wardId,
    required DateTime birthday,
    required String email,
  });

  Future<Either<Failure, String>> sendEmail({required String email});

  Future<Either<Failure, String>> verifyOtp({
    required String email,
    required String otp,
  });
  Future<Either<Failure, bool>> resendOtp({
    required String email,
  });
  Future<Either<Failure, String>> verificationOtp({
    required String email,
    required String otp,
  });
  Future<Either<Failure, UserEntity?>> resetPassword({
    required String email,
    required String newPass,
    required String newPassConfirm,
  });
  Future<Either<Failure, String>> changePassword({
    required String oldPass,
    required String newPass,
    required String newPassConfirm,
  });
  Future<Either<Failure, UserCheckEntity>> checkEmailPhone({
    required String phone,
    required String email,
  });

  Future<Either<Failure, UserEntity?>> getAuth();
}
