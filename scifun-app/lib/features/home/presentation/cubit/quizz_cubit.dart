import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thilop10_3004/core/utils/usecase.dart';
import 'package:thilop10_3004/features/exam/domain/usecase/get_quizz_examsets.dart';
import 'package:thilop10_3004/features/home/domain/entity/quizz_entity.dart';
import 'package:thilop10_3004/features/home/domain/usecase/add_quizz.dart';
import 'package:thilop10_3004/features/home/domain/usecase/get_quizz_by_lesson.dart';
import 'package:thilop10_3004/features/home/domain/usecase/get_quizz_detail.dart';

sealed class QuizzState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QuizzInitial extends QuizzState {}

class QuizzLoading extends QuizzState {}

class QuizzListLoaded extends QuizzState {
  final List<QuizzEntity> quizzes;

  QuizzListLoaded(this.quizzes);

  @override
  List<Object?> get props => [quizzes];
}

class QuizzDetailLoaded extends QuizzState {
  final QuizzEntity quizzEntity;
  final int currentIndex;
  final Map<int, List<int>> selectedAnswers;
  final Map<int, String> writtenAnswers;

  QuizzDetailLoaded(
    this.quizzEntity, {
    this.currentIndex = 0,
    this.selectedAnswers = const {},
    this.writtenAnswers = const {},
  });

  QuizzDetailLoaded copyWith({
    QuizzEntity? quizzEntity,
    int? currentIndex,
    Map<int, List<int>>? selectedAnswers,
    Map<int, String>? writtenAnswers,
  }) {
    return QuizzDetailLoaded(
      quizzEntity ?? this.quizzEntity,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      writtenAnswers: writtenAnswers ?? this.writtenAnswers,
    );
  }

  @override
  List<Object?> get props =>
      [quizzEntity, currentIndex, selectedAnswers, writtenAnswers];
}

class QuizzError extends QuizzState {
  final String message;

  QuizzError(this.message);

  @override
  List<Object?> get props => [message];
}

class QuizzCubit extends Cubit<QuizzState> {
  final GetQuizzDetail getQuizzDetail;
  final GetQuizzByLesson getQuizzByLesson;
  final AddQuizz _addQuizz;
  final GetQuizzExamsets getQuizzExamsets;
  QuizzCubit(this.getQuizzDetail, this._addQuizz, this.getQuizzExamsets,
      this.getQuizzByLesson)
      : super(QuizzInitial());
  Future<void> fetchQuizz(
      {required int examSetId, required int subjectId}) async {
    emit(QuizzLoading());

    final result = await getQuizzExamsets(
      QuizzParam(examSetId: examSetId, subjectId: subjectId),
    );

    result.fold(
      (failure) => emit(QuizzError(failure.message)),
      (quizz) => emit(QuizzDetailLoaded(quizz)),
    );
  }

  Future<void> getExamsetQuizz({
    required int subjectId,
    required int examSetId,
  }) async {
    emit(QuizzLoading());
    try {
      final res = await getQuizzExamsets.call(
        QuizzParam(examSetId: examSetId, subjectId: subjectId),
      );
      res.fold(
        (failure) => emit(QuizzError(failure.message)),
        (data) => emit(QuizzDetailLoaded(data)),
      );
    } catch (e) {
      emit(QuizzError(e.toString()));
    }
  }

  Future<void> getDetailQuizz({required int quizzId}) async {
    emit(QuizzLoading());
    try {
      final res = await getQuizzDetail.call(quizzId);

      res.fold(
        (failure) => emit(QuizzError(failure.message)),
        (data) => emit(QuizzDetailLoaded(data)),
      );
    } catch (e) {
      emit(QuizzError(e.toString()));
    }
  }

  Future<void> addQuizz({required Map<String, dynamic> quizzParam}) async {
    emit(QuizzLoading());
    try {
      final res = await _addQuizz.call(quizzParam);

      res.fold(
        (failure) => emit(QuizzError(failure.message)),
        (data) => emit(QuizzDetailLoaded(data)),
      );
    } catch (e) {
      emit(QuizzError(e.toString()));
    }
  }

  Future<void> fetchQuizzByLesson(
      {required int page, required int lessonId}) async {
    emit(QuizzLoading());
    try {
      final res = await getQuizzByLesson.call(
        PaginationParam(param: lessonId, page: page),
      );

      res.fold(
        (failure) => emit(QuizzError(failure.message)),
        (data) {
          if (data.isNotEmpty) {
            emit(QuizzListLoaded(data)); // ✅ emit danh sách đầy đủ
          } else {
            emit(QuizzError("Không có dữ liệu quiz"));
          }
        },
      );
    } catch (e) {
      emit(QuizzError(e.toString()));
    }
  }

  void selectAnswer(int questionId, int answerId, bool isMultiAns) {
    final currentState = state;

    if (currentState is QuizzDetailLoaded) {
      final current = currentState.selectedAnswers[questionId] ?? [];

      List<int> updated;
      if (isMultiAns) {
        updated = current.contains(answerId)
            ? current.where((id) => id != answerId).toList()
            : [...current, answerId];
      } else {
        updated = [answerId];
      }

      emit(currentState.copyWith(selectedAnswers: {
        ...currentState.selectedAnswers,
        questionId: updated
      }));
    }
  }

  void nextQuestion() {
    final currentState = state;
    if (currentState is QuizzDetailLoaded) {
      final questions = currentState.quizzEntity.questions ?? [];
      if (currentState.currentIndex < questions.length - 1) {
        emit(
            currentState.copyWith(currentIndex: currentState.currentIndex + 1));
      }
    }
  }

  void preQuestion() {
    final currentState = state;
    if (currentState is QuizzDetailLoaded) {
      if (currentState.currentIndex > 0) {
        emit(
            currentState.copyWith(currentIndex: currentState.currentIndex - 1));
      }
    }
  }

  void jumpToQuestion(int index) {
    emit(
      (state as QuizzDetailLoaded).copyWith(currentIndex: index),
    );
  }

  Map<String, dynamic> getSubmissionData() {
    final currentState = state;
    if (currentState is QuizzDetailLoaded) {
      final answers = currentState.selectedAnswers.entries
          .map((entry) => {
                "question_id": entry.key,
                "answer_ids": entry.value,
              })
          .toList();

      return {
        "quiz_id": currentState.quizzEntity.id,
        "answers": answers,
      };
    }
    return {};
  }

  void saveWrittenAnswer(int questionId, String answerText) {
    final currentState = state;
    if (currentState is QuizzDetailLoaded) {
      final updatedAnswers = {
        ...currentState.writtenAnswers,
        questionId: answerText,
      };

      emit(currentState.copyWith(writtenAnswers: updatedAnswers));
    }
  }

  Map<String, dynamic> getSubmissionEssayData() {
    final currentState = state;
    if (currentState is QuizzDetailLoaded) {
      final answers = currentState.writtenAnswers.entries
          .map((entry) => {
                "question_id": entry.key,
                "text_answer": entry.value,
              })
          .toList();
      return {
        "quiz_id": currentState.quizzEntity.id,
        "type": "essay",
        "answers": answers,
      };
    }
    return {};
  }
}
