import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:sci_fun/common/cubit/pagination_cubit.dart';
import 'package:sci_fun/common/widget/app_empty_state.dart';
import 'package:sci_fun/common/widget/app_loading_indicator.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/services/sound_service.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/profile/presentation/cubit/user_cubit.dart';
import 'package:sci_fun/features/question/domain/entity/question_entity.dart';
import 'package:sci_fun/features/question/domain/usecase/submit_quiz.dart';
import 'package:sci_fun/features/question/presentation/cubit/question_by_id_cubit.dart';
import 'package:sci_fun/features/question/presentation/cubit/question_cubit.dart';
import 'package:sci_fun/features/question/presentation/cubit/submit_quiz_cubit.dart';
import 'package:sci_fun/features/question/presentation/page/quiz_result_page.dart';
import 'package:sci_fun/features/question/presentation/page/widgets/quiz_chat_sheet.dart';
import 'package:sci_fun/features/question/presentation/page/widgets/test_question_content.dart';

class TestPage extends StatefulWidget {
  final String quizzId;

  const TestPage({super.key, required this.quizzId});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late final QuestionCubit cubit;
  late final QuestionByIdCubit questionByIdCubit;
  late final SubmitQuizCubit submitQuizCubit;
  late final QuizChatController quizChatController;

  int currentIndex = 0;
  bool isAnswerChecked = false;
  bool isCheckingAnswer = false;
  bool currentAnswerIsCorrect = false;
  Set<String> checkedCorrectAnswerIds = <String>{};
  bool isExplanationExpanded = false;
  String currentExplanation = '';

  // Store selected answer IDs by question ID.
  final Map<String, List<String>> selectedAnswers = {};
  static const double _chatButtonSize = 56;
  double chatButtonTop = 200;
  double chatButtonLeft = 20;

  @override
  void initState() {
    super.initState();
    cubit = QuestionCubit(sl());
    cubit.loadInitial(filterId: widget.quizzId);
    questionByIdCubit = sl<QuestionByIdCubit>();
    submitQuizCubit = SubmitQuizCubit(sl<SubmitQuiz>());
    quizChatController = QuizChatController();
  }

