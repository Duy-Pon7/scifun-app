import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/notification/domain/repository/notification_repository.dart';

class MarkAllNotificationsAsRead implements Usecase<bool, NoParams> {
  final NotificationRepository notificationRepository;

  MarkAllNotificationsAsRead(this.notificationRepository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await notificationRepository.markAllAsRead();
  }
}
