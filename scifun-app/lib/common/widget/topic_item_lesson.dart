import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopicItemLesson extends StatelessWidget {
  const TopicItemLesson({
    super.key,
    required this.title,
    required this.onTap,
    required this.isCompleted,
  });

  final String title;
  final void Function() onTap;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          color: isCompleted
              ? const Color(0xFFD1D1D6) // xám khi hoàn thành 0xFFFEE2E2
              : const Color(0xFFFEE2E2), // đỏ nhạt khi chưa hoàn thành
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 17.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
