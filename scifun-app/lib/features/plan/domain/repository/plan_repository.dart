import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/features/plan/domain/entity/plan_entity.dart';

abstract interface class PlanRepository {
  Future<Either<Failure, List<Plan>>> getAllPlans();

  /// Create a checkout session and return the payUrl
  Future<Either<Failure, String>> createCheckout({required int price});

  /// Verify ZaloPay payment and grant the plan
  Future<Either<Failure, String>> verifyPayment(
      {required String appTransId, required int durationDays});
}
