import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/features/plan/domain/entity/plan_entity.dart';
import 'package:sci_fun/features/plan/domain/usecase/get_all_plan.dart';
import 'package:sci_fun/core/utils/usecase.dart';

sealed class PlanState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PlanInitial extends PlanState {}

class PlanLoading extends PlanState {}

class PlansLoaded extends PlanState {
  final List<Plan> plans;

  PlansLoaded(this.plans);

  @override
  List<Object?> get props => [plans];
}

class PlanError extends PlanState {
  final String message;

  PlanError(this.message);

  @override
  List<Object?> get props => [message];
}

class PlanCubit extends Cubit<PlanState> {
  final GetAllPlans getAllPlans;

  PlanCubit({required this.getAllPlans}) : super(PlanInitial());

  Future<void> getPlans() async {
    emit(PlanLoading());

    try {
      final res = await getAllPlans(NoParams());

      res.fold(
        (failure) => emit(PlanError(failure.message)),
        (data) => emit(PlansLoaded(data)),
      );
    } catch (e) {
      emit(PlanError(e.toString()));
    }
  }
}
