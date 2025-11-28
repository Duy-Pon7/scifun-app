import 'package:dartz/dartz.dart';
import 'package:sci_fun/common/entities/user_entity.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/features/profile/domain/repository/user_repository.dart';

class GetInfoUser {
  final UserRepository userRepository;

  GetInfoUser({required this.userRepository});

  Future<Either<Failure, UserEntity?>> call({required String token}) async {
    return await userRepository.getInfoUser(token: token);
  }
}
