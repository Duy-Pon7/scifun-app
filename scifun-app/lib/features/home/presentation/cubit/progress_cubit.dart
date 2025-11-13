import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/home/domain/entity/response_progress_entity.dart';
import 'package:sci_fun/features/home/domain/usecase/get_subject_progress.dart';

abstract class ProgressState extends Equatable {
  const ProgressState();

  @override
  List<Object?> get props => [];
}

class ProgressInitial extends ProgressState {}

class ProgressLoading extends ProgressState {}

class ProgressLoaded extends ProgressState {
  final ResponseProgressEntity progress;

  const ProgressLoaded(this.progress);

  @override
  List<Object?> get props => [progress];
}

class ProgressError extends ProgressState {
  final String message;

  const ProgressError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProgressCubit extends Cubit<ProgressState> {
  final GetSubjectProgress getSubjectProgress;

  ProgressCubit(this.getSubjectProgress) : super(ProgressInitial());

  Future<void> fetchProgress(int subjectId, {int page = 1}) async {
    emit(ProgressLoading());

    final result = await getSubjectProgress(
      PaginationParam(param: subjectId, page: page),
    );

    result.fold(
      (failure) => emit(ProgressError((failure.message))),
      (progress) => emit(ProgressLoaded(progress)),
    );
  }
}
