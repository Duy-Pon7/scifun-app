import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/features/notification/domain/repositories/notification_repository.dart';
import 'package:sci_fun/core/utils/usecase.dart';

class DeleteNotification implements Usecase<void, NotificationDeleteParam> {
  final NotificationRepository repository;

  DeleteNotification(this.repository);

  @override
  Future<Either<Failure, void>> call(NotificationDeleteParam params) async {
    return await repository.deleteNotification(id: params.id);
  }
}

class NotificationDeleteParam {
  final int id;

  NotificationDeleteParam({required this.id});
}
