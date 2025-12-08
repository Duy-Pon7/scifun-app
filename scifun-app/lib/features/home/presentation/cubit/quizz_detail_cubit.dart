import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/features/home/domain/entity/quizz_entity.dart';
import 'package:sci_fun/features/home/domain/entity/question_entity.dart';
import 'package:sci_fun/features/home/domain/entity/answer_entity.dart';
import 'package:sci_fun/features/question/domain/usecase/get_all_question.dart';

part 'quizz_detail_state.dart';

class QuizzDetailCubit extends Cubit<QuizzDetailState> {
  final GetAllQuestions? getAllQuestions;

  QuizzDetailCubit({this.getAllQuestions}) : super(QuizzDetailInitial());

  // Lưu trữ quizz entity
  QuizzEntity? _quizzEntity;

  // Lưu trữ các câu trả lời được chọn: {questionId: [answerId]}
  Map<String, List<String>> _selectedAnswers = {};

  // Index câu hiện tại
  int _currentIndex = 0;

  // Load quiz detail từ quizzId
  Future<void> loadQuizzDetail(String quizzId) async {
    try {
      emit(QuizzLoading());

      if (getAllQuestions == null) {
        emit(QuizzError('GetAllQuestions usecase not initialized'));
        return;
      }

      final result = await getAllQuestions!(
        QuestionsParams(
          quizId: quizzId,
          page: 1,
          limit: 100, // Lấy hết tất cả câu hỏi
        ),
      );

      result.fold(
        (failure) => emit(QuizzError(failure.message)),
        (questionsResponse) {
          // Convert QuestionEntity từ question feature sang home feature format
          final convertedQuestions = questionsResponse.data.map((q) {
            // Chuyển đổi answers
            final convertedAnswers = (q.answers).map((a) {
              return AnswerEntity(
                id: int.tryParse(a.id ?? '0'),
                label: null,
                answer: a.text,
                type: null,
                isCorrect: a.isCorrect,
                group: null,
              );
            }).toList();

            return QuestionEntity(
              id: int.tryParse(q.id ?? '0'),
              question: q.text,
              questionType: null,
              solution: q.explanation,
              answerMode: null,
              score: null,
              answers: convertedAnswers,
            );
          }).toList();

          final quizzEntity = QuizzEntity(
            id: int.tryParse(quizzId),
            code: '',
            name: '',
            type: '',
            questions:
                convertedQuestions.isNotEmpty ? convertedQuestions : null,
            categorySubject: null,
            quizResult: null,
          );

          _quizzEntity = quizzEntity;
          _selectedAnswers = {};
          _currentIndex = 0;

          emit(QuizzDetailLoaded(
            quizzEntity: quizzEntity,
            currentIndex: _currentIndex,
            selectedAnswers: _selectedAnswers,
          ));
        },
      );
    } catch (e) {
      emit(QuizzError(e.toString()));
    }
  }

  // Khởi tạo với quizz entity
  void initialize(QuizzEntity quizzEntity) {
    _quizzEntity = quizzEntity;
    _selectedAnswers = {};
    _currentIndex = 0;
    emit(QuizzDetailLoaded(
      quizzEntity: quizzEntity,
      currentIndex: _currentIndex,
      selectedAnswers: _selectedAnswers,
    ));
  }

  // Chuyển sang câu tiếp theo
  void nextQuestion() {
    if (_quizzEntity == null) return;
    final questions = _quizzEntity!.questions ?? [];
    if (_currentIndex < questions.length - 1) {
      _currentIndex++;
      emit(QuizzDetailLoaded(
        quizzEntity: _quizzEntity!,
        currentIndex: _currentIndex,
        selectedAnswers: _selectedAnswers,
      ));
    }
  }

  // Quay lại câu trước
  void preQuestion() {
    if (_currentIndex > 0) {
      _currentIndex--;
      emit(QuizzDetailLoaded(
        quizzEntity: _quizzEntity!,
        currentIndex: _currentIndex,
        selectedAnswers: _selectedAnswers,
      ));
    }
  }

  // Nhảy tới câu hỏi cụ thể
  void jumpToQuestion(int index) {
    if (_quizzEntity == null) return;
    final questions = _quizzEntity!.questions ?? [];
    if (index >= 0 && index < questions.length) {
      _currentIndex = index;
      emit(QuizzDetailLoaded(
        quizzEntity: _quizzEntity!,
        currentIndex: _currentIndex,
        selectedAnswers: _selectedAnswers,
      ));
    }
  }

  // Chọn/bỏ chọn câu trả lời
  void selectAnswer(
    dynamic questionId,
    dynamic answerId,
    bool isMultipleChoice,
  ) {
    // Convert to string if needed
    final qId = questionId.toString();
    final aId = answerId.toString();

    if (isMultipleChoice) {
      // Multiple choice: cho phép chọn nhiều đáp án
      if (_selectedAnswers.containsKey(qId)) {
        final selectedList = _selectedAnswers[qId]!;
        if (selectedList.contains(aId)) {
          selectedList.remove(aId);
        } else {
          selectedList.add(aId);
        }
      } else {
        _selectedAnswers[qId] = [aId];
      }
    } else {
      // Single choice: chỉ cho phép chọn một đáp án
      if (_selectedAnswers.containsKey(qId)) {
        final selectedList = _selectedAnswers[qId]!;
        if (selectedList.contains(aId)) {
          selectedList.clear();
        } else {
          selectedList.clear();
          selectedList.add(aId);
        }
      } else {
        _selectedAnswers[qId] = [aId];
      }
    }
    emit(QuizzDetailLoaded(
      quizzEntity: _quizzEntity!,
      currentIndex: _currentIndex,
      selectedAnswers: _selectedAnswers,
    ));
  }

  // Lấy dữ liệu submission
  Map<String, dynamic> getSubmissionData() {
    return {
      'quizzId': _quizzEntity?.id,
      'answers': _selectedAnswers,
    };
  }
}
