import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/common/entities/user.dart';
import 'package:thilop10_3004/core/error/failure.dart';

abstract interface class UserRepository {
  Future<Either<Failure, User?>> changeUser({
    required String fullname,
    required DateTime birthday,
    required int gender,
    File? image,
    required int provinceId,
    required int wardId,
    required String email,
  });
}
