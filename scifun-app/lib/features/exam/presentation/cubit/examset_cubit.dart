import 'package:equatable/equatable.dart';
import 'package:sci_fun/features/exam/data/model/examset_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/features/exam/domain/usecase/get_examset.dart';
import 'package:sci_fun/core/utils/usecase.dart';

sealed class ExamsetState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExamsetInitial extends ExamsetState {}

class ExamsetLoading extends ExamsetState {}

class ExamsetLoaded extends ExamsetState {
  final List<ExamsetModel> examsets;

  ExamsetLoaded(this.examsets);

  @override
  List<Object?> get props => [examsets];
}

class ExamsetError extends ExamsetState {
  final String message;

  ExamsetError(this.message);

  @override
  List<Object?> get props => [message];
}

class ExamsetCubit extends Cubit<ExamsetState> {
  final GetExamset getExamset;

  ExamsetCubit(this.getExamset) : super(ExamsetInitial());

  Future<void> fetchExamsets({required int page}) async {
    if (isClosed) return;

    emit(ExamsetLoading());

    final result = await getExamset(PaginationParam(page: page));

    result.fold(
      (failure) => emit(ExamsetError(failure.message)),
      (examsets) => emit(ExamsetLoaded(examsets)),
    );
  }
}
