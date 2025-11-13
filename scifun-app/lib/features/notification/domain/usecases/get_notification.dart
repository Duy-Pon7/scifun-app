import 'package:dartz/dartz.dart';
import 'package:thilop10_3004/core/error/failure.dart';
import 'package:thilop10_3004/features/notification/data/models/noti_model.dart';
import 'package:thilop10_3004/features/notification/domain/repositories/notification_repository.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';

class GetNotifications
    implements Usecase<List<NotiModel>, PaginationParam<void>> {
  final NotificationRepository repository;

  GetNotifications(this.repository);

  @override
  Future<Either<Failure, List<NotiModel>>> call(
      PaginationParam<void> params) async {
    return await repository.getNotifications(
      page: params.page,
    );
  }
}
