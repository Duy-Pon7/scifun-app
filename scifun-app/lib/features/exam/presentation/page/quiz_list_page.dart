import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/enums/enum_quiz.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/exam/presentation/widget/quiz_item.dart';

class QuizListPage extends StatelessWidget {
  const QuizListPage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          title,
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
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: GridView.count(
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          crossAxisCount: 2,
          childAspectRatio: 1.6,
          children: List.generate(
            12,
            (index) => QuizItem(
              enumQuiz: index == 0
                  ? EnumQuiz.completed
                  : index % 2 == 0
                      ? EnumQuiz.notComplete
                      : EnumQuiz.waitting,
              title: "Đề ${index + 1}",
              totalQuestion: "30 Câu",
              duration: "90 phút",
              mark: index == 0 ? "9.5" : null,
            ),
          ),
        ),
      ),
    );
  }
}
