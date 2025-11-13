import 'package:dartz/dartz.dart';
import 'package:sci_fun/common/entities/user_entity.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/auth/domain/repositories/auth_repository.dart';

class GetAuth implements Usecase<UserEntity?, NoParams> {
  final AuthRepository authRepository;

  GetAuth({required this.authRepository});

  @override
  Future<Either<Failure, UserEntity?>> call(NoParams param) async {
    return await authRepository.getAuth();
  }
}
