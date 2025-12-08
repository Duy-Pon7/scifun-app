part of 'quizz_detail_cubit.dart';

abstract class QuizzDetailState {}

class QuizzDetailInitial extends QuizzDetailState {}

class QuizzLoading extends QuizzDetailState {}

class QuizzDetailLoaded extends QuizzDetailState {
  final QuizzEntity quizzEntity;
  final int currentIndex;
  final Map<String, List<String>> selectedAnswers;

  QuizzDetailLoaded({
    required this.quizzEntity,
    required this.currentIndex,
    required this.selectedAnswers,
  });
}

class QuizzError extends QuizzDetailState {
  final String message;

  QuizzError(this.message);
}
