import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/features/subject/domain/entity/subject_entity.dart';

abstract interface class SubjectRepository {
  Future<Either<Failure, SubjectEntity>> getAllSubjects();
}