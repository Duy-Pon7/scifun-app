import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/features/notification/domain/repositories/notification_repository.dart';
import 'package:sci_fun/core/utils/usecase.dart';

class MarkAsRead implements Usecase<void, NotificationParam> {
  final NotificationRepository repository;

  MarkAsRead(this.repository);

  @override
  Future<Either<Failure, void>> call(NotificationParam params) async {
    return await repository.markAsRead(id: params.id);
  }
}

class NotificationParam {
  final int id;

  NotificationParam({required this.id});
}
