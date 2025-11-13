import 'package:sci_fun/common/cubit/paginator_cubit.dart';
import 'package:sci_fun/features/notification/data/models/noti_model.dart';
import 'package:sci_fun/features/notification/domain/usecases/get_notification.dart';

class NotificationPaginatorCubit extends PaginatorCubit<NotiModel, void> {
  NotificationPaginatorCubit(GetNotifications usecase)
      : super(usecase: usecase, limit: 10);
}
