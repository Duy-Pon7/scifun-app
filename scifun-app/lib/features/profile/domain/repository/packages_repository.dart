import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/features/profile/domain/entities/instructions_entity.dart';
import 'package:sci_fun/features/profile/domain/entities/order_history_entity.dart';
import 'package:sci_fun/features/profile/domain/entities/package_history_entity.dart';
import 'package:sci_fun/features/profile/domain/entities/packages_entity.dart';

abstract interface class PackagesRepository {
  Future<Either<Failure, List<PackagesEntity>>> getPackages();
  Future<Either<Failure, UserOrderHistoryEntity>> getOrderHistory({
    required int page,
    required int limit,
  });
  Future<Either<Failure, List<NotificationEntity>>> getHistoryPackage(
      {required int page});
  Future<Either<Failure, void>> buyPackages({
    required int id,
    required File image,
  });
  Future<Either<Failure, List<InstructionsEntity?>>> getInstructions();
}
