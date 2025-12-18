import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/features/notification/domain/entity/notification_entity.dart';

abstract interface class NotificationRepository {
  /// Returns all notifications (legacy)
  Future<Either<Failure, List<Item>>> getAllNotifications();

  /// Returns notifications for a specific page and limit (pagination)
  Future<Either<Failure, List<Item>>> getNotifications({
    required int page,
    required int limit,
  });

  /// Mark a notification as read
  Future<Either<Failure, bool>> markAsRead({required String id});

  /// Mark all notifications as read
  Future<Either<Failure, bool>> markAllAsRead();
}
