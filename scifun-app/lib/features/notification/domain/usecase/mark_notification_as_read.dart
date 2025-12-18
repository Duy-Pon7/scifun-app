import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/notification/domain/repository/notification_repository.dart';

class MarkNotificationAsRead implements Usecase<bool, String> {
  final NotificationRepository notificationRepository;

  MarkNotificationAsRead(this.notificationRepository);

  @override
  Future<Either<Failure, bool>> call(String id) async {
    return await notificationRepository.markAsRead(id: id);
  }
}
