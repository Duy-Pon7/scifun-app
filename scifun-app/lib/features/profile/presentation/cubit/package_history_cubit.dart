import 'package:sci_fun/features/profile/domain/entities/package_history_entity.dart';
import 'package:sci_fun/features/profile/domain/usecase/get_history_packages.dart';
import 'package:sci_fun/common/cubit/pagination_cubit.dart';

// Tạo cubit cho package history
class PackageHistoryCubit
    extends PaginationCubit<NotificationEntity?, PackageHistoryParams> {
  PackageHistoryCubit({
    required GetHistoryPackages getHistoryPackages,
  }) : super(usecase: getHistoryPackages);
}
