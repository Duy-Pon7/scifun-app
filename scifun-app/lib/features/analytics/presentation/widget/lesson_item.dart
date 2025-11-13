import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thilop10_3004/core/utils/theme/app_color.dart';

class LessonItem extends StatelessWidget {
  final String title;
  final String completedTime;
  final String score;

  const LessonItem({
    super.key,
    required this.title,
    required this.completedTime,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dòng 1: Tên + điểm
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15.sp,
                  ),
                ),
              ),
              Text(
                score,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w400,
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          Text.rich(
            TextSpan(
              children: [
                completedTime != '---'
                    ? TextSpan(
                        text: 'Hoàn thành lúc: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15.sp,
                        ),
                      )
                    : TextSpan(
                        text: '',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15.sp,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                TextSpan(
                  text: completedTime == '---' ? 'Chưa làm' : completedTime,
                  style: TextStyle(
                    fontWeight: completedTime == '---'
                        ? FontWeight.w400
                        : FontWeight.w600,
                    fontSize: 15.sp,
                    color: completedTime == '---' ? Colors.grey : Colors.black,
                  ),
                ),
              ],
            ),
          ),

          const Divider(
            color: AppColor.hurricane100,
          ),
        ],
      ),
    );
  }
}
