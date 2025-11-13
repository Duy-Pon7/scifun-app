import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/auth/domain/repositories/auth_repository.dart';

class VerificationOtp implements Usecase<String, VerificationOtpParams> {
  final AuthRepository authRepository;

  VerificationOtp({required this.authRepository});

  @override
  Future<Either<Failure, String>> call(VerificationOtpParams param) async {
    return await authRepository.verificationOtp(
      otp: param.otp,
      email: param.email,
    );
  }
}

class VerificationOtpParams {
  final String otp;
  final String email;

  VerificationOtpParams({
    required this.otp,
    required this.email,
  });
}
