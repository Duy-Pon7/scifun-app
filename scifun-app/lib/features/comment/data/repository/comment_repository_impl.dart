import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/features/comment/data/datasource/comment_remote_datasource.dart';
import 'package:sci_fun/features/comment/domain/entity/comment_entity.dart';
import 'package:sci_fun/features/comment/domain/repository/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDatasource commentRemoteDatasource;

  CommentRepositoryImpl({required this.commentRemoteDatasource});

  @override
  Future<Either<Failure, List<CommentEntity>>> getComments({
    required int page,
    required int limit,
  }) async {
    try {
      final res =
          await commentRemoteDatasource.getComments(page: page, limit: limit);
      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<CommentEntity>>> getReplies({
    required String parentId,
    required int page,
    required int limit,
  }) async {
    try {
      final res = await commentRemoteDatasource.getReplies(parentId,
          page: page, limit: limit);
      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, CommentEntity>> getCommentDetail(
      {required String id}) async {
    try {
      final res = await commentRemoteDatasource.getCommentDetail(id);
      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}
