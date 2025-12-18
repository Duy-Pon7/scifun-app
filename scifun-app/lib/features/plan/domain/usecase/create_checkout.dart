import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/plan/domain/repository/plan_repository.dart';

class CreateCheckoutParams {
  final int price;

  CreateCheckoutParams({required this.price});
}

class CreateCheckout implements Usecase<String, CreateCheckoutParams> {
  final PlanRepository planRepository;

  CreateCheckout({required this.planRepository});

  @override
  Future<Either<Failure, String>> call(CreateCheckoutParams params) async {
    return await planRepository.createCheckout(price: params.price);
  }
}
