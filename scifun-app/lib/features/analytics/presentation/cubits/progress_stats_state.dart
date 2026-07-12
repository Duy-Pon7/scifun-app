part of 'progress_stats_cubit.dart';

abstract class ProgressStatsState extends Equatable {
  const ProgressStatsState();

  @override
  List<Object?> get props => [];
}

class ProgressStatsInitial extends ProgressStatsState {
  const ProgressStatsInitial();
}

class ProgressStatsLoading extends ProgressStatsState {
  const ProgressStatsLoading();
}

class ProgressStatsLoaded extends ProgressStatsState {
  const ProgressStatsLoaded(this.stats);

  final ProgressStatsEntity stats;

  @override
  List<Object?> get props => [stats];
}

class ProgressStatsError extends ProgressStatsState {
  const ProgressStatsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