  @override
  void dispose() {
    quizChatController.dispose();
    cubit.close();
    questionByIdCubit.close();
    submitQuizCubit.close();
    super.dispose();
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildExitButton(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20.r),
      onTap: () => Navigator.of(context).pop(),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Icon(
          Symbols.close_rounded,
          size: 28.sp,
          color: const Color(0xFFB8B8B8),
        ),
      ),
    );
  }

  void _onChatButtonPressed() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => QuizChatSheet(controller: quizChatController),
    );
  }

  void _handleChatButtonDrag({
    required DragUpdateDetails details,
    required double maxTop,
    required double maxLeft,
  }) {
    setState(() {
      final nextTop = chatButtonTop + details.delta.dy;
      final nextLeft = chatButtonLeft + details.delta.dx;
      chatButtonTop = nextTop.clamp(0.0, maxTop).toDouble();
      chatButtonLeft = nextLeft.clamp(0.0, maxLeft).toDouble();
    });
  }

  bool _isMultiSelectQuestion(QuestionEntity question) {
    return question.answers.where((a) => a.isCorrect == true).length > 1;
  }

  Set<String> _extractCorrectAnswerIds(QuestionEntity question) {
    return question.answers
        .where((answer) => answer.isCorrect == true && answer.id != null)
        .map((answer) => answer.id!)
        .toSet();
  }

  void _applyCheckResult({
    required QuestionEntity question,
    required Set<String> correctIds,
    required String explanation,
  }) {
    if (!mounted) return;
    final questionId = question.id;
    if (questionId == null) return;

    final selected = Set<String>.from(
      selectedAnswers[questionId] ?? const <String>[],
    );
    final isCorrect = selected.length == correctIds.length &&
        selected.containsAll(correctIds);

    unawaited(
      isCorrect
          ? SoundService.instance.playSuccess()
          : SoundService.instance.playWrong(),
    );

    setState(() {
      isCheckingAnswer = false;
      isAnswerChecked = true;
      currentAnswerIsCorrect = isCorrect;
      checkedCorrectAnswerIds = correctIds;
      currentExplanation = explanation;
      isExplanationExpanded = false;
    });
  }

  void _toggleAnswerSelection({
    required QuestionEntity question,
    required String answerId,
    required bool isMultiSelect,
  }) {
    final questionId = question.id;
    if (questionId == null) return;

    final selectedIds = List<String>.from(selectedAnswers[questionId] ?? []);
    if (isMultiSelect) {
      if (selectedIds.contains(answerId)) {
        selectedIds.remove(answerId);
      } else {
        selectedIds.add(answerId);
      }
    } else {
      selectedIds
        ..clear()
        ..add(answerId);
    }

    setState(() {
      selectedAnswers[questionId] = selectedIds;
    });

    unawaited(SoundService.instance.playLuyenTap1ChamClick());
  }

  Future<void> _checkCurrentQuestion(QuestionEntity question) async {
    final questionId = question.id;
    if (questionId == null) return;

    final selectedCurrent = selectedAnswers[questionId] ?? const <String>[];
    if (selectedCurrent.isEmpty) {
      _showSnack('Vui lòng chọn đáp án trước khi tiếp tục.');
      return;
    }

    setState(() {
      isCheckingAnswer = true;
      checkedCorrectAnswerIds = <String>{};
      currentAnswerIsCorrect = false;
      currentExplanation = '';
      isExplanationExpanded = false;
    });

    await questionByIdCubit.fetchQuestionById(questionId);
  }

  void _continueOrSubmit(List<QuestionEntity> questions) {
    if (questions.isEmpty) return;

    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        isAnswerChecked = false;
        isCheckingAnswer = false;
        currentAnswerIsCorrect = false;
        checkedCorrectAnswerIds = <String>{};
        currentExplanation = '';
        isExplanationExpanded = false;
      });
      return;
    }

    submitAnswer(questions);
  }

  void submitAnswer(List<QuestionEntity> questions) {
    final questionIds = questions.map((q) => q.id).whereType<String>().toList();
    final unansweredCount = questionIds
        .where((id) => (selectedAnswers[id] ?? const <String>[]).isEmpty)
        .length;

    if (unansweredCount > 0) {
      _showSnack('Bạn còn $unansweredCount câu chưa trả lời.');
      return;
    }

    final answersPayload = questionIds.map((questionId) {
      final selectedIds = selectedAnswers[questionId] ?? const <String>[];
      if (selectedIds.length > 1) {
        return {
          'questionId': questionId,
          'selectedAnswerIds': selectedIds,
        };
      }

      return {
        'questionId': questionId,
        'selectedAnswerId': selectedIds.first,
      };
    }).toList();

    final userState = context.read<UserCubit>().state;
    var userId = 'unknown';
    if (userState is UserLoaded) {
      userId = userState.user.data?.id ?? 'unknown';
    }

    submitQuizCubit.submit(
      userId: userId,
      quizId: widget.quizzId,
      answers: answersPayload,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<QuestionCubit>.value(value: cubit),
        BlocProvider<QuestionByIdCubit>.value(value: questionByIdCubit),
        BlocProvider<SubmitQuizCubit>.value(value: submitQuizCubit),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F8F8),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxChatTop = (constraints.maxHeight - _chatButtonSize)
                  .clamp(0.0, double.infinity)
                  .toDouble();
              final maxChatLeft = (constraints.maxWidth - _chatButtonSize)
                  .clamp(0.0, double.infinity)
                  .toDouble();

              return Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 12.h),
                    child: BlocBuilder<QuestionCubit,
                        PaginationState<QuestionEntity>>(
                      builder: (context, state) {
                        if (state is PaginationLoading<QuestionEntity>) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildExitButton(context),
                              const Expanded(
                                child: Center(
                                  child: AppLoadingIndicator(
                                      message: 'Đang vào bài học...'),
                                ),
                              ),
                            ],
                          );
                        }

                        if (state is PaginationError<QuestionEntity> &&
                            state.items.isEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildExitButton(context),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'Lỗi: ${state.error}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: const Color(0xFF4F4F4F),
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        final items = state.items;
                        if (items.isEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildExitButton(context),
                              const Expanded(
                                child: Center(
                                  child: AppEmptyState(
                                    message: 'Không có câu hỏi',
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        final question = items[currentIndex];
                        final isMultiSelect = _isMultiSelectQuestion(question);
                        final selectedIds = List<String>.from(
                          selectedAnswers[question.id] ?? const <String>[],
                        );
                        final submitState =
                            context.watch<SubmitQuizCubit>().state;
                        final isSubmitting = submitState is SubmitQuizLoading;

                        return MultiBlocListener(
                          listeners: [
                            BlocListener<SubmitQuizCubit, SubmitQuizState>(
                              listener: (context, submitState) {
                                if (submitState is SubmitQuizSuccess) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => QuizResultPage(
                                          result: submitState.result),
                                    ),
                                  );
                                } else if (submitState is SubmitQuizError) {
                                  _showSnack(submitState.message);
                                }
                              },
                            ),
                            BlocListener<QuestionByIdCubit, QuestionByIdState>(
                              listener: (context, questionByIdState) {
                                final activeQuestion = items[currentIndex];

                                if (questionByIdState is QuestionByIdLoaded) {
                                  final fetchedQuestion =
                                      questionByIdState.question;
                                  final correctIds =
                                      fetchedQuestion.id == activeQuestion.id
                                          ? _extractCorrectAnswerIds(
                                              fetchedQuestion)
                                          : _extractCorrectAnswerIds(
                                              activeQuestion);
                                  final explanation =
                                      (fetchedQuestion.id == activeQuestion.id
                                              ? fetchedQuestion.explanation
                                              : activeQuestion.explanation)
                                          ?.trim();
                                  _applyCheckResult(
                                    question: activeQuestion,
                                    correctIds: correctIds,
                                    explanation: explanation ?? '',
                                  );
                                } else if (questionByIdState
                                    is QuestionByIdError) {
                                  _showSnack(questionByIdState.message);
                                  _applyCheckResult(
                                    question: activeQuestion,
                                    correctIds: _extractCorrectAnswerIds(
                                        activeQuestion),
                                    explanation:
                                        activeQuestion.explanation?.trim() ??
                                            '',
                                  );
                                }
                              },
                            ),
                          ],
                          child: TestQuestionContent(
                            exitButton: _buildExitButton(context),
                            items: items,
                            currentIndex: currentIndex,
                            question: question,
                            selectedIds: selectedIds,
                            checkedCorrectAnswerIds: checkedCorrectAnswerIds,
                            isMultiSelect: isMultiSelect,
                            isSubmitting: isSubmitting,
                            isCheckingAnswer: isCheckingAnswer,
                            isAnswerChecked: isAnswerChecked,
                            currentAnswerIsCorrect: currentAnswerIsCorrect,
                            isExplanationExpanded: isExplanationExpanded,
                            currentExplanation: currentExplanation,
                            onToggleExplanation: () {
                              setState(() {
                                isExplanationExpanded = !isExplanationExpanded;
                              });
                            },
                            onAnswerTap: (answerId) => _toggleAnswerSelection(
                              question: question,
                              answerId: answerId,
                              isMultiSelect: isMultiSelect,
                            ),
                            onPrimaryAction: () {
                              if (isAnswerChecked) {
                                _continueOrSubmit(items);
                              } else {
                                _checkCurrentQuestion(question);
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: chatButtonTop.clamp(0.0, maxChatTop).toDouble(),
                    left: chatButtonLeft.clamp(0.0, maxChatLeft).toDouble(),
                    child: GestureDetector(
                      onPanUpdate: (details) => _handleChatButtonDrag(
                        details: details,
                        maxTop: maxChatTop,
                        maxLeft: maxChatLeft,
                      ),
                      child: FloatingActionButton(
                        heroTag: 'test_page_chat_fab',
                        backgroundColor: AppColor.skyblue500,
                        onPressed: _onChatButtonPressed,
                        child: Icon(
                          Symbols.pets_rounded,
                          size: 24.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
