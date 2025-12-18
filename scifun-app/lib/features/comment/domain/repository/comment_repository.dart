import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/features/comment/domain/entity/comment_entity.dart';

abstract interface class CommentRepository {
  Future<Either<Failure, List<CommentEntity>>> getComments({
    required int page,
    required int limit,
  });

  Future<Either<Failure, List<CommentEntity>>> getReplies({
    required String parentId,
    required int page,
    required int limit,
  });

  Future<Either<Failure, CommentEntity>> getCommentDetail({
    required String id,
  });
}
