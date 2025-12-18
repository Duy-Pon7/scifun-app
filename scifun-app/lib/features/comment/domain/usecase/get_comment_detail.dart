import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/comment/domain/entity/comment_entity.dart';
import 'package:sci_fun/features/comment/domain/repository/comment_repository.dart';

class GetCommentDetail implements Usecase<CommentEntity, CommentDetailParams> {
  final CommentRepository commentRepository;

  GetCommentDetail({required this.commentRepository});

  @override
  Future<Either<Failure, CommentEntity>> call(
      CommentDetailParams params) async {
    return await commentRepository.getCommentDetail(id: params.id);
  }
}

class CommentDetailParams {
  final String id;

  CommentDetailParams(this.id);
}
