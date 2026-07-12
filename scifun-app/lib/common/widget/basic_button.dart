import 'package:chiclet/chiclet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';

class BasicButton extends StatelessWidget {
  const BasicButton({
    super.key,
    this.text,
    this.child,
    required this.onPressed,
    this.padding,
    this.width,
    this.height,
    this.borderRadius,
    this.textColor = AppColor.hurricane50,
    this.backgroundColor,
    this.buttonColor,
    this.fontWeight,
    this.fontSize,
    this.alignment = Alignment.center,
    this.borderWidth,
    this.border = false,
    this.borderColor,
    this.buttonHeight = 8,
  }) : assert(
          (text != null && child == null) || (text == null && child != null),
          'Provide either text or child.',
        );

  final String? text;
  final Widget? child;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color textColor;
  final Color? backgroundColor;
  final Color? buttonColor;
  final FontWeight? fontWeight;
  final double? fontSize;
  final AlignmentGeometry alignment;
  final double? borderWidth;
  final bool border;
  final Color? borderColor;
  final double buttonHeight;

  @override
  Widget build(BuildContext context) {
    final Widget builtChild = child ??
        Text(
          text ?? '',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: fontSize,
              ),
        );
    final Widget alignedChild = Align(
      alignment: alignment,
      child: builtChild,
    );
    final double resolvedBorderRadius = _resolveBorderRadius();
    final Color resolvedBackgroundColor =
        backgroundColor ?? AppColor.skyblue400;
    final Color? resolvedButtonColor =
        buttonColor ?? (backgroundColor == null ? AppColor.skyblue500 : null);

    if (border) {
      return ChicletOutlinedAnimatedButton(
        onPressed: onPressed,
        width: width,
        height: height ?? 52.h,
        buttonHeight: buttonHeight,
        borderRadius: resolvedBorderRadius,
        borderWidth: borderWidth ?? 1.w,
        borderColor: borderColor ?? AppColor.border,
        foregroundColor: textColor,
        backgroundColor: backgroundColor ?? AppColor.hurricane50,
        buttonColor: buttonColor,
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: alignedChild,
      );
    }

    return ChicletAnimatedButton(
      onPressed: onPressed,
      width: width,
      height: height ?? 52.h,
      buttonHeight: buttonHeight,
      borderRadius: resolvedBorderRadius,
      foregroundColor: textColor,
      backgroundColor: resolvedBackgroundColor,
      buttonColor: resolvedButtonColor,
      padding:
          padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: alignedChild,
    );
  }

  double _resolveBorderRadius() {
    final double? radius = borderRadius?.resolve(TextDirection.ltr).topLeft.x;
    return radius ?? 15.r;
  }
}
