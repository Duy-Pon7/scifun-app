import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/plan/domain/repository/plan_repository.dart';

class VerifyPaymentParams {
  final String appTransId;
  final int durationDays;

  VerifyPaymentParams({required this.appTransId, required this.durationDays});
}

class VerifyPayment implements Usecase<String, VerifyPaymentParams> {
  final PlanRepository planRepository;

  VerifyPayment({required this.planRepository});

  @override
  Future<Either<Failure, String>> call(VerifyPaymentParams params) async {
    return await planRepository.verifyPayment(
      appTransId: params.appTransId,
      durationDays: params.durationDays,
    );
  }
}
