import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/analytics/domain/entities/progress_stats_entity.dart';
import 'package:sci_fun/features/analytics/domain/usecase/get_progress_stats.dart';

part 'progress_stats_state.dart';

class ProgressStatsCubit extends Cubit<ProgressStatsState> {
  ProgressStatsCubit({required this.getProgressStats})
      : super(const ProgressStatsInitial());

  final GetProgressStats getProgressStats;

  void _tryEmit(ProgressStatsState state) {
    if (!isClosed) emit(state);
  }

  Future<void> fetchProgressStats() async {
    _tryEmit(const ProgressStatsLoading());
    final result = await getProgressStats(NoParams());

    result.fold(
      (failure) => _tryEmit(ProgressStatsError(failure.message)),
      (stats) => _tryEmit(ProgressStatsLoaded(stats)),
    );
  }
}
