import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/features/notification/domain/entities/notification.dart';
import 'package:thilop10_3004/features/notification/domain/repositories/notification_repository.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';

class GetNotificationDetail
    implements Usecase<Notification, NotificationDetailParam> {
  final NotificationRepository repository;

  GetNotificationDetail(this.repository);

  @override
  Future<Either<Failure, Notification>> call(
      NotificationDetailParam params) async {
    return await repository.getNotificationDetail(id: params.id);
  }
}

class NotificationDetailParam {
  final int id;

  NotificationDetailParam({required this.id});
}
