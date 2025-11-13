import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/common/entities/user.dart';
import 'package:thilop10_3004/common/entities/user_check_entity.dart';
import 'package:thilop10_3004/core/error/failure.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, Package?>> login({
    required String phone,
    required String password,
  });

  Future<Either<Failure, User?>> signup({
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
  Future<Either<Failure, User?>> resetPassword({
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

  Future<Either<Failure, User?>> getAuth();
}
