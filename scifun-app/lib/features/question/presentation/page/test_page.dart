import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:sci_fun/common/cubit/pagination_cubit.dart';
import 'package:sci_fun/common/widget/app_loading_indicator.dart';
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
        backgroundColor: const Color(0xFFF8F8F8),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 12.h),
            child: BlocBuilder<QuestionCubit, PaginationState<QuestionEntity>>(
              builder: (context, state) {
                if (state is PaginationLoading<QuestionEntity>) {
                  return const Center(
                    child: AppLoadingIndicator(message: 'Đang vào bài học...'),
                  );
                }

                if (state is PaginationError<QuestionEntity> &&
                    state.items.isEmpty) {
                  return Center(
                    child: Text(
                      'Loi: ${state.error}',
                      style: TextStyle(
                        color: const Color(0xFF4F4F4F),
                        fontSize: 16.sp,
                      ),
                    ),
                  );
                }

                final items = state.items;
                if (items.isEmpty) {
                  return Center(
                    child: Text(
                      'Khong co cau hoi',
                      style: TextStyle(
                        color: const Color(0xFF4F4F4F),
                        fontSize: 16.sp,
                      ),
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
                final canCheck = selectedIds.isNotEmpty && !isSubmitting;
                final accent = AppColor.skyblue500;
                final accentDark = AppColor.skyblue700;
                final accentLight = AppColor.skyblue100;
                final accentMid = AppColor.skyblue300;

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
                              padding: EdgeInsets.all(4.w),
                              child: Icon(
                                Icons.close_rounded,
                                size: 28.sp,
                                color: const Color(0xFFB8B8B8),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(999.r),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 14.h,
                                backgroundColor: const Color(0xFFD9D9D9),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  accent,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Icon(
                            Icons.favorite_rounded,
                            color: const Color(0xFFF8505D),
                            size: 24.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '5',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFE34D57),
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'Chon nghia dung',
                        style: TextStyle(
                          fontSize: 39.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF333333),
                          height: 1.1,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 110.w,
                            height: 110.w,
                            child: Lottie.asset(
                              appLoadingLottieAssetPath,
                              fit: BoxFit.contain,
                              repeat: true,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: _WordBubble(text: question.text ?? ''),
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
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColor.hurricane500,
                            ),
                          ),
                        ),
                      SizedBox(height: 16.h),
                      Expanded(
                        child: ListView.separated(
                          itemCount: answers.length,
                          separatorBuilder: (_, __) => SizedBox(height: 10.h),
                          itemBuilder: (context, index) {
                            final answer = answers[index];
                            final answerId = answer.id;
                            final isSelected = answerId != null &&
                                selectedIds.contains(answerId);

                            return BasicButton(
                              onPressed: (answerId == null || isSubmitting)
                                  ? () {}
                                  : () => _toggleAnswerSelection(
                                        question: question,
                                        answerId: answerId,
                                        isMultiSelect: isMultiSelect,
                                      ),
                              width: double.infinity,
                              height: 66.h,
                              borderRadius: BorderRadius.circular(16.r),
                              border: true,
                              borderWidth: isSelected ? 1.8 : 1.2,
                              borderColor: isSelected
                                  ? AppColor.skyblue400
                                  : AppColor.hurricane200,
                              backgroundColor:
                                  isSelected ? accentLight : Colors.white,
                              buttonColor: isSelected
                                  ? accentMid
                                  : AppColor.hurricane100,
                              textColor: isSelected
                                  ? accentDark
                                  : const Color(0xFF4B4B4B),
                              buttonHeight: isSelected ? 5 : 4,
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Text(
                                answer.text ?? '',
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 23.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? accentDark
                                      : const Color(0xFF4B4B4B),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 12.h),
                      BasicButton(
                        text: isSubmitting ? 'DANG GUI...' : 'KIEM TRA',
                        width: double.infinity,
                        height: 56.h,
                        borderRadius: BorderRadius.circular(16.r),
                        fontSize: 27.sp,
                        fontWeight: FontWeight.w700,
                        textColor:
                            canCheck ? Colors.white : AppColor.hurricane300,
                        backgroundColor:
                            canCheck ? accent : AppColor.hurricane100,
                        buttonColor:
                            canCheck ? accentDark : AppColor.hurricane200,
                        onPressed:
                            canCheck ? () => _goNextOrSubmit(items) : () {},
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _WordBubble extends StatelessWidget {
  const _WordBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    const Color borderColor = Color(0xFFE2E2E2);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: borderColor, width: 1.3),
          ),
          child: Text(
            text,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF3D3D3D),
              height: 1.2,
            ),
          ),
        ),
        Positioned(
          left: -7.w,
          top: 22.h,
          child: Transform.rotate(
            angle: -0.785398,
            child: Container(
              width: 15.w,
              height: 15.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  left: BorderSide(color: borderColor, width: 1.3),
                  top: BorderSide(color: borderColor, width: 1.3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
