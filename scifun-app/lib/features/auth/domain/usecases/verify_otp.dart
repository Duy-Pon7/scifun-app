import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/auth/domain/repositories/auth_repository.dart';

class VerifyOtp implements Usecase<String, VerifyOtpParams> {
  final AuthRepository authRepository;

  VerifyOtp({required this.authRepository});

  @override
  Future<Either<Failure, String>> call(VerifyOtpParams param) async {
    return authRepository.verifyOtp(
      email: param.email,
      otp: param.otp,
    );
  }
}

class VerifyOtpParams {
  final String email;
  final String otp;

  VerifyOtpParams({required this.email, required this.otp});
}
