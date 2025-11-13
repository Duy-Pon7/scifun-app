import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thilop10_3004/core/utils/theme/app_color.dart';

class TopicItem extends StatelessWidget {
  const TopicItem({
    super.key,
    required this.title,
    required this.onTap,
  });
  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // height: 100,
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.5,
            color: Color(0xFF3C3C43).withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Icon(
                Icons.play_lesson_rounded,
                color: AppColor.primary600,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 12.h, bottom: 12.h, right: 12.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontSize: 17.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color(0xFF3C3C43).withValues(alpha: 0.3),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
