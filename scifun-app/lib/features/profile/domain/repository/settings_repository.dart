import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:sci_fun/common/entities/settings_entity.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/features/profile/domain/entities/packages_entity.dart';

abstract interface class SettingsRepository {
  Future<Either<Failure, List<SettingsEntity>>> getSettings();
  // Future<Either<Failure, void>> buyPackages({
  //   required int id,
  //   required File image,
  // });
}
