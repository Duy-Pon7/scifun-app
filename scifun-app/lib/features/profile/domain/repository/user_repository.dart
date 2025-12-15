import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:sci_fun/common/entities/user_entity.dart';
import 'package:sci_fun/common/entities/user_get_entity.dart';
import 'package:sci_fun/core/error/failure.dart';

abstract interface class UserRepository {
  Future<Either<Failure, UserEntity?>> changeUser({
    required String fullname,
    required DateTime birthday,
    required int gender,
    File? image,
    required int provinceId,
    required int wardId,
    required String email,
  });
  Future<Either<Failure, UserGetEntity?>> getInfoUser({required String token});

  Future<Either<Failure, UserEntity?>> updateInfoUser({
    required String userId,
    required String fullname,
    required DateTime dob,
    required int sex,
    File? avatar,
  });
}
