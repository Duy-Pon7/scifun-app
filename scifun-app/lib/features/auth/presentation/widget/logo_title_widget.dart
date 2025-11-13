import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thilop10_3004/core/utils/assets/app_image.dart';
import 'package:thilop10_3004/core/utils/theme/app_color.dart';

class LogoTitleWidget extends StatelessWidget {
  const LogoTitleWidget({super.key, required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 50.h),
      width: double.infinity,
      child: Column(
        spacing: 32.h,
        children: [
          SizedBox(
            width: ScreenUtil().screenWidth * 0.31,
            height: ScreenUtil().screenWidth * 0.31,
            child: ClipOval(
              child: Image.asset(AppImage.logo),
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: AppColor.primary500,
                  fontWeight: FontWeight.w700,
                ),
          ),
          child,
        ],
      ),
    );
  }
}
