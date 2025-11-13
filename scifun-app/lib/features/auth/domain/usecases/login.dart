import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/common/entities/user.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';
import 'package:thilop10_3004/features/auth/domain/repositories/auth_repository.dart';

class Login implements Usecase<Package?, LoginParams> {
  final AuthRepository authRepository;

  Login({required this.authRepository});

  @override
  Future<Either<Failure, Package?>> call(LoginParams param) async {
    return await authRepository.login(
      phone: param.phone,
      password: param.password,
    );
  }
}

class LoginParams {
  final String phone;
  final String password;

  LoginParams({
    required this.phone,
    required this.password,
  });
}
