import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';

class SubjectItem extends StatelessWidget {
  final String title;
  final DateTime completedTime;
  final String score;

  const SubjectItem({
    super.key,
    required this.title,
    required this.completedTime,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    print(score);
    final com = DateFormat("dd/MM/yyyy").format(completedTime);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Bên trái: Tiêu đề + ngày
              Expanded(
                child: Text(
                  '$title - đánh giá: $com',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.black,
                  ),
                ),
              ),

              // Bên phải: điểm
              score.isNotEmpty
                  ? Text(
                      "$score điểm",
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.red,
                      ),
                    )
                  : SizedBox(width: 40.w), // chừa chỗ trống
            ],
          ),
          SizedBox(height: 6.h),
          Divider(
            color: AppColor.hurricane100,
            thickness: 0.5,
            height: 0.5,
          ),
        ],
      ),
    );
  }
}
