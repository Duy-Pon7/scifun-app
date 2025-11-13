import 'package:thilop10_3004/common/cubit/paginator_cubit.dart';
import 'package:thilop10_3004/features/notification/data/models/noti_model.dart';
import 'package:thilop10_3004/features/notification/domain/usecases/get_notification.dart';

class NotificationPaginatorCubit extends PaginatorCubit<NotiModel, void> {
  NotificationPaginatorCubit(GetNotifications usecase)
      : super(usecase: usecase, limit: 10);
}
