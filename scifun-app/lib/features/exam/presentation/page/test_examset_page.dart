import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:sci_fun/common/helper/latex_extension.dart';
import 'package:sci_fun/common/helper/show_alert_dialog.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/common/widget/custom_network_asset_image.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/home/presentation/cubit/countdown_cubit.dart';
import 'package:sci_fun/features/home/presentation/cubit/quizz_cubit.dart';
import 'package:sci_fun/features/home/presentation/page/homework_all_ques.dart';
import 'package:sci_fun/features/home/presentation/page/result_test_page.dart';

class TestExamsetPage extends StatefulWidget {
  const TestExamsetPage(
      {super.key, required this.subjectId, required this.examSetId});
  final int subjectId;
  final int examSetId;

  @override
  State<TestExamsetPage> createState() => _TestExamsetPageState();
}

class _TestExamsetPageState extends State<TestExamsetPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CountdownCubit(totalSeconds: 5400), //5400
        ),
        BlocProvider(
          create: (context) => sl<QuizzCubit>()
            ..getExamsetQuizz(
                subjectId: widget.subjectId, examSetId: widget.examSetId),
        ),
      ],
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
        body: BlocListener<CountdownCubit, CountdownState>(
          listener: (context, state) {
            if (state.remainingSecond == 0) {
              Navigator.pushReplacement(
                context,
                slidePage(
                  ResultTestPage(
                    submissionData:
                        context.read<QuizzCubit>().getSubmissionData(),
                    timeTaken:
                        context.read<CountdownCubit>().getFormattedTimeTaken(),
                    quizzId: widget.examSetId,
                  ),
                ),
              );
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<CountdownCubit, CountdownState>(
                builder: (context, state) {
                  return Container(
                    margin: EdgeInsets.all(16.w),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      spacing: 8.w,
                      children: [
                        const Icon(Icons.timer_outlined),
                        Expanded(
                          flex: 7,
                          child: LinearProgressIndicator(
                            value: state.progress,
                            minHeight: 6,
                            backgroundColor:
                                Color(0xFF787880).withValues(alpha: 0.16),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.black),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            context
                                .read<CountdownCubit>()
                                .formatDuration(state.remainingSecond),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
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
                    final selectedIds =
                        state.selectedAnswers[currentQuestion.id] ?? [];
                    final isMultipleChoice =
                        currentQuestion.answerMode == 'multiple';

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
                        child: Column(
                          spacing: 20.h,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () => state.currentIndex > 0
                                      ? context.read<QuizzCubit>().preQuestion()
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
                                  onPressed: () =>
                                      state.currentIndex < questions.length - 1
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
                                    child: Html(
                                      data: preprocessLatex(
                                          currentQuestion.question ?? ""),
                                      extensions: [LatexExtension()],
                                    ),
                                  ),
                                  Text(
                                    "${currentQuestion.score ?? "0"} điểm",
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
                            ListView.separated(
                              shrinkWrap: true,
                              itemCount: currentQuestion.answers?.length ?? 0,
                              itemBuilder: (context, index) {
                                final answer = currentQuestion.answers![index];
                                final selected =
                                    selectedIds.contains(answer.id);

                                return GestureDetector(
                                  onTap: () =>
                                      context.read<QuizzCubit>().selectAnswer(
                                            currentQuestion.id!,
                                            answer.id!,
                                            isMultipleChoice,
                                          ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 12.h),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 0.5,
                                        color: Color(0xFF413E3E)
                                            .withValues(alpha: 0.3),
                                      ),
                                      borderRadius: BorderRadius.circular(24.r),
                                      color: selected
                                          ? AppColor.primary600
                                              .withValues(alpha: 0.15)
                                          : Colors.transparent,
                                    ),
                                    child: Row(
                                      spacing: 16.w,
                                      children: [
                                        Icon(
                                          isMultipleChoice
                                              ? (selected
                                                  ? Icons.check_box
                                                  : Icons
                                                      .check_box_outline_blank)
                                              : (selected
                                                  ? Icons.radio_button_checked
                                                  : Icons.radio_button_off),
                                          color: selected
                                              ? AppColor.primary600
                                              : AppColor.hurricane800
                                                  .withValues(alpha: 0.6),
                                        ),
                                        answer.answer!.startsWith("/public")
                                            ? CustomNetworkAssetImage(
                                                imagePath: answer.answer!,
                                                width: 80.w,
                                              )
                                            : Text(
                                                answer.answer ?? "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                      fontSize: 17.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                              ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                height: 12.h,
                              ),
                            ),
                          ],
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
                                          .getSubmissionData(),
                                      timeTaken: context
                                          .read<CountdownCubit>()
                                          .getFormattedTimeTaken(),
                                      // quizzId: widget.quizzId,
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
                                                  .getSubmissionData(),
                                              timeTaken: context
                                                  .read<CountdownCubit>()
                                                  .getFormattedTimeTaken(),
                                              // quizzId: widget.quizzId,
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
      ),
    );
  }
}
