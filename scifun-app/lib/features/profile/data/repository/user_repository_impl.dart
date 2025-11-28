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
  Future<Either<Failure, UserEntity?>> getInfoUser(
      {required String token}) async {
    try {
      final res = await userRemoteDatasource.getUser(token: token);
      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> changeUser(
      {required String fullname,
      required DateTime birthday,
      required int gender,
      File? image,
      required int provinceId,
      required int wardId,
      required String email}) {
    // TODO: implement changeUser
    throw UnimplementedError();
  }
}
