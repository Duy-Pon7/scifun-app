import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnalyticItem extends StatelessWidget {
  const AnalyticItem({
    super.key,
    required this.image,
    required this.title,
    required this.onTap,
  });
  final String image;
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          // border: Border.all(
          //   width: 0.3.w,
          //   color: Colors.black.withValues(alpha: 0.3),
          // ),
          boxShadow: [
            BoxShadow(
              color: Color(0x40AA9C9C),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 12.w,
          children: [
            Flexible(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  // border: Border.all(
                  //   width: 0.3,
                  //   color: Colors.black.withValues(alpha: 0.3),
                  // ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Image.asset(
                    image,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 4,
              child: Column(
                spacing: 6.h,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Column(
                spacing: 6.h,
                children: [
                  Icon(
                    Icons.chevron_right,
                    size: 24.sp,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
