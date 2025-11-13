import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/features/notification/domain/repositories/notification_repository.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';

class MarkAsReadAll implements Usecase<void, NoParams> {
  final NotificationRepository repository;

  MarkAsReadAll(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.markAsReadAll();
  }
}
