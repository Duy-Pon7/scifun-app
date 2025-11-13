import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/features/notification/domain/repositories/notification_repository.dart';
import 'package:sci_fun/core/utils/usecase.dart';

class MarkAsReadAll implements Usecase<void, NoParams> {
  final NotificationRepository repository;

  MarkAsReadAll(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.markAsReadAll();
  }
}
