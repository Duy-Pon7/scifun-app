import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:sci_fun/common/models/settings_model.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/features/profile/data/datasource/packages_remote_datasource.dart';
import 'package:sci_fun/features/profile/data/datasource/settings_remote_datasource.dart';
import 'package:sci_fun/features/profile/data/models/packages_model.dart';
import 'package:sci_fun/features/profile/domain/repository/packages_repository.dart';
import 'package:sci_fun/features/profile/domain/repository/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDatasource settingsRemoteDatasource;

  SettingsRepositoryImpl({required this.settingsRemoteDatasource});

  @override
  Future<Either<Failure, List<SettingsModel>>> getSettings() async {
    try {
      final res = await settingsRemoteDatasource.getSettings();
      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  // @override
  // Future<Either<Failure, void>> buyPackages({
  //   required int id,
  //   required File image,
  // }) async {
  //   try {
  //     await packagesRemoteDatasource.buyPackages(id: id, image: image);
  //     return const Right(null); // void trả về null
  //   } on ServerException catch (e) {
  //     return Left(Failure(message: e.message));
  //   }
  // }
}
