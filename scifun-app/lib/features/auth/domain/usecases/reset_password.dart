import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/common/entities/user.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';
import 'package:thilop10_3004/features/auth/domain/repositories/auth_repository.dart';

class ResetPassword implements Usecase<User?, ResetPasswordParams> {
  final AuthRepository authRepository;

  ResetPassword({required this.authRepository});

  @override
  Future<Either<Failure, User?>> call(ResetPasswordParams param) async {
    return await authRepository.resetPassword(
      email: param.email,
      newPass: param.newPass,
      newPassConfirm: param.newPassConfirm,
    );
  }
}

class ResetPasswordParams {
  final String email;
  final String newPass;
  final String newPassConfirm;

  ResetPasswordParams({
    required this.email,
    required this.newPass,
    required this.newPassConfirm,
  });
}
