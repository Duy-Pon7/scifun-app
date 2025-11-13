import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/features/analytics/domain/entities/school_data_entity.dart';
import 'package:thilop10_3004/features/analytics/domain/entities/school_scores_entity.dart';

abstract interface class SchoolRepository {
  Future<Either<Failure, SchoolScoresEntity>> getSchoolScore();
  Future<Either<Failure, List<SchoolEntity>>> getListSchool(
      {required int page, required int provinceId});
  Future<Either<Failure, List<SchoolDataEntity>>> getSchoolData(
      {required int? year, required int? provinceId});
}
