import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';

class LessonItem extends StatelessWidget {
  final String title;
  final String completedTime;
  final String score;
  final double? bestScore;
  final int attempts;

  const LessonItem({
    super.key,
    required this.title,
    required this.completedTime,
    required this.score,
    this.bestScore,
    this.attempts = 0,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasAttempted = attempts > 0;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dòng 1: Tên + điểm gần nhất
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp,
                  ),
                ),
              ),
              Text(
                score,
                style: TextStyle(
                  color: hasAttempted ? Colors.red : Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          // Dòng 2: Điểm cao nhất
          if (hasAttempted && bestScore != null)
            Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Điểm cao nhất: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                        color: Colors.black54,
                      ),
                    ),
                    TextSpan(
                      text: '${bestScore!.toStringAsFixed(2)} điểm',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        color: AppColor.primary600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Dòng 3: Số lần làm
          Padding(
            padding: EdgeInsets.only(bottom: 4.h),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Số lần làm: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      color: Colors.black54,
                    ),
                  ),
                  TextSpan(
                    text: '$attempts lần',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: hasAttempted ? Colors.black : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Dòng 4: Thời gian
          Text.rich(
            TextSpan(
              children: [
                completedTime != '---'
                    ? TextSpan(
                        text: 'Lần làm cuối: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          color: Colors.black54,
                        ),
                      )
                    : const TextSpan(),
                TextSpan(
                  text: completedTime == '---' ? 'Chưa làm' : completedTime,
                  style: TextStyle(
                    fontWeight: completedTime == '---'
                        ? FontWeight.w400
                        : FontWeight.w600,
                    fontSize: 14.sp,
                    color: completedTime == '---' ? Colors.grey : Colors.black,
                    fontStyle: completedTime == '---'
                        ? FontStyle.italic
                        : FontStyle.normal,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 8.h),

          const Divider(
            color: AppColor.hurricane100,
          ),
        ],
      ),
    );
  }
}
