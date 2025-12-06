import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/features/analytics/domain/entities/progress_entity.dart';
import 'package:sci_fun/features/analytics/domain/usecase/get_progress.dart';

part 'progress_state.dart';

class ProgressCubit extends Cubit<ProgressState> {
  final GetProgress getProgress;

  ProgressCubit({required this.getProgress}) : super(ProgressInitial());

  Future<void> fetchProgress(String subjectId) async {
    emit(ProgressLoading());
    final result = await getProgress(ProgressParams(subjectId: subjectId));

    result.fold(
      (failure) => emit(ProgressError(failure.message)),
      (progress) => emit(ProgressLoaded(progress)),
    );
  }
}
