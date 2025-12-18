import 'dart:async';

import 'package:sci_fun/common/cubit/pagination_cubit.dart';
import 'package:sci_fun/core/services/realtime_service.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/notification/domain/entity/notification_entity.dart';
import 'package:sci_fun/features/notification/domain/usecase/get_notification.dart';
import 'package:sci_fun/features/notification/domain/usecase/mark_notification_as_read.dart';
import 'package:sci_fun/features/notification/domain/usecase/mark_all_notifications_as_read.dart';

/// Cubit that provides paginated notifications using [PaginationCubit]
final class NotificationCubit extends PaginationCubit<Item> {
  final GetNotifications getNotifications;
  final MarkNotificationAsRead markNotificationAsRead;
  final MarkAllNotificationsAsRead markAllNotificationsAsRead;

  StreamSubscription<Map<String, dynamic>>? _notiSub;

  NotificationCubit({
    required this.getNotifications,
    required this.markNotificationAsRead,
    required this.markAllNotificationsAsRead,
  }) : super() {
    // Listen to realtime notifications and insert them into the list
    _notiSub = RealtimeService.I.notificationStream.listen((json) {
      try {
        var map = Map<String, dynamic>.from(json);
        // Some backends wrap the notification payload under a "notification" key
        if (map.containsKey('notification') && map['notification'] is Map) {
          map = Map<String, dynamic>.from(map['notification']);
        }
        final item = Item.fromJson(map);
        addNotification(item);
      } catch (e) {
        print('Failed to process realtime notification: $e');
      }
    });
  }

  @override
  Future<List<Item>> fetchData(
    int page,
    int limit, {
    String? searchQuery,
    String? filterId,
  }) async {
    final res =
        await getNotifications(PaginationParam<int>(page: page, param: limit));

    return res.fold((failure) {
      throw Exception(failure.message);
    }, (items) => items);
  }

  /// Mark a notification as read locally after the API confirms success.
  Future<void> markAsRead(String id) async {
    if (id.isEmpty) return;

    final res = await markNotificationAsRead(id);

    res.fold((failure) {
      // ignore for now - could show toast/analytics
      print('Failed to mark notification as read: ${failure.message}');
    }, (success) {
      if (success) {
        final updated = state.items.map((item) {
          if (item.id == id) {
            return item.copyWith(read: true);
          }
          return item;
        }).toList();

        emit(PaginationSuccess<Item>(
          items: updated,
          hasReachedEnd: state.hasReachedEnd,
          currentPage: state.currentPage,
          searchQuery: state.searchQuery,
          filterId: state.filterId,
        ));
      }
    });
  }

  /// Mark all notifications as read locally after the API confirms success.
  Future<void> markAllAsRead() async {
    final res = await markAllNotificationsAsRead(NoParams());

    res.fold((failure) {
      // ignore for now - could show toast/analytics
      print('Failed to mark all notifications as read: ${failure.message}');
    }, (success) {
      if (success) {
        final updated =
            state.items.map((item) => item.copyWith(read: true)).toList();

        emit(PaginationSuccess<Item>(
          items: updated,
          hasReachedEnd: state.hasReachedEnd,
          currentPage: state.currentPage,
          searchQuery: state.searchQuery,
          filterId: state.filterId,
        ));
      }
    });
  }

  /// Add a notification received from realtime socket.
  void addNotification(Item newItem) {
    try {
      final existingIndex =
          state.items.indexWhere((i) => i.id != null && i.id == newItem.id);

      final updated = <Item>[];

      if (existingIndex >= 0) {
        // Move updated item to top and keep others (remove original)
        updated.add(newItem);
        final tmp = List<Item>.from(state.items);
        tmp.removeAt(existingIndex);
        updated.addAll(tmp);
      } else {
        // Insert new item at top
        updated.add(newItem);
        updated.addAll(state.items);
      }

      emit(PaginationSuccess<Item>(
        items: updated,
        hasReachedEnd: state.hasReachedEnd,
        currentPage: state.currentPage,
        searchQuery: state.searchQuery,
        filterId: state.filterId,
      ));
    } catch (e) {
      print('Failed to add realtime notification: $e');
    }
  }

  @override
  Future<void> close() {
    _notiSub?.cancel();
    return super.close();
  }
}
