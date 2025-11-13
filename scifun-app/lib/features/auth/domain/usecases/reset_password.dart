import 'package:dartz/dartz.dart';
import 'package:sci_fun/common/entities/user_entity.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/auth/domain/repositories/auth_repository.dart';

class ResetPassword implements Usecase<UserEntity?, ResetPasswordParams> {
  final AuthRepository authRepository;

  ResetPassword({required this.authRepository});

  @override
  Future<Either<Failure, UserEntity?>> call(ResetPasswordParams param) async {
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
