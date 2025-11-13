import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/core/error/server_exception.dart';
import 'package:thilop10_3004/features/exam/data/datasource/examset_remote_datasource.dart';
import 'package:thilop10_3004/features/exam/data/model/examset_model.dart';
import 'package:thilop10_3004/features/exam/domain/repository/examset_repository.dart';
import 'package:thilop10_3004/features/home/domain/entity/quizz_entity.dart';

class ExamsetRepositoryImpl implements ExamsetRepository {
  final ExamsetRemoteDatasource examsetRemoteDatasource;

  ExamsetRepositoryImpl({required this.examsetRemoteDatasource});

  @override
  Future<Either<Failure, List<ExamsetModel>>> getExamsets({
    required int page,
  }) async {
    try {
      final examset = await examsetRemoteDatasource.getAllExamsets(page: page);
      return Right(examset);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, QuizzEntity>> getQuizzExamsets(
      {required int examSetId, required int subjectId}) async {
    try {
      final res = await examsetRemoteDatasource.getQuizzExamsets(
          examSetId: examSetId, subjectId: subjectId);

      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }
  // @override
  // Future<Either<Failure, NotiModel>> getExamsetDetail({
  //   required int id,
  // }) async {
  //   try {
  //     final examset =
  //         await examsetRemoteDatasource.getExamsetDetail(id: id);
  //     return Right(examset);
  //   } on ServerException catch (e) {
  //     return Left(Failure(message: e.message));
  //   }
  // }
}
