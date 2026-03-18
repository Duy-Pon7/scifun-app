import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/features/question/domain/entity/question_entity.dart';
import 'package:sci_fun/features/question/domain/usecase/get_question_by_id.dart';

sealed class QuestionByIdState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QuestionByIdInitial extends QuestionByIdState {}

class QuestionByIdLoading extends QuestionByIdState {}

class QuestionByIdLoaded extends QuestionByIdState {
  final QuestionEntity question;

  QuestionByIdLoaded(this.question);

  @override
  List<Object?> get props => [question];
}

class QuestionByIdError extends QuestionByIdState {
  final String message;

  QuestionByIdError(this.message);

  @override
  List<Object?> get props => [message];
}

class QuestionByIdCubit extends Cubit<QuestionByIdState> {
  final GetQuestionById getQuestionById;

  QuestionByIdCubit(this.getQuestionById) : super(QuestionByIdInitial());

  Future<void> fetchQuestionById(String questionId) async {
    emit(QuestionByIdLoading());
    try {
      final res = await getQuestionById(
        QuestionByIdParams(questionId: questionId),
      );
      res.fold(
        (failure) => emit(QuestionByIdError(failure.message)),
        (question) => emit(QuestionByIdLoaded(question)),
      );
    } catch (e) {
      emit(QuestionByIdError(e.toString()));
    }
  }
}
