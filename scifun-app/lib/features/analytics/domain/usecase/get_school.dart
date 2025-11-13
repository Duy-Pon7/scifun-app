import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';
import 'package:thilop10_3004/features/analytics/domain/entities/school_scores_entity.dart';
import 'package:thilop10_3004/features/analytics/domain/repository/school_repository.dart';

class GetSchool implements Usecase<SchoolScoresEntity, NoParams> {
  final SchoolRepository repository;

  GetSchool(this.repository);

  @override
  Future<Either<Failure, SchoolScoresEntity>> call(NoParams params) async {
    return await repository.getSchoolScore();
  }
}
