import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/analytics/domain/entities/school_scores_entity.dart';
import 'package:sci_fun/features/analytics/domain/repository/school_repository.dart';

class GetSchool implements Usecase<SchoolScoresEntity, NoParams> {
  final SchoolRepository repository;

  GetSchool(this.repository);

  @override
  Future<Either<Failure, SchoolScoresEntity>> call(NoParams params) async {
    return await repository.getSchoolScore();
  }
}
