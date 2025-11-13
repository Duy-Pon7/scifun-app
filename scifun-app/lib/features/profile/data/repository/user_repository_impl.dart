import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/common/models/user_model.dart';
import 'package:sci_fun/common/entities/user_entity.dart';
import 'package:sci_fun/features/profile/data/datasource/user_remote_datasource.dart';
import 'package:sci_fun/features/profile/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource userRemoteDatasource;

  UserRepositoryImpl({
    required this.userRemoteDatasource,
  });

  @override
  Future<Either<Failure, UserEntity?>> changeUser({
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

  Future<Either<Failure, UserEntity?>> _getUser(
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
