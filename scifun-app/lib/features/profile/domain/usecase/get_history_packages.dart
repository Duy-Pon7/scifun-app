import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/profile/domain/entities/package_history_entity.dart';
import 'package:sci_fun/features/profile/domain/repository/packages_repository.dart';

class GetHistoryPackages
    implements
        Usecase<List<NotificationEntity?>,
            PaginationParam<PackageHistoryParams>> {
  final PackagesRepository packagesRepository;

  GetHistoryPackages({required this.packagesRepository});

  @override
  Future<Either<Failure, List<NotificationEntity?>>> call(
      PaginationParam<PackageHistoryParams> param) async {
    return await packagesRepository.getHistoryPackage(
      page: param.page,
    );
  }
}

class PackageHistoryParams {
  final int page;

  PackageHistoryParams({required this.page});
}
