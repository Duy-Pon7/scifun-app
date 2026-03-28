import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/profile/domain/entities/order_history_entity.dart';
import 'package:sci_fun/features/profile/domain/repository/packages_repository.dart';

class GetOrderHistory
    implements
        Usecase<UserOrderHistoryEntity, PaginationParam<OrderHistoryParams>> {
  final PackagesRepository packagesRepository;

  GetOrderHistory({required this.packagesRepository});

  @override
  Future<Either<Failure, UserOrderHistoryEntity>> call(
    PaginationParam<OrderHistoryParams> param,
  ) async {
    return packagesRepository.getOrderHistory(
      page: param.page,
      limit: param.param?.limit ?? 10,
    );
  }
}

class OrderHistoryParams {
  const OrderHistoryParams({this.limit = 10});

  final int limit;
}
