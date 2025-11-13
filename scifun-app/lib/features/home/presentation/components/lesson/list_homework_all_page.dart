import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:thilop10_3004/common/widget/custom_network_asset_image.dart';
import 'package:thilop10_3004/core/utils/theme/app_color.dart';
import 'package:thilop10_3004/features/home/domain/entity/question_entity.dart';
import 'package:thilop10_3004/features/home/domain/entity/user_answer_entity.dart';

class ListHomeworkAllPage extends StatelessWidget {
  final List<QuestionEntity> questions;
  final List<UserAnswerEntity> resultAnswers;

  const ListHomeworkAllPage({
    super.key,
    required this.questions,
    required this.resultAnswers,
  });
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

  /// Convert user answer list to Map<questionId, List<selectedAnswerIds>>
  Map<int, List<int>> getSelectedAnswerMap(List<UserAnswerEntity> answers) {
    final map = <int, List<int>>{};
    for (var ua in answers) {
      if (ua.questionId != null && ua.userAnswerIds != null) {
        map[ua.questionId!] = ua.userAnswerIds!;
      }
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Center(child: Text("Chưa có dữ liệu"));
    }

    final selectedAnswers = getSelectedAnswerMap(resultAnswers);

    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        // ======= Phần hiển thị tổng số câu và nút làm lại =======
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Tổng số câu: ${questions.length}",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 17.sp,
                    color: AppColor.primary500,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              "Làm lại",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 15.sp,
                    color: AppColor.primary500,
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ],
        ),
        SizedBox(height: 20.h),

        // ======= Danh sách câu hỏi =======
        ...List.generate(questions.length, (questionIndex) {
          final question = questions[questionIndex];
          final selectedIds = selectedAnswers[question.id] ?? [];
          final isMultipleChoice = question.answerMode == 'multiple';

          return Container(
            margin: EdgeInsets.only(bottom: 24.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Câu hỏi
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Câu ${questionIndex + 1}: ",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Expanded(
                      child: _containsLatex(question.question ?? "")
                          ? TeXView(
                              child:
                                  _createTexViewChild(question.question ?? ""),
                              style: TeXViewStyle(
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                margin: TeXViewMargin.all(0),
                                padding: TeXViewPadding.all(0),
                              ),
                            )
                          : (question.question?.startsWith("<") ?? false)
                              ? Html(
                                  data: question.question,
                                  style: {
                                    "p": Style(
                                      fontSize: FontSize(17.sp),
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    )
                                  },
                                )
                              : Text(
                                  question.question ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Danh sách đáp án
                ...List.generate(question.answers?.length ?? 0, (answerIndex) {
                  final answer = question.answers![answerIndex];
                  final selected = selectedIds.contains(answer.id);
                  final correct = answer.isCorrect == true;

                  Color borderColor;
                  Color? bgColor;
                  IconData iconData;
                  Color iconColor;

                  if (selected && correct) {
                    borderColor = Color(0xff34C759);
                    bgColor = Color(0xff34C759); // Nền xanh đậm
                    iconData = Icons.check_circle;
                    iconColor = Colors.white;
                  } else if (selected && !correct) {
                    borderColor = AppColor.primary600;
                    bgColor = AppColor.primary600; // Nền đỏ đậm
                    iconData = Icons.cancel;
                    iconColor = Colors.white;
                  } else if (!selected && correct) {
                    borderColor = Color(0xff34C759);
                    bgColor = Color(0xff34C759);
                    iconData = Icons.check;
                    iconColor = Color(0xff34C759);
                  } else {
                    borderColor = Colors.grey.shade300;
                    bgColor = Colors.transparent;
                    iconData = isMultipleChoice
                        ? Icons.check_box_outline_blank
                        : Icons.radio_button_off;
                    iconColor = Colors.grey;
                  }

                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: borderColor),
                      borderRadius: BorderRadius.circular(16.r),
                      color: bgColor, // nền sẽ được cập nhật bên dưới
                    ),
                    child: Row(
                      children: [
                        // Nút chọn bên trái (checkbox hoặc radio)
                        Icon(
                          isMultipleChoice
                              ? (selected
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank)
                              : (selected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off),
                          color: selected
                              ? AppColor.hurricane50
                              : AppColor.hurricane800.withValues(alpha: 0.6),
                        ),
                        SizedBox(width: 12.w),

                        // Nội dung đáp án
                        Expanded(
                          child: _containsLatex(answer.answer ?? "")
                              ? TeXView(
                                  child:
                                      _createTexViewChild(answer.answer ?? ""),
                                  style: TeXViewStyle(
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    margin: TeXViewMargin.all(0),
                                    padding: TeXViewPadding.all(0),
                                  ),
                                )
                              : (answer.answer!.startsWith("/public")
                                  ? CustomNetworkAssetImage(
                                      imagePath: answer.answer!,
                                      width: 80.w,
                                    )
                                  : Text(
                                      answer.answer ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              fontSize: 15.sp,
                                              color: Colors.black),
                                    )),
                        ),
                        // Icon kết quả bên phải: ✅❌
                        if (selected)
                          Icon(
                            correct ? Icons.check_circle : Icons.cancel,
                            color: correct ? Colors.white : Colors.white,
                          ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ],
    );
  }
}
