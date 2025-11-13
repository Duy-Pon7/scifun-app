import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/common/entities/user.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';
import 'package:thilop10_3004/features/auth/domain/repositories/auth_repository.dart';

class Signup implements Usecase<User?, SignupParams> {
  final AuthRepository authRepository;

  Signup({required this.authRepository});

  @override
  Future<Either<Failure, User?>> call(SignupParams param) async {
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
