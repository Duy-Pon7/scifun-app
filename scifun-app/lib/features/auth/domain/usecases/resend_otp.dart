import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/auth/domain/repositories/auth_repository.dart';

class ResendOtp implements Usecase<bool, ResendOtpParams> {
  final AuthRepository authRepository;

  ResendOtp({required this.authRepository});

  @override
  Future<Either<Failure, bool>> call(ResendOtpParams param) async {
    return await authRepository.resendOtp(
      email: param.email,
    );
  }
}

class ResendOtpParams {
  final String email;

  ResendOtpParams({
    required this.email,
  });
}
