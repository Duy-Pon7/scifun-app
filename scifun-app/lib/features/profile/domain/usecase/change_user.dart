import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/common/entities/user.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';
import 'package:thilop10_3004/features/profile/domain/repository/user_repository.dart';

class Changes implements Usecase<User?, ChangeUserParams> {
  final UserRepository userRepository;

  Changes({required this.userRepository});

  @override
  Future<Either<Failure, User?>> call(ChangeUserParams param) async {
    return await userRepository.changeUser(
      fullname: param.fullname,
      email: param.email,
      gender: param.gender,
      birthday: param.birthday,
      image: param.image,
      provinceId: param.provinceId,
      wardId: param.wardId,
    );
  }
}

class ChangeUserParams {
  final String fullname;
  final String email;
  final int gender;
  final DateTime birthday;
  final File? image;
  final int provinceId;
  final int wardId;

  ChangeUserParams(
      {required this.fullname,
      required this.email,
      required this.gender,
      required this.birthday,
      required this.provinceId,
      required this.wardId,
      this.image});
}
