import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/plan/domain/entity/checkout_response.dart';
import 'package:sci_fun/features/plan/domain/repository/plan_repository.dart';

class CreateCheckoutParams {
  final int price;
  final int durationDays;

  CreateCheckoutParams({required this.price, required this.durationDays});
}

class CreateCheckout
    implements Usecase<CheckoutResponse, CreateCheckoutParams> {
  final PlanRepository planRepository;

  CreateCheckout({required this.planRepository});

  @override
  Future<Either<Failure, CheckoutResponse>> call(
      CreateCheckoutParams params) async {
    return await planRepository.createCheckout(
        price: params.price, durationDays: params.durationDays);
  }
}
