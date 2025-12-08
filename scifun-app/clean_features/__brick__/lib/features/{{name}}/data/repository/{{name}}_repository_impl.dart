import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/features/subject/data/datasource/subject_remote_datasource.dart';
import 'package:sci_fun/features/subject/domain/entity/subject_entity.dart';
import 'package:sci_fun/features/subject/domain/repository/subject_repository.dart';

class SubjectRepositoryImpl implements SubjectRepository {
  final SubjectRemoteDatasource subjectRemoteDatasource;

  SubjectRepositoryImpl({required this.subjectRemoteDatasource});

  @override
  Future<Either<Failure, List<SubjectEntity>>> getAllSubjects(
      String? searchQuery) async {
    try {
      final res = await subjectRemoteDatasource.getAllSubjects(searchQuery);
      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}
