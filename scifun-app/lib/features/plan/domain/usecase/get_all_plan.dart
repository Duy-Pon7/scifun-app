import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/plan/domain/entity/plan_entity.dart';
import 'package:sci_fun/features/plan/domain/repository/plan_repository.dart';

class GetAllPlans implements Usecase<List<Plan>, NoParams> {
  final PlanRepository planRepository;

  GetAllPlans({required this.planRepository});

  @override
  Future<Either<Failure, List<Plan>>> call(NoParams params) async {
    return await planRepository.getAllPlans();
  }
}
