import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/features/notification/data/datasource/notification_remote_datasource.dart';
import 'package:sci_fun/features/notification/domain/entity/notification_entity.dart';
import 'package:sci_fun/features/notification/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDatasource notificationRemoteDatasource;

  NotificationRepositoryImpl({required this.notificationRemoteDatasource});

  @override
  Future<Either<Failure, List<Item>>> getAllNotifications() async {
    try {
      final res = await notificationRemoteDatasource.getNotifications();
      return Right(res.items);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Item>>> getNotifications({
    required int page,
    required int limit,
  }) async {
    try {
      final res = await notificationRemoteDatasource.getNotifications(
        page: page,
        limit: limit,
      );
      return Right(res.items);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> markAsRead({required String id}) async {
    try {
      final res = await notificationRemoteDatasource.markAsRead(id);
      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> markAllAsRead() async {
    try {
      final res = await notificationRemoteDatasource.markAllAsRead();
      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}
