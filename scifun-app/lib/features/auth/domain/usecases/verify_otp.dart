import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';
import 'package:thilop10_3004/features/auth/domain/repositories/auth_repository.dart';

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
