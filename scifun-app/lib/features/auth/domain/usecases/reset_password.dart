import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/auth/domain/repositories/auth_repository.dart';

class ResetPassword implements Usecase<String, ResetPasswordParams> {
  final AuthRepository authRepository;

  ResetPassword({required this.authRepository});

  @override
  Future<Either<Failure, String>> call(ResetPasswordParams param) async {
    return await authRepository.resetPassword(
      email: param.email,
      newPassword: param.newPassword,
    );
  }
}

class ResetPasswordParams {
  final String email;
  final String newPassword;

  ResetPasswordParams({required this.email, required this.newPassword});
}
