import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';

class QuestionGrid extends StatelessWidget {
  final int totalQuestions;
  final int currentIndex;
  final List<int> answeredQuestionIndexes;
  final Function(int) onQuestionTap;

  const QuestionGrid({
    super.key,
    required this.totalQuestions,
    required this.currentIndex,
    required this.answeredQuestionIndexes,
    required this.onQuestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalQuestions,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final isCurrent = index == currentIndex;
        final isAnswered = answeredQuestionIndexes.contains(index);

        Color bgColor;
        Color textColor;
        BoxBorder? border;

        if (isCurrent) {
          bgColor = AppColor.primary600;
          textColor = Colors.white;
        } else if (isAnswered) {
          bgColor = AppColor.hurricane800.withValues(alpha: 0.3);
          textColor = Colors.black54;
        } else {
          bgColor = Colors.white;
          textColor = Colors.black;
          border = Border.all(
              color: AppColor.hurricane800.withValues(alpha: 0.3), width: 1);
        }

        return GestureDetector(
          onTap: () => onQuestionTap(index),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bgColor,
              border: border,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              "${index + 1}",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: textColor,
                fontSize: 28.sp,
              ),
            ),
          ),
        );
      },
    );
  }
}
