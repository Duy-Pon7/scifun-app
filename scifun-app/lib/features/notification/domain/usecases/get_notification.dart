import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/features/notification/data/models/noti_model.dart';
import 'package:sci_fun/features/notification/domain/repositories/notification_repository.dart';
import 'package:sci_fun/core/utils/usecase.dart';

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
