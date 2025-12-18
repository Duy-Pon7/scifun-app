import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/comment/domain/entity/comment_entity.dart';
import 'package:sci_fun/features/comment/domain/repository/comment_repository.dart';

class GetComments implements Usecase<List<CommentEntity>, PageLimitParams> {
  final CommentRepository commentRepository;

  GetComments({required this.commentRepository});

  @override
  Future<Either<Failure, List<CommentEntity>>> call(
      PageLimitParams params) async {
    return await commentRepository.getComments(
        page: params.page, limit: params.limit);
  }
}

class PageLimitParams {
  final int page;
  final int limit;

  PageLimitParams({required this.page, required this.limit});
}
