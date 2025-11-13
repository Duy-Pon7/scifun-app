import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:thilop10_3004/common/widget/basic_appbar.dart';
import 'package:thilop10_3004/core/di/injection.dart';
import 'package:thilop10_3004/core/utils/theme/app_color.dart';
import 'package:thilop10_3004/features/home/domain/entity/user_answer_entity.dart';
import 'package:thilop10_3004/features/home/presentation/cubit/quizz_cubit.dart';
import 'package:thilop10_3004/features/home/presentation/page/homework_all_ques.dart';

class TestHistoryLiteraturePage extends StatefulWidget {
  const TestHistoryLiteraturePage({super.key, required this.quizzId});
  final int? quizzId;

  @override
  State<TestHistoryLiteraturePage> createState() =>
      _TestHistoryLiteraturePageState();
}

class _TestHistoryLiteraturePageState extends State<TestHistoryLiteraturePage> {
  bool _showAnswer = true;
  bool _showTeacherComment = true;
  TextEditingController _answerController = TextEditingController();
  bool _containsLatex(String content) {
    return content.contains(r'\(') ||
        content.contains(r'\[') ||
        content.contains(r'$$') ||
        content.contains(r'$');
  }

  TeXViewWidget _createTexViewChild(String content) {
    return TeXViewColumn(
      children: [
        TeXViewDocument(
          content,
          style: TeXViewStyle(
            textAlign: TeXViewTextAlign.left,
            fontStyle: TeXViewFontStyle(
              fontSize: 17,
              fontWeight: TeXViewFontWeight.w600,
            ),
            backgroundColor: Colors.transparent,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<QuizzCubit>()..getDetailQuizz(quizzId: widget.quizzId ?? 0),
        ),
      ],
      child: BlocListener<QuizzCubit, QuizzState>(
        listenWhen: (previous, current) {
          return current is QuizzDetailLoaded && previous != current;
        },
        listener: (context, state) {
          if (state is QuizzDetailLoaded) {
            final currentQuestion =
                state.quizzEntity.questions![state.currentIndex];
            final savedAnswer = state.writtenAnswers[currentQuestion.id] ?? '';
            _answerController.value = TextEditingValue(
              text: savedAnswer,
              selection: TextSelection.fromPosition(
                TextPosition(offset: savedAnswer.length),
              ),
            );
          }
        },
        child: Scaffold(
          appBar: BasicAppbar(
            title: Text(
              "Chi tiết bài làm",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: AppColor.primary600,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          backgroundColor: AppColor.hurricane50,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<QuizzCubit, QuizzState>(
                builder: (context, state) {
                  if (state is QuizzDetailLoaded) {
                    final questions = state.quizzEntity.questions ?? [];

                    // Danh sách index của các câu đã chọn
                    final answeredQuestionIndexes = questions
                        .asMap()
                        .entries
                        .where((entry) =>
                            state.selectedAnswers[entry.value.id]?.isNotEmpty ??
                            false)
                        .map((entry) => entry.key)
                        .toList();

                    return GestureDetector(
                      onTap: () {
                        final quizzCubit = context.read<QuizzCubit>();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: quizzCubit,
                              child: Builder(
                                builder: (newContext) => HomeworkAllQues(
                                  totalQuestions: questions.length,
                                  currentIndex: state.currentIndex,
                                  answeredQuestionIndexes:
                                      answeredQuestionIndexes,
                                  onQuestionTap: (index) {
                                    newContext
                                        .read<QuizzCubit>()
                                        .jumpToQuestion(index);
                                    Navigator.pop(newContext);
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Tất cả câu hỏi",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: AppColor.primary500,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            SizedBox(width: 8.w),
                            Icon(
                              Icons.widgets_outlined,
                              color: AppColor.primary500,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink(); // Tránh render khi chưa sẵn sàng
                },
              ),
              BlocBuilder<QuizzCubit, QuizzState>(
                builder: (context, state) {
                  if (state is QuizzDetailLoaded) {
                    EasyLoading.dismiss();
                    final questions = state.quizzEntity.questions ?? [];
                    if (questions.isEmpty) {
                      EasyLoading.showToast(
                        "Chưa có dữ liệu",
                        toastPosition: EasyLoadingToastPosition.bottom,
                      );
                      return SizedBox.shrink();
                    }
                    final currentQuestion = questions[state.currentIndex];
                    final statePending = state.quizzEntity.quizResult?.status;
                    final stateScore = state.quizzEntity.quizResult?.score;
                    final answersList = state.quizzEntity.quizResult?.answers;

                    UserAnswerEntity? userAnswerEntry;

                    try {
                      userAnswerEntry = answersList?.firstWhere(
                        (answer) => answer.questionId == currentQuestion.id,
                      );
                    } catch (e) {
                      userAnswerEntry = null;
                    }

                    final userAnswerText = userAnswerEntry?.textAnswer ?? '';

                    return Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical: 24.h, horizontal: 16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(28.w),
                            topRight: Radius.circular(28.w),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            // Thay spacing bằng SizedBox nếu dùng Column vì Column ko có spacing
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () => state.currentIndex > 0
                                        ? context
                                            .read<QuizzCubit>()
                                            .preQuestion()
                                        : null,
                                    icon: Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "Câu ${state.currentIndex + 1}/${questions.length}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          fontSize: 20.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  IconButton(
                                    onPressed: () => state.currentIndex <
                                            questions.length - 1
                                        ? context
                                            .read<QuizzCubit>()
                                            .nextQuestion()
                                        : null,
                                    icon: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.h),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      color: AppColor.primary500,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17.sp),
                                  children: [
                                    TextSpan(text: "Tổng số điểm: "),
                                    TextSpan(
                                      text: statePending == 'pending'
                                          ? "đợi chấm "
                                          : stateScore.toString(),
                                      style: TextStyle(
                                          color: AppColor.primary500,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17.sp),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: _containsLatex(
                                            currentQuestion.question ?? "")
                                        ? TeXView(
                                            child: _createTexViewChild(
                                                currentQuestion.question ?? ""),
                                            style: TeXViewStyle(
                                              elevation: 0,
                                              backgroundColor:
                                                  Colors.transparent,
                                              margin: TeXViewMargin.all(0),
                                              padding: TeXViewPadding.all(0),
                                            ),
                                          )
                                        : currentQuestion.question!
                                                .startsWith("<")
                                            ? Html(
                                                data: currentQuestion.question,
                                                style: {
                                                  "p": Style(
                                                    fontSize: FontSize(17.sp),
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  )
                                                },
                                              )
                                            : Text(
                                                currentQuestion.question ?? "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                      fontSize: 17.sp,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),

                              // Khung Bài làm
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColor.border, width: 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      title: Text(
                                        'Bài làm',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20.sp,
                                        ),
                                      ),
                                      trailing: Icon(
                                        _showAnswer
                                            ? Icons.expand_less
                                            : Icons.expand_more,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _showAnswer = !_showAnswer;
                                        });
                                      },
                                    ),
                                    if (_showAnswer)
                                      Padding(
                                        padding: EdgeInsets.all(12.w),
                                        child: Text(
                                          userAnswerText,
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Colors.black87),
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 20.h),

                              // Nhận xét của giáo viên
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColor.border, width: 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      title: Text(
                                        'Nhận xét của giáo viên',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20.sp,
                                        ),
                                      ),
                                      trailing: Icon(
                                        _showTeacherComment
                                            ? Icons.expand_less
                                            : Icons.expand_more,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _showTeacherComment =
                                              !_showTeacherComment;
                                        });
                                      },
                                    ),
                                    if (_showTeacherComment)
                                      Padding(
                                        padding: EdgeInsets.all(12.w),
                                        child: currentQuestion.solution !=
                                                    null &&
                                                currentQuestion.solution!
                                                    .startsWith("<")
                                            ? Html(
                                                data: currentQuestion.solution!,
                                                style: {
                                                  "body": Style(
                                                    fontSize: FontSize(16.sp),
                                                    color: Colors.black87,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                },
                                              )
                                            : Text(
                                                currentQuestion.solution ??
                                                    'Chưa có nhận xét',
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    color: Colors.black87),
                                              ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (state is QuizzLoading) {
                    EasyLoading.show(
                      status: 'Đang tải',
                      maskType: EasyLoadingMaskType.black,
                    );
                  } else if (state is QuizzError) {
                    EasyLoading.dismiss();
                    EasyLoading.showToast(
                      state.message,
                      toastPosition: EasyLoadingToastPosition.bottom,
                    );
                  } else {
                    EasyLoading.dismiss();
                  }
                  return SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
