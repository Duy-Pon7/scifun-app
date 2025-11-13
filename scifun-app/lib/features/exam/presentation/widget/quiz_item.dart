import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/core/enums/enum_quiz.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/exam/presentation/page/quiz_detail_page.dart';

class QuizItem extends StatelessWidget {
  const QuizItem({
    super.key,
    required this.enumQuiz,
    required this.title,
    this.mark,
    required this.totalQuestion,
    required this.duration,
  });
  final EnumQuiz enumQuiz;
  final String title;
  final String? mark;
  final String totalQuestion;
  final String duration;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, slidePage(QuizDetailPage()));
      },
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(50, 50, 93, 0.25),
              blurRadius: 12,
              spreadRadius: -2,
              offset: Offset(
                0,
                6,
              ),
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.3),
              blurRadius: 7,
              spreadRadius: -3,
              offset: Offset(
                0,
                3,
              ),
            ),
          ],
        ),
        child: Column(
          spacing: 12.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: enumQuiz == EnumQuiz.completed
                          ? AppColor.completed
                          : enumQuiz == EnumQuiz.notComplete
                              ? AppColor.notComplete
                              : AppColor.waitting,
                    ),
                    child: Text(
                      enumQuiz == EnumQuiz.completed
                          ? EnumQuiz.completed.description
                          : enumQuiz == EnumQuiz.notComplete
                              ? EnumQuiz.notComplete.description
                              : EnumQuiz.waitting.description,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 11.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Spacer(),
                if (enumQuiz == EnumQuiz.completed)
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: Color(0xFFFFC1C0),
                    ),
                    child: Text(
                      mark!,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  )
              ],
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 6.w,
              children: [
                Expanded(
                  child: Row(
                    spacing: 6.w,
                    children: [
                      Icon(
                        Icons.help,
                        color: AppColor.hurricane800.withValues(alpha: 0.6),
                        size: 15,
                      ),
                      Expanded(
                        child: Text(
                          totalQuestion,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: AppColor.hurricane800
                                        .withValues(alpha: 0.6),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    spacing: 6.w,
                    children: [
                      Icon(
                        Icons.alarm,
                        color: AppColor.hurricane800.withValues(alpha: 0.6),
                        size: 15,
                      ),
                      Expanded(
                        child: Text(
                          duration,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: AppColor.hurricane800
                                        .withValues(alpha: 0.6),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
