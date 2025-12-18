import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/features/comment/domain/entity/comment_entity.dart';
import 'package:sci_fun/features/comment/domain/usecase/get_all_comment.dart';
import 'package:sci_fun/features/comment/domain/usecase/get_replies.dart';
import 'package:sci_fun/features/comment/domain/usecase/get_comment_detail.dart';

sealed class CommentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentsLoaded extends CommentState {
  final List<CommentEntity> comments;

  CommentsLoaded(this.comments);

  @override
  List<Object?> get props => [comments];
}

class RepliesLoaded extends CommentState {
  final List<CommentEntity> replies;

  RepliesLoaded(this.replies);

  @override
  List<Object?> get props => [replies];
}

class CommentDetailLoaded extends CommentState {
  final CommentEntity comment;

  CommentDetailLoaded(this.comment);

  @override
  List<Object?> get props => [comment];
}

class CommentError extends CommentState {
  final String message;

  CommentError(this.message);

  @override
  List<Object?> get props => [message];
}

class CommentCubit extends Cubit<CommentState> {
  final GetComments getComments;
  final GetReplies getReplies;
  final GetCommentDetail getCommentDetail;

  CommentCubit({
    required this.getComments,
    required this.getReplies,
    required this.getCommentDetail,
  }) : super(CommentInitial());

  Future<void> fetchComments({int page = 1, int limit = 10}) async {
    emit(CommentLoading());
    try {
      final res = await getComments(PageLimitParams(page: page, limit: limit));
      res.fold(
        (failure) => emit(CommentError(failure.message)),
        (data) => emit(CommentsLoaded(data)),
      );
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }

  Future<void> fetchReplies(
      {required String parentId, int page = 1, int limit = 10}) async {
    emit(CommentLoading());
    try {
      final res = await getReplies(
          RepliesParams(parentId: parentId, page: page, limit: limit));
      res.fold(
        (failure) => emit(CommentError(failure.message)),
        (data) => emit(RepliesLoaded(data)),
      );
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }

  Future<void> fetchCommentDetail({required String id}) async {
    emit(CommentLoading());
    try {
      final res = await getCommentDetail(CommentDetailParams(id));
      res.fold(
        (failure) => emit(CommentError(failure.message)),
        (data) => emit(CommentDetailLoaded(data)),
      );
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }
}
