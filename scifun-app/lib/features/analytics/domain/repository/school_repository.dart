import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/features/analytics/domain/entities/school_data_entity.dart';
import 'package:sci_fun/features/analytics/domain/entities/school_scores_entity.dart';

abstract interface class SchoolRepository {
  Future<Either<Failure, SchoolScoresEntity>> getSchoolScore();
  Future<Either<Failure, List<SchoolEntity>>> getListSchool(
      {required int page, required int provinceId});
  Future<Either<Failure, List<SchoolDataEntity>>> getSchoolData(
      {required int? year, required int? provinceId});
}
