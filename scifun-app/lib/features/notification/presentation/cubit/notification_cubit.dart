import 'package:sci_fun/common/cubit/pagination_cubit.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/notification/domain/entity/notification_entity.dart';
import 'package:sci_fun/features/notification/domain/usecase/get_notification.dart';

/// Cubit that provides paginated notifications using [PaginationCubit]
final class NotificationCubit extends PaginationCubit<Item> {
  final GetNotifications getNotifications;

  NotificationCubit({required this.getNotifications}) : super();

  @override
  Future<List<Item>> fetchData(
    int page,
    int limit, {
    String? searchQuery,
    String? filterId,
  }) async {
    final res =
        await getNotifications(PaginationParam<int>(page: page, param: limit));

    return res.fold((failure) {
      throw Exception(failure.message);
    }, (items) => items);
  }
}
