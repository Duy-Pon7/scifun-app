import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/features/quizz/domain/entity/quizz_result_entity.dart';
import 'package:sci_fun/features/quizz/domain/usecase/get_submission_detail.dart';

sealed class SubmissionDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmissionDetailInitial extends SubmissionDetailState {}

class SubmissionDetailLoading extends SubmissionDetailState {}

class SubmissionDetailLoaded extends SubmissionDetailState {
  final QuizzResult quizzResult;
  SubmissionDetailLoaded(this.quizzResult);

  @override
  List<Object?> get props => [quizzResult];
}

class SubmissionDetailError extends SubmissionDetailState {
  final String message;
  SubmissionDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

class SubmissionDetailCubit extends Cubit<SubmissionDetailState> {
  final GetSubmissionDetail getSubmissionDetail;

  SubmissionDetailCubit(this.getSubmissionDetail)
      : super(SubmissionDetailInitial());

  Future<void> fetchSubmission(String submissionId) async {
    emit(SubmissionDetailLoading());
    try {
      final res =
          await getSubmissionDetail.call(SubmissionParams(submissionId));
      res.fold(
        (failure) => emit(SubmissionDetailError(failure.message)),
        (result) => emit(SubmissionDetailLoaded(result)),
      );
    } catch (e) {
      emit(SubmissionDetailError(e.toString()));
    }
  }
}
