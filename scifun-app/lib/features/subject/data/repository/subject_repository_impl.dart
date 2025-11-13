import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/core/error/server_exception.dart';
import 'package:thilop10_3004/features/subject/data/datasource/subject_remote_datasource.dart';
import 'package:thilop10_3004/features/subject/domain/entity/subject_entity.dart';
import 'package:thilop10_3004/features/subject/domain/repository/subject_repository.dart';

class SubjectRepositoryImpl implements SubjectRepository {
  final SubjectRemoteDatasource subjectRemoteDatasource;

  SubjectRepositoryImpl({required this.subjectRemoteDatasource});

  @override
  Future<Either<Failure, SubjectEntity>> getAllSubjects() async {
    try {
      final res = await subjectRemoteDatasource.getAllSubjects();
      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}
