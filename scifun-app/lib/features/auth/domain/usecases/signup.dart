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
        phone: param.phone,
        fullname: param.fullname,
        provinceId: param.provinceId,
        wardId: param.wardId,
        email: param.email,
        birthday: param.birthday);
  }
}

class SignupParams {
  final String password;
  final String passwordConfimation;
  final String phone;
  final String fullname;
  final int provinceId;
  final int wardId;
  final DateTime birthday;
  final String email;

  SignupParams(
      {required this.password,
      required this.passwordConfimation,
      required this.phone,
      required this.fullname,
      required this.provinceId,
      required this.wardId,
      required this.birthday,
      required this.email});
}
