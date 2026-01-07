import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/features/plan/domain/entity/plan_entity.dart';
import 'package:sci_fun/features/plan/domain/entity/checkout_response.dart';

abstract interface class PlanRepository {
  Future<Either<Failure, List<Plan>>> getAllPlans();

  /// Create a checkout session and return CheckoutResponse
  Future<Either<Failure, CheckoutResponse>> createCheckout(
      {required int price, required int durationDays});

  /// Verify ZaloPay payment and grant the plan
  Future<Either<Failure, String>> verifyPayment(
      {required String appTransId, required int durationDays});
}
