import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/features/subject/domain/entity/subject_entity.dart';

abstract interface class SubjectRepository {
  Future<Either<Failure, List<SubjectEntity>>> getAllSubjects(
      String? searchQuery);
}
