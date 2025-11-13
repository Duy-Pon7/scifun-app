import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';
import 'package:thilop10_3004/features/auth/domain/repositories/auth_repository.dart';

class SendEmail implements Usecase<String, String> {
  final AuthRepository authRepository;

  SendEmail({required this.authRepository});

  @override
  Future<Either<Failure, String>> call(String param) async {
    return await authRepository.sendEmail(email: param);
  }
}
