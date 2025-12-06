import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/features/analytics/data/datasource/progress_remote_datasource.dart';
import 'package:sci_fun/features/analytics/domain/entities/progress_entity.dart';
import 'package:sci_fun/features/analytics/domain/repository/progress_repository.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressRemoteDatasource progressRemoteDatasource;

  ProgressRepositoryImpl({required this.progressRemoteDatasource});

  @override
  Future<Either<Failure, ProgressEntity>> getProgress(String subjectId) async {
    try {
      final res = await progressRemoteDatasource.getProgress(subjectId);
      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}
