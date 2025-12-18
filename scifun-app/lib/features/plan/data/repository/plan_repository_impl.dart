import 'package:dartz/dartz.dart';
import 'package:sci_fun/core/error/failure.dart';
import 'package:sci_fun/core/error/server_exception.dart';
import 'package:sci_fun/features/plan/data/datasource/plan_remote_datasource.dart';
import 'package:sci_fun/features/plan/domain/entity/plan_entity.dart';
import 'package:sci_fun/features/plan/domain/repository/plan_repository.dart';

class PlanRepositoryImpl implements PlanRepository {
  final PlanRemoteDatasource planRemoteDatasource;

  PlanRepositoryImpl({required this.planRemoteDatasource});

  @override
  Future<Either<Failure, List<Plan>>> getAllPlans() async {
    try {
      final res = await planRemoteDatasource.getAllPlans();
      return Right(res
          .map((m) => Plan(
                id: m.id,
                name: m.name,
                price: m.price,
                durationDays: m.durationDays,
                createdAt: m.createdAt,
                updatedAt: m.updatedAt,
              ))
          .toList());
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> createCheckout({required int price}) async {
    try {
      final res = await planRemoteDatasource.createCheckout(price: price);
      return Right(res);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
