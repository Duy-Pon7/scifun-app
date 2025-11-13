import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thilop10_3004/core/utils/theme/app_color.dart';

class BasicButton extends StatelessWidget {
  const BasicButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.padding,
    this.width,
    this.borderRadius,
    this.textColor = Colors.white,
    this.backgroundColor = AppColor.primary500,
    this.fontWeight,
    this.fontSize,
    this.alignment = Alignment.center,
    this.borderWidth,
    this.border = false,
    this.borderColor,
  });
  final String text;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final BorderRadius? borderRadius;
  final Color textColor;
  final Color backgroundColor;
  final FontWeight? fontWeight;
  final double? fontSize;
  final AlignmentGeometry alignment;
  final double? borderWidth;
  final bool border;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: border
          ? BoxDecoration(
              borderRadius: borderRadius ?? BorderRadius.circular(15.r),
              border: Border.all(
                color: borderColor ?? AppColor.border,
                width: borderWidth ?? 0,
              ),
            )
          : null,
      child: CupertinoButton(
        borderRadius: borderRadius,
        color: backgroundColor,
        alignment: alignment,
        padding: padding,
        onPressed: () {
          onPressed();
        },
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: textColor,
                fontWeight: fontWeight,
                fontSize: fontSize,
              ),
        ),
      ),
    );
  }
}
