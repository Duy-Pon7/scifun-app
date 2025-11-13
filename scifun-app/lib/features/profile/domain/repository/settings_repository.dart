import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/common/entities/settings_entity.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/features/profile/domain/entities/packages_entity.dart';

abstract interface class SettingsRepository {
  Future<Either<Failure, List<SettingsEntity>>> getSettings();
  // Future<Either<Failure, void>> buyPackages({
  //   required int id,
  //   required File image,
  // });
}
