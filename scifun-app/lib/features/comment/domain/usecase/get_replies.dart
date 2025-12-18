import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/comment/domain/entity/comment_entity.dart';
import 'package:sci_fun/features/comment/domain/repository/comment_repository.dart';

class GetReplies implements Usecase<List<CommentEntity>, RepliesParams> {
  final CommentRepository commentRepository;

  GetReplies({required this.commentRepository});

  @override
  Future<Either<Failure, List<CommentEntity>>> call(
      RepliesParams params) async {
    return await commentRepository.getReplies(
      parentId: params.parentId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class RepliesParams {
  final String parentId;
  final int page;
  final int limit;

  RepliesParams(
      {required this.parentId, required this.page, required this.limit});
}
