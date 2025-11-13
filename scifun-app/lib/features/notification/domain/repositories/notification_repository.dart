import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/features/notification/data/models/noti_model.dart';
import 'package:thilop10_3004/features/notification/domain/entities/notification.dart';

abstract interface class NotificationRepository {
  Future<Either<Failure, List<NotiModel>>> getNotifications({
    required int page,
  });
  Future<Either<Failure, Notification>> getNotificationDetail({
    required int id,
  });
  Future<Either<Failure, void>> markAsRead({
    required int id,
  });
  Future<Either<Failure, void>> deleteNotification({
    required int id,
  });
  Future<Either<Failure, void>> markAsReadAll();
}
