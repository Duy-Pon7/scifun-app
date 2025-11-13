import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/features/analytics/data/datasource/school_remote_datasource.dart';
import 'package:sci_fun/features/analytics/data/model/school_data_model.dart';
import 'package:sci_fun/features/analytics/data/model/school_scores_model.dart';
import 'package:sci_fun/features/analytics/domain/repository/school_repository.dart';

class SchoolRepositoryImpl implements SchoolRepository {
  final SchoolRemoteDatasource schoolRemoteDatasource;

  SchoolRepositoryImpl({required this.schoolRemoteDatasource});

  @override
  Future<Either<Failure, SchoolScoresModel>> getSchoolScore() async {
    try {
      final school = await schoolRemoteDatasource.getSchoolScore();
      return Right(school);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<SchoolModel>>> getListSchool(
      {required int page, required int provinceId}) async {
    try {
      final res = await schoolRemoteDatasource.getListSchool(
          page: page, provinceId: provinceId);

      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<SchoolDataModel>>> getSchoolData(
      {required int? year, required int? provinceId}) async {
    try {
      final res = await schoolRemoteDatasource.getSchoolData(
          year: year ?? 0, provinceId: provinceId ?? 0);

      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}
