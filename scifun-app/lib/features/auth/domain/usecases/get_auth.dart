import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/common/entities/user.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';
import 'package:thilop10_3004/features/auth/domain/repositories/auth_repository.dart';

class GetAuth implements Usecase<User?, NoParams> {
  final AuthRepository authRepository;

  GetAuth({required this.authRepository});

  @override
  Future<Either<Failure, User?>> call(NoParams param) async {
    return await authRepository.getAuth();
  }
}
