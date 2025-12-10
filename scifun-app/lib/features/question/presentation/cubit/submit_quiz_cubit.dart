import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/features/question/domain/usecase/submit_quiz.dart';

abstract class SubmitQuizState {}

class SubmitQuizInitial extends SubmitQuizState {}

class SubmitQuizLoading extends SubmitQuizState {}

class SubmitQuizSuccess extends SubmitQuizState {
  final Map<String, dynamic> result;
  SubmitQuizSuccess(this.result);
}

class SubmitQuizError extends SubmitQuizState {
  final String message;
  SubmitQuizError(this.message);
}

class SubmitQuizCubit extends Cubit<SubmitQuizState> {
  final SubmitQuiz submitQuiz;
  SubmitQuizCubit(this.submitQuiz) : super(SubmitQuizInitial());

  Future<void> submit({
    required String userId,
    required String quizId,
    required List<Map<String, dynamic>> answers,
  }) async {
    emit(SubmitQuizLoading());
    final result = await submitQuiz(
      SubmitQuizParams(userId: userId, quizId: quizId, answers: answers),
    );
    result.fold(
      (failure) => emit(SubmitQuizError(failure.message)),
      (data) => emit(SubmitQuizSuccess(data)),
    );
  }
}
