import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:sci_fun/common/entities/user_entity.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/profile/domain/repository/user_repository.dart';

class UpdateInfoUser implements Usecase<UserEntity?, UpdateInfoUserParams> {
  final UserRepository userRepository;

  UpdateInfoUser({required this.userRepository});

  @override
  Future<Either<Failure, UserEntity?>> call(UpdateInfoUserParams params) async {
    return await userRepository.updateInfoUser(
      userId: params.userId,
      fullname: params.fullname,
      dob: params.dob,
      sex: params.sex,
      avatar: params.avatar,
    );
  }
}

class UpdateInfoUserParams {
  final String userId;
  final String fullname;
  final DateTime dob;
  final int sex;
  final File? avatar;

  UpdateInfoUserParams({
    required this.userId,
    required this.fullname,
    required this.dob,
    required this.sex,
    this.avatar,
  });
}
