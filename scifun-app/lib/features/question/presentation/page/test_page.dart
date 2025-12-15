import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/features/question/presentation/cubit/question_cubit.dart';
import 'package:sci_fun/features/question/domain/entity/question_entity.dart';
import 'package:sci_fun/common/cubit/pagination_cubit.dart';
import 'package:sci_fun/features/question/presentation/cubit/submit_quiz_cubit.dart';
import 'package:sci_fun/features/question/domain/usecase/submit_quiz.dart';
import 'package:sci_fun/features/profile/presentation/cubit/user_cubit.dart';
import 'quiz_result_page.dart';

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
  bool submitted = false;

  /// ✅ LƯU ĐÁP ÁN THEO QUESTION ID
  final Map<String, String> selectedAnswers = {};

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

  /// ✅ SUBMIT BÀI
  void submitAnswer(List<QuestionEntity> questions) {
    if (selectedAnswers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ít nhất 1 đáp án')),
      );
      return;
    }

    final answersPayload = selectedAnswers.entries.map((e) {
      return {
        "questionId": e.key,
        "selectedAnswerId": e.value,
      };
    }).toList();

    final userState = context.read<UserCubit>().state;
    String userId = "unknown";
    if (userState is UserLoaded) {
      userId = userState.user.data?.id ?? "unknown";
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
        appBar: const BasicAppbar(title: 'Bài tập tự luyện'),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: BlocBuilder<QuestionCubit, PaginationState<QuestionEntity>>(
            builder: (context, state) {
              if (state is PaginationLoading<QuestionEntity>) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is PaginationError<QuestionEntity> &&
                  state.items.isEmpty) {
                return Center(child: Text('Lỗi: ${state.error}'));
              }

              final items = state.items;
              if (items.isEmpty) {
                return const Center(child: Text('Không có câu hỏi'));
              }

              final q = items[currentIndex];
              final answers = q.answers;

              /// ✅ LẤY ĐÁP ÁN ĐÃ CHỌN TRƯỚC ĐÓ (NẾU CÓ)
              final selectedAnswerId = selectedAnswers[q.id];

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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(submitState.message)),
                    );
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /// HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: currentIndex > 0
                              ? () => setState(() {
                                    currentIndex--;
                                    submitted = false;
                                  })
                              : null,
                        ),
                        Text(
                          'Câu ${currentIndex + 1}/${items.length}',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios),
                          onPressed: currentIndex < items.length - 1
                              ? () => setState(() {
                                    currentIndex++;
                                    submitted = false;
                                  })
                              : null,
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),

                    /// QUESTION
                    Text(
                      q.text ?? '',
                      style: TextStyle(fontSize: 16.sp, height: 1.4),
                    ),

                    SizedBox(height: 12.h),

                    /// ANSWERS
                    Expanded(
                      child: ListView.separated(
                        itemCount: answers.length,
                        separatorBuilder: (_, __) => SizedBox(height: 8.h),
                        itemBuilder: (context, index) {
                          final ans = answers[index];
                          final bool isSelected = ans.id == selectedAnswerId;

                          Color borderColor = Colors.grey.shade300;
                          if (submitted) {
                            if (ans.isCorrect == true) {
                              borderColor = Colors.green;
                            } else if (isSelected && ans.isCorrect != true) {
                              borderColor = Colors.red;
                            }
                          } else if (isSelected) {
                            borderColor = Theme.of(context).primaryColor;
                          }

                          return InkWell(
                            onTap: submitted
                                ? null
                                : () {
                                    setState(() {
                                      selectedAnswers[q.id ?? ""] = ans.id!;
                                    });
                                  },
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 12.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                border:
                                    Border.all(color: borderColor, width: 1.2),
                              ),
                              child: Row(
                                children: [
                                  Radio<String?>(
                                    value: ans.id,
                                    groupValue: selectedAnswerId,
                                    onChanged: submitted
                                        ? null
                                        : (v) {
                                            setState(() {
                                              selectedAnswers[q.id ?? ""] = v!;
                                            });
                                          },
                                  ),
                                  Expanded(
                                    child: Text(
                                      ans.text ?? '',
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                  ),
                                  if (submitted && ans.isCorrect == true)
                                    Icon(Icons.check_circle,
                                        color: Colors.green, size: 20.sp),
                                  if (submitted &&
                                      isSelected &&
                                      ans.isCorrect != true)
                                    Icon(Icons.cancel,
                                        color: Colors.red, size: 20.sp),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 12.h),

                    /// SUBMIT
                    OutlinedButton(
                      onPressed: () => submitAnswer(items),
                      child: const Text('Nộp bài'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
