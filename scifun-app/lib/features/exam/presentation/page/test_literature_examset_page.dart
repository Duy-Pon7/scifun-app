import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:sci_fun/common/helper/show_alert_dialog.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/home/presentation/cubit/quizz_cubit.dart';
import 'package:sci_fun/features/home/presentation/page/homework_all_ques.dart';
import 'package:sci_fun/features/home/presentation/page/result_test_page.dart';

class TestLiteratureExamsetPage extends StatefulWidget {
  const TestLiteratureExamsetPage(
      {super.key, required this.subjectId, required this.examSetId});
  final int subjectId;
  final int examSetId;

  @override
  State<TestLiteratureExamsetPage> createState() =>
      _TestLiteratureExamsetPageState();
}

class _TestLiteratureExamsetPageState extends State<TestLiteratureExamsetPage> {
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
            create: (context) => sl<QuizzCubit>()
              ..getExamsetQuizz(
                  subjectId: widget.subjectId, examSetId: widget.examSetId),
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
              final savedAnswer =
                  state.writtenAnswers[currentQuestion.id] ?? '';
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
                "Kiểm tra",
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
                onPressed: () => showAlertDialog(
                  context,
                  () {},
                  () => Navigator.pop(context),
                  "Đồng ý thoát khỏi kiểm tra",
                  "Bạn có chắc chắn muốn thoát khỏi bài kiểm tra này?",
                  "Hủy",
                  "Đồng ý",
                ),
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
                              state.selectedAnswers[entry.value.id]
                                  ?.isNotEmpty ??
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
                    print(state);
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
                              spacing: 20.h,
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
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: _containsLatex(
                                                currentQuestion.question ?? "")
                                            ? TeXView(
                                                child: _createTexViewChild(
                                                    currentQuestion.question ??
                                                        ""),
                                                style: TeXViewStyle(
                                                  elevation: 0,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  margin: TeXViewMargin.all(0),
                                                  padding:
                                                      TeXViewPadding.all(0),
                                                ),
                                                // renderingEngine: TeXViewRenderingEngine.katex(),
                                              )
                                            : currentQuestion.question!
                                                    .startsWith("<")
                                                ? Html(
                                                    data: currentQuestion
                                                        .question,
                                                    style: {
                                                      "p": Style(
                                                        fontSize:
                                                            FontSize(17.sp),
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      )
                                                    },
                                                  )
                                                : Text(
                                                    currentQuestion.question ??
                                                        "",
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
                                      Text(
                                        "2 điểm",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                              fontSize: 12.sp,
                                              color: AppColor.primary500,
                                              fontWeight: FontWeight.w400,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColor.border,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 12.h),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Bài làm',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20.sp,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        TextField(
                                          controller: _answerController,
                                          maxLines: 10,
                                          minLines: 10,
                                          onChanged: (value) {
                                            context
                                                .read<QuizzCubit>()
                                                .saveWrittenAnswer(
                                                  currentQuestion.id!,
                                                  value,
                                                );
                                          },
                                          decoration: InputDecoration(
                                            hintText:
                                                'Nhập câu trả lời của bạn tại đây...',
                                            filled: true,
                                            border:
                                                InputBorder.none, // <== bỏ viền
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                          ),
                                        )
                                      ],
                                    ),
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
                BlocBuilder<QuizzCubit, QuizzState>(
                  builder: (context, state) {
                    if (state is! QuizzDetailLoaded) {
                      return const SizedBox.shrink();
                    }

                    final questions = state.quizzEntity.questions ?? [];
                    final isLastQuestion =
                        state.currentIndex >= questions.length - 1;

                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(
                                color: Colors.black.withValues(alpha: 0.3),
                                width: 0.3),
                          ),
                        ),
                        child: isLastQuestion
                            ? BasicButton(
                                text: "Nộp bài",
                                fontSize: 20.sp,
                                onPressed: () => showAlertDialog(
                                  context,
                                  () => Navigator.pushReplacement(
                                      context,
                                      slidePage(ResultTestPage(
                                        submissionData: context
                                            .read<QuizzCubit>()
                                            .getSubmissionEssayData(),
                                      ))),
                                  () {},
                                  "Xác nhận nộp bài",
                                  "Bạn có chắc chắn muốn nộp bài kiểm tra không?",
                                  "Đồng ý",
                                  "Hủy",
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 16.h,
                                ),
                                backgroundColor: Colors.black,
                              )
                            : Row(
                                spacing: 12.w,
                                children: [
                                  Expanded(
                                    child: BasicButton(
                                      text: "Nộp bài",
                                      fontSize: 20.sp,
                                      onPressed: () {
                                        showAlertDialog(
                                          context,
                                          () => Navigator.pushReplacement(
                                              context,
                                              slidePage(ResultTestPage(
                                                submissionData: context
                                                    .read<QuizzCubit>()
                                                    .getSubmissionEssayData(),
                                              ))),
                                          () {},
                                          "Xác nhận nộp bài",
                                          "Bạn có chắc chắn muốn nộp bài kiểm tra không?",
                                          "Đồng ý",
                                          "Hủy",
                                        );
                                      },
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 16.h,
                                      ),
                                      backgroundColor: Colors.transparent,
                                      border: true,
                                      borderWidth: 1,
                                      textColor: Colors.black,
                                    ),
                                  ),
                                  Expanded(
                                    child: BasicButton(
                                      text: "Câu tiếp theo",
                                      fontSize: 20.sp,
                                      onPressed: () => context
                                          .read<QuizzCubit>()
                                          .nextQuestion(),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 16.h,
                                      ),
                                      backgroundColor: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ));
  }
}
