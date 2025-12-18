import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/notification/domain/entity/notification_entity.dart';
import 'package:sci_fun/features/notification/domain/repository/notification_repository.dart';

/// Pagination-aware use case for fetching notifications.
/// Uses [PaginationParam<int>] where `page` is the page number and
/// `param` carries the `limit` (items per page).
class GetNotifications implements Usecase<List<Item>, PaginationParam<int>> {
  final NotificationRepository notificationRepository;

  GetNotifications(this.notificationRepository);

  @override
  Future<Either<Failure, List<Item>>> call(PaginationParam<int> params) async {
    final page = params.page;
    final limit = params.param ?? 10;
    return await notificationRepository.getNotifications(
      page: page,
      limit: limit,
    );
  }
}
