import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';
import 'package:thilop10_3004/features/auth/domain/repositories/auth_repository.dart';

class ChangePassword implements Usecase<String, ChangePasswordParams> {
  final AuthRepository authRepository;

  ChangePassword({required this.authRepository});

  @override
  Future<Either<Failure, String>> call(ChangePasswordParams param) async {
    return await authRepository.changePassword(
      oldPass: param.oldPass,
      newPass: param.newPass,
      newPassConfirm: param.newPassConfirm,
    );
  }
}

class ChangePasswordParams {
  final String oldPass;
  final String newPass;
  final String newPassConfirm;

  ChangePasswordParams({
    required this.oldPass,
    required this.newPass,
    required this.newPassConfirm,
  });
}
