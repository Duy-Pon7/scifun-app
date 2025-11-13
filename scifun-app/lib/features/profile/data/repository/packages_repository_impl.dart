import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/core/error/server_exception.dart';
import 'package:thilop10_3004/features/profile/data/datasource/packages_remote_datasource.dart';
import 'package:thilop10_3004/features/profile/data/models/instructions_model.dart';
import 'package:thilop10_3004/features/profile/data/models/package_history_model.dart';
import 'package:thilop10_3004/features/profile/data/models/packages_model.dart';
import 'package:thilop10_3004/features/profile/domain/repository/packages_repository.dart';

class PackagesRepositoryImpl implements PackagesRepository {
  final PackagesRemoteDatasource packagesRemoteDatasource;

  PackagesRepositoryImpl({required this.packagesRemoteDatasource});
  @override
  Future<Either<Failure, List<InstructionsModel>>> getInstructions() async {
    try {
      final res = await packagesRemoteDatasource.getInstructions();
      return Right(res);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
  @override
  Future<Either<Failure, List<PackagesModel>>> getPackages() async {
    try {
      final res = await packagesRemoteDatasource.getpackages();
      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }
  @override
  Future<Either<Failure, List<NotificationModel>>> getHistoryPackage({required int page}) async {
    try {
      final res = await packagesRemoteDatasource.getHistoryPackage(page: page);
      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> buyPackages({
    required int id,
    required File image,
  }) async {
    try {
      await packagesRemoteDatasource.buyPackages(id: id, image: image);
      return const Right(null); // void trả về null
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}
