import 'package:thilop10_3004/features/profile/domain/entities/package_history_entity.dart';
import 'package:thilop10_3004/features/profile/domain/usecase/get_history_packages.dart';
import 'package:thilop10_3004/common/cubit/pagination_cubit.dart';

// Tạo cubit cho package history
class PackageHistoryCubit
    extends PaginationCubit<NotificationEntity?, PackageHistoryParams> {
  PackageHistoryCubit({
    required GetHistoryPackages getHistoryPackages,
  }) : super(usecase: getHistoryPackages);
}
