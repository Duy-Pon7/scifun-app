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
  String? selectedAnswerId;
  bool submitted = false;
  int score = 0;

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

  void submitAnswer(List<QuestionEntity> questions) {
    // Chuẩn bị dữ liệu answers cho API
    final answersPayload = questions
        .map<Map<String, dynamic>>((q) {
          final selected =
              q.answers.where((a) => a.id == selectedAnswerId).toList();
          if (selected.isEmpty) return <String, dynamic>{};
          final answer = selected.first;
          return {
            "questionId": q.id,
            "selectedAnswerId": answer.id,
          };
        })
        .where((a) => a.isNotEmpty)
        .toList();

    if (answersPayload.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn đáp án')),
      );
      return;
    }

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

  void nextQuestion(int total) {
    if (currentIndex < total - 1) {
      setState(() {
        currentIndex += 1;
        selectedAnswerId = null;
        submitted = false;
      });
    } else {
      // finish
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Hoàn thành'),
          content: Text('Điểm: $score / $total'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Đóng'),
            ),
          ],
        ),
      );
    }
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
              print('Current Pagination State: $state'); // Debug print
              if (state is PaginationLoading<QuestionEntity>) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is PaginationError<QuestionEntity> &&
                  state.items.isEmpty) {
                print('PaginationError: ${state.error}'); // Debug print
                return Center(child: Text('Lỗi: ${state.error}'));
              }
              final items = state.items;
              if (items.isEmpty) {
                return const Center(child: Text('Không có câu hỏi'));
              }
              final q = items[currentIndex];
              final answers = q.answers;

              return BlocListener<SubmitQuizCubit, SubmitQuizState>(
                listener: (context, submitState) {
                  if (submitState is SubmitQuizSuccess) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: currentIndex > 0
                              ? () => setState(() {
                                    currentIndex -= 1;
                                    selectedAnswerId = null;
                                    submitted = false;
                                  })
                              : null,
                        ),
                        Text('Câu ${currentIndex + 1}/${items.length}',
                            style: TextStyle(fontSize: 16.sp)),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios),
                          onPressed: currentIndex < items.length - 1
                              ? () => setState(() {
                                    currentIndex += 1;
                                    selectedAnswerId = null;
                                    submitted = false;
                                  })
                              : null,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      q.text ?? '',
                      style: TextStyle(fontSize: 16.sp, height: 1.4),
                    ),
                    SizedBox(height: 12.h),
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
                                : () =>
                                    setState(() => selectedAnswerId = ans.id),
                            borderRadius: BorderRadius.circular(24.0),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 12.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24.0),
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
                                        : (v) => setState(
                                            () => selectedAnswerId = v),
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
                    if (submitted && (q.explanation?.isNotEmpty ?? false)) ...[
                      SizedBox(height: 8.h),
                      Text('Giải thích:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4.h),
                      Text(q.explanation ?? ''),
                    ],
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              submitAnswer(items);
                            },
                            child: const Text('Nộp bài'),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => nextQuestion(items.length),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                            child: const Text('Câu tiếp theo'),
                          ),
                        ),
                      ],
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
