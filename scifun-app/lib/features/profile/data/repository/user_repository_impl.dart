import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/core/error/server_exception.dart';
import 'package:thilop10_3004/common/models/user_model.dart';
import 'package:thilop10_3004/common/entities/user.dart';
import 'package:thilop10_3004/features/profile/data/datasource/user_remote_datasource.dart';
import 'package:thilop10_3004/features/profile/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource userRemoteDatasource;

  UserRepositoryImpl({
    required this.userRemoteDatasource,
  });

  @override
  Future<Either<Failure, User?>> changeUser({
    required String fullname,
    required String email,
    required DateTime birthday,
    required int gender,
    required int provinceId,
    required int wardId,
    File? image,
  }) async {
    return await _getUser(
      () => userRemoteDatasource.changeUser(
        fullname: fullname,
        email: email,
        birthday: birthday,
        gender: gender,
        image: image,
        provinceId: provinceId,
        wardId: wardId,
      ),
    );
  }

  Future<Either<Failure, User?>> _getUser(
    Future<UserModel?> Function() func,
  ) async {
    try {
      final UserModel? user = await func();
      return Right(user);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}
