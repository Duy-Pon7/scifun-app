import 'package:sci_fun/common/cubit/pagination_cubit.dart';
import 'package:sci_fun/features/comment/domain/entity/comment_entity.dart';
import 'package:sci_fun/features/comment/domain/usecase/get_all_comment.dart';

final class CommentPaginationCubit extends PaginationCubit<CommentEntity> {
  final GetComments getComments;

  CommentPaginationCubit(this.getComments);

  @override
  Future<List<CommentEntity>> fetchData(
    int page,
    int limit, {
    String? searchQuery,
    String? filterId,
  }) async {
    final result = await getComments(PageLimitParams(page: page, limit: limit));

    return result.fold(
      (failure) => throw Exception(failure.message),
      (list) => list,
    );
  }

  /// Insert a new comment at the top of the list (e.g., realtime event)
  void insertNewComment(CommentEntity comment) {
    emit(PaginationSuccess<CommentEntity>(
      items: [comment, ...state.items],
      hasReachedEnd: state.hasReachedEnd,
      currentPage: state.currentPage,
      searchQuery: state.searchQuery,
      filterId: state.filterId,
    ));
  }
}
