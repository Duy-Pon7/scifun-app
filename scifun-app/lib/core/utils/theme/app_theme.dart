import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';

class AppTheme {
  AppTheme._();

  static final TextTheme _appTextTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 57.sp, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(fontSize: 45.sp),
    displaySmall: TextStyle(fontSize: 36.sp),
    headlineLarge: TextStyle(fontSize: 32.sp),
    headlineMedium: TextStyle(fontSize: 28.sp),
    headlineSmall: TextStyle(fontSize: 24.sp),
    titleLarge: TextStyle(fontSize: 22.sp),
    titleMedium: TextStyle(fontSize: 16.sp),
    titleSmall: TextStyle(fontSize: 14.sp),
    bodyLarge: TextStyle(fontSize: 16.sp),
    bodyMedium: TextStyle(fontSize: 14.sp),
    bodySmall: TextStyle(fontSize: 12.sp),
    labelLarge: TextStyle(fontSize: 14.sp),
    labelMedium: TextStyle(fontSize: 12.sp),
    labelSmall: TextStyle(fontSize: 10.sp),
  ).apply(
    bodyColor: Colors.black,
  );

  static OutlineInputBorder _inputBorder({Color? borderColor}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(
        color: borderColor ?? AppColor.border,
        width: 1.w,
      ),
      gapPadding: 0,
    );
  }

  static final InputDecorationTheme _inputDecorationTheme =
      InputDecorationTheme(
    fillColor: Colors.white,
    filled: true,
    isDense: true,
    enabledBorder: _inputBorder(),
    focusedBorder: _inputBorder(),
    errorBorder: _inputBorder(
      borderColor: Colors.red,
    ),
    focusedErrorBorder: _inputBorder(
      borderColor: Colors.red,
    ),
    focusColor: Colors.black,
    disabledBorder: _inputBorder(),
    hintStyle: TextStyle(
      fontSize: 17.sp,
      fontWeight: FontWeight.w400,
      color: AppColor.hintText,
    ),
    suffixIconColor: AppColor.inputIcon,
    errorStyle: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: Colors.red,
    ),
  );

  static final TextSelectionThemeData _textSelectionThemeData =
      TextSelectionThemeData(
    cursorColor: AppColor.primary500,
    selectionColor: AppColor.primary200,
    selectionHandleColor: AppColor.primary500,
  );

  static final ThemeData theme = ThemeData(
    fontFamily: 'Inter',
    scaffoldBackgroundColor: Colors.white,
    textTheme: _appTextTheme,
    primaryColor: AppColor.primary400,
    textSelectionTheme: _textSelectionThemeData,
    inputDecorationTheme: _inputDecorationTheme,
    colorScheme: ColorScheme.light(
      primary: AppColor.primary500,
      onPrimary: AppColor.primary400,
      onSurface: Colors.black,
    ),
  );
}
