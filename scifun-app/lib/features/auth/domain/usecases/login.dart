import 'package:dartz/dartz.dart';
import 'package:sci_fun/common/entities/user_entity.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/auth/domain/repositories/auth_repository.dart';

class Login implements Usecase<UserEntity?, LoginParams> {
  final AuthRepository authRepository;

  Login({required this.authRepository});

  @override
  Future<Either<Failure, UserEntity?>> call(LoginParams param) async {
    return await authRepository.login(
      email: param.email,
      password: param.password,
    );
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({
    required this.email,
    required this.password,
  });
}
