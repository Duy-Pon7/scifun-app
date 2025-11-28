import 'package:dartz/dartz.dart';
import 'package:sci_fun/common/entities/user_entity.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/auth/domain/repositories/auth_repository.dart';

class Signup implements Usecase<UserEntity?, SignupParams> {
  final AuthRepository authRepository;

  Signup({required this.authRepository});

  @override
  Future<Either<Failure, UserEntity?>> call(SignupParams param) async {
    return await authRepository.signup(
        password: param.password,
        passwordConfimation: param.passwordConfimation,
        fullname: param.fullname,
        email: param.email);
  }
}

class SignupParams {
  final String password;
  final String passwordConfimation;

  final String fullname;
  final String email;

  SignupParams(
      {required this.password,
      required this.passwordConfimation,
      required this.fullname,
      required this.email});
}
