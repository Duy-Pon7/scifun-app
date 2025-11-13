import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/core/error/server_exception.dart';
import 'package:thilop10_3004/features/notification/data/datasources/notification_remote_datasource.dart';
import 'package:thilop10_3004/features/notification/data/models/noti_model.dart';
import 'package:thilop10_3004/features/notification/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDatasource notificationRemoteDatasource;

  NotificationRepositoryImpl({required this.notificationRemoteDatasource});

  @override
  Future<Either<Failure, List<NotiModel>>> getNotifications({
    required int page,
  }) async {
    try {
      final notifications =
          await notificationRemoteDatasource.getNotifications(page: page);
      return Right(notifications);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification({
    required int id,
  }) async {
    print("id123 $id");
    try {
      final notifications =
          await notificationRemoteDatasource.deleteNotification(id: id);
      return Right(notifications);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, NotiModel>> getNotificationDetail({
    required int id,
  }) async {
    try {
      final notifications =
          await notificationRemoteDatasource.getNotificationDetail(id: id);
      return Right(notifications);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead({
    required int id,
  }) async {
    try {
      final notifications =
          await notificationRemoteDatasource.markAsRead(id: id);
      return Right(notifications);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> markAsReadAll() async {
    try {
      final notifications = await notificationRemoteDatasource.markAsReadAll();
      return Right(notifications);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}
