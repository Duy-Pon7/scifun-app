import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';

class BasicTextButton extends StatelessWidget {
  const BasicTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor = AppColor.hurricane800,
    this.splashColor = AppColor.hurricane900,
    this.fontSize,
    this.fontWeight,
  });
  final String text;
  final VoidCallback onPressed;
  final Color textColor;
  final Color splashColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.w),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        splashFactory: InkRipple.splashFactory,
        overlayColor: WidgetStateColor.resolveWith(
          (states) => splashColor,
        ),
        minimumSize: Size(40.w, 30.h),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: textColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
      ),
    );
  }
}
