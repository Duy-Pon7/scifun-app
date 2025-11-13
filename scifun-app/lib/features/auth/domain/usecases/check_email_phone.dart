import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/common/entities/user_check_entity.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';
import 'package:thilop10_3004/features/auth/domain/repositories/auth_repository.dart';

class CheckEmailPhone
    implements Usecase<UserCheckEntity, CheckEmailPhoneParams> {
  final AuthRepository authRepository;

  CheckEmailPhone({required this.authRepository});

  @override
  Future<Either<Failure, UserCheckEntity>> call(
      CheckEmailPhoneParams param) async {
    return await authRepository.checkEmailPhone(
      phone: param.phone,
      email: param.email,
    );
  }
}

class CheckEmailPhoneParams {
  final String phone;
  final String email;

  CheckEmailPhoneParams({
    required this.phone,
    required this.email,
  });
}
