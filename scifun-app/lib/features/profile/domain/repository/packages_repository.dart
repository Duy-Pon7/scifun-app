import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/features/profile/domain/entities/instructions_entity.dart';
import 'package:thilop10_3004/features/profile/domain/entities/package_history_entity.dart';
import 'package:thilop10_3004/features/profile/domain/entities/packages_entity.dart';

abstract interface class PackagesRepository {
  Future<Either<Failure, List<PackagesEntity>>> getPackages();
  Future<Either<Failure, List<NotificationEntity>>> getHistoryPackage(
      {required int page});
  Future<Either<Failure, void>> buyPackages({
    required int id,
    required File image,
  });
  Future<Either<Failure, List<InstructionsEntity?>>> getInstructions();
}
