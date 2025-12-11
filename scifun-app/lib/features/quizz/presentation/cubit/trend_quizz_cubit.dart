import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/quizz/domain/entity/quizz_trend_entity.dart';
import 'package:sci_fun/features/quizz/domain/usecase/get_trend_quizz.dart';

sealed class TrendQuizzState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TrendQuizzInitial extends TrendQuizzState {}

class TrendQuizzLoading extends TrendQuizzState {}

class TrendQuizzLoaded extends TrendQuizzState {
  final QuizzTrend trendData;
  TrendQuizzLoaded(this.trendData);

  @override
  List<Object?> get props => [trendData];
}

class TrendQuizzError extends TrendQuizzState {
  final String message;
  TrendQuizzError(this.message);

  @override
  List<Object?> get props => [message];
}

class TrendQuizzCubit extends Cubit<TrendQuizzState> {
  final GetTrendQuizzes getTrendQuizzes;

  TrendQuizzCubit(this.getTrendQuizzes) : super(TrendQuizzInitial());

  Future<void> fetchTrendQuizzes() async {
    emit(TrendQuizzLoading());
    try {
      final res = await getTrendQuizzes.call(NoParams());
      res.fold(
        (failure) => emit(TrendQuizzError(failure.message)),
        (trendData) => emit(TrendQuizzLoaded(trendData)),
      );
    } catch (e) {
      emit(TrendQuizzError(e.toString()));
    }
  }
}
