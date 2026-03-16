import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:sci_fun/common/cubit/pagination_cubit.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/profile/presentation/cubit/user_cubit.dart';
import 'package:sci_fun/features/question/domain/entity/question_entity.dart';
import 'package:sci_fun/features/question/domain/usecase/submit_quiz.dart';
import 'package:sci_fun/features/question/presentation/cubit/question_cubit.dart';
import 'package:sci_fun/features/question/presentation/cubit/submit_quiz_cubit.dart';
import 'package:sci_fun/features/question/presentation/page/quiz_result_page.dart';

class TestPage extends StatefulWidget {
  final String quizzId;

  const TestPage({super.key, required this.quizzId});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late final QuestionCubit cubit;
  late final SubmitQuizCubit submitQuizCubit;

  int currentIndex = 0;

  // Store selected answer IDs by question ID.
  final Map<String, List<String>> selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    cubit = QuestionCubit(sl());
    cubit.loadInitial(filterId: widget.quizzId);
    submitQuizCubit = SubmitQuizCubit(sl<SubmitQuiz>());
  }

  @override
  void dispose() {
    cubit.close();
    submitQuizCubit.close();
    super.dispose();
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool _isMultiSelectQuestion(QuestionEntity question) {
    return question.answers.where((a) => a.isCorrect == true).length > 1;
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
  }

  void _goNextOrSubmit(List<QuestionEntity> questions) {
    if (questions.isEmpty) return;

    final currentQuestion = questions[currentIndex];
    final currentQuestionId = currentQuestion.id;
    final selectedCurrent = currentQuestionId == null
        ? const <String>[]
        : (selectedAnswers[currentQuestionId] ?? const <String>[]);

    if (selectedCurrent.isEmpty) {
      _showSnack('Vui long chon dap an truoc khi tiep tuc.');
      return;
    }

    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
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
      _showSnack('Ban con $unansweredCount cau chua tra loi.');
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
        BlocProvider<SubmitQuizCubit>.value(value: submitQuizCubit),
      ],
      child: Scaffold(
        backgroundColor: AppColor.hurricane950,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColor.hurricane950,
                AppColor.hurricane900,
                AppColor.hurricane950,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child:
                  BlocBuilder<QuestionCubit, PaginationState<QuestionEntity>>(
                builder: (context, state) {
                  if (state is PaginationLoading<QuestionEntity>) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is PaginationError<QuestionEntity> &&
                      state.items.isEmpty) {
                    return Center(
                      child: Text(
                        'Loi: ${state.error}',
                        style: TextStyle(color: AppColor.hurricane50),
                      ),
                    );
                  }

                  final items = state.items;
                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        'Khong co cau hoi',
                        style: TextStyle(color: AppColor.hurricane50),
                      ),
                    );
                  }

                  final question = items[currentIndex];
                  final answers = question.answers;
                  final isMultiSelect = _isMultiSelectQuestion(question);
                  final selectedIds = List<String>.from(
                    selectedAnswers[question.id] ?? const <String>[],
                  );
                  final submitState = context.watch<SubmitQuizCubit>().state;
                  final isSubmitting = submitState is SubmitQuizLoading;
                  final progress = (currentIndex + 1) / items.length;

                  return BlocListener<SubmitQuizCubit, SubmitQuizState>(
                    listener: (context, submitState) {
                      if (submitState is SubmitQuizSuccess) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                QuizResultPage(result: submitState.result),
                          ),
                        );
                      } else if (submitState is SubmitQuizError) {
                        _showSnack(submitState.message);
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(20.r),
                              onTap: () => Navigator.of(context).pop(),
                              child: Padding(
                                padding: EdgeInsets.all(6.w),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 26.sp,
                                  color: AppColor.hurricane200,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(999.r),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 12.h,
                                  color: AppColor.yellowgreen500,
                                  backgroundColor:
                                      AppColor.hurricane700.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 22.h),
                        Text(
                          'Chon nghia dung',
                          style: TextStyle(
                            fontSize: 34.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColor.hurricane50,
                          ),
                        ),
                        SizedBox(height: 14.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 110.w,
                              height: 110.w,
                              child: Lottie.asset(
                                'assets/lottie_json/cat.json',
                                fit: BoxFit.contain,
                                repeat: true,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 14.h),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 14.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColor.hurricane900
                                      .withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: AppColor.hurricane600
                                        .withValues(alpha: 0.8),
                                    width: 1.2,
                                  ),
                                ),
                                child: Text(
                                  question.text ?? '',
                                  style: TextStyle(
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColor.hurricane50,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (isMultiSelect)
                          Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: Text(
                              'Co the chon nhieu dap an',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColor.hurricane200,
                              ),
                            ),
                          ),
                        SizedBox(height: 12.h),
                        Expanded(
                          child: ListView.separated(
                            itemCount: answers.length,
                            separatorBuilder: (_, __) => SizedBox(height: 10.h),
                            itemBuilder: (context, index) {
                              final answer = answers[index];
                              final answerId = answer.id;
                              final isSelected = answerId != null &&
                                  selectedIds.contains(answerId);

                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: (answerId == null || isSubmitting)
                                    ? null
                                    : () => _toggleAnswerSelection(
                                          question: question,
                                          answerId: answerId,
                                          isMultiSelect: isMultiSelect,
                                        ),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 18.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColor.hurricane900.withValues(
                                      alpha: isSelected ? 0.95 : 0.75,
                                    ),
                                    borderRadius: BorderRadius.circular(16.r),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColor.skyblue400
                                          : AppColor.hurricane700,
                                      width: isSelected ? 1.6 : 1.1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          answer.text ?? '',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 24.sp,
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w600,
                                            color: isSelected
                                                ? AppColor.skyblue300
                                                : AppColor.hurricane50,
                                          ),
                                        ),
                                      ),
                                      if (isSelected)
                                        Icon(
                                          isMultiSelect
                                              ? Icons.check_box_rounded
                                              : Icons
                                                  .radio_button_checked_rounded,
                                          color: AppColor.skyblue300,
                                          size: 18.sp,
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 10.h),
                        BasicButton(
                          text: isSubmitting ? 'DANG GUI...' : 'KIEM TRA',
                          width: double.infinity,
                          height: 56.h,
                          borderRadius: BorderRadius.circular(18.r),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          textColor: selectedIds.isNotEmpty && !isSubmitting
                              ? AppColor.hurricane950
                              : AppColor.hurricane300,
                          backgroundColor:
                              selectedIds.isNotEmpty && !isSubmitting
                                  ? AppColor.hurricane200
                                  : AppColor.hurricane700,
                          buttonColor: selectedIds.isNotEmpty && !isSubmitting
                              ? AppColor.hurricane300
                              : AppColor.hurricane800,
                          onPressed: selectedIds.isNotEmpty && !isSubmitting
                              ? () => _goNextOrSubmit(items)
                              : () {},
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
