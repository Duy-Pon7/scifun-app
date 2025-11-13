import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/notification/domain/entities/notification.dart';
import 'package:sci_fun/features/notification/domain/usecases/delete_notification.dart';
import 'package:sci_fun/features/notification/domain/usecases/get_notification_detail.dart';
import 'package:sci_fun/features/notification/domain/usecases/mark_as_read.dart';
import 'package:sci_fun/features/notification/domain/usecases/mark_as_read_all.dart';

sealed class NotiState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotiInitial extends NotiState {}

class NotiLoading extends NotiState {}

class NotiLoaded extends NotiState {
  final List<Notification> newsList;
  NotiLoaded(this.newsList);

  @override
  List<Object?> get props => [newsList];
}

class NotiSuccess extends NotiState {}

class NotiDetailLoaded extends NotiState {
  final Notification newsDetail;

  NotiDetailLoaded(this.newsDetail);

  @override
  List<Object?> get props => [newsDetail];
}

class NotiError extends NotiState {
  final String message;

  NotiError(this.message);

  @override
  List<Object?> get props => [message];
}

class NotiCubit extends Cubit<NotiState> {
  final GetNotificationDetail getNotiDetail;
  final MarkAsRead markAsRead;
  final MarkAsReadAll markAsReadAll;
  final DeleteNotification deleteNotification;

  NotiCubit(this.getNotiDetail, this.markAsRead, this.markAsReadAll,
      this.deleteNotification)
      : super(NotiInitial());

  Future<void> fetchNotiDetail({required int newsId}) async {
    if (isClosed) return;
    emit(NotiLoading());
    try {
      final res = await getNotiDetail(NotificationDetailParam(id: newsId));
      if (isClosed) return;
      res.fold(
        (failure) => emit(NotiError(failure.message)),
        (data) => emit(NotiDetailLoaded(data)),
      );
    } catch (e) {
      if (!isClosed) emit(NotiError(e.toString()));
    }
  }

  Future<void> deleteNoti({required int newsId}) async {
    if (isClosed) return;
    emit(NotiLoading());
    try {
      await deleteNotification(NotificationDeleteParam(id: newsId));
      if (!isClosed) emit(NotiInitial());
    } catch (e) {
      if (!isClosed) emit(NotiError(e.toString()));
    }
  }

  Future<void> markNotificationAsRead({required int newsId}) async {
    if (isClosed) return;
    emit(NotiLoading());
    try {
      await markAsRead(NotificationParam(id: newsId));
      if (!isClosed) emit(NotiInitial());
    } catch (e) {
      if (!isClosed) emit(NotiError(e.toString()));
    }
  }

  Future<void> markNotificationAsReadAll() async {
    if (isClosed) return;
    emit(NotiLoading());
    try {
      await markAsReadAll(NoParams());
      if (!isClosed) emit(NotiInitial());
    } catch (e) {
      if (!isClosed) emit(NotiError(e.toString()));
    }
  }
}
