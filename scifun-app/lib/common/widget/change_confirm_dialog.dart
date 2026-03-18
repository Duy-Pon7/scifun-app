import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';

Future<bool?> showChangeConfirmDialog({
  required BuildContext context,
  required String titleText,
  required String messageText,
  String cancelButtonText = '\u1ede l\u1ea1i',
  String confirmButtonText = '\u0110\u1ed3ng \u00fd',
  VoidCallback? onCancelTap,
  VoidCallback? onConfirmTap,
  String lottieAssetPath =
      'assets/lottie_json/cat_is_sleeping_and_rolling.json',
}) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return ChangeConfirmDialog(
        titleText: titleText,
        messageText: messageText,
        cancelButtonText: cancelButtonText,
        confirmButtonText: confirmButtonText,
        onCancelTap: onCancelTap,
        onConfirmTap: onConfirmTap,
        lottieAssetPath: lottieAssetPath,
      );
    },
  );
}

Future<bool?> showSubjectChangeConfirmDialog({
  required BuildContext context,
  required String nextSubjectName,
  String? titleText,
  String? messageText,
  String cancelButtonText = '\u1ede l\u1ea1i',
  String confirmButtonText = '\u0110\u1ed5i m\u00f4n',
  VoidCallback? onCancelTap,
  VoidCallback? onConfirmTap,
}) {
  return showChangeConfirmDialog(
    context: context,
    titleText: titleText ??
        'B\u1ea1n c\u00f3 mu\u1ed1n \u0111\u1ed5i sang m\u00f4n "$nextSubjectName" kh\u00f4ng?',
    messageText:
        messageText ?? 'X\u00e1c nh\u1eadn \u0111\u1ec3 ti\u1ebfp t\u1ee5c.',
    cancelButtonText: cancelButtonText,
    confirmButtonText: confirmButtonText,
    onCancelTap: onCancelTap,
    onConfirmTap: onConfirmTap,
  );
}

Future<bool?> showLogoutConfirmDialog({
  required BuildContext context,
  String titleText = 'X\u00e1c nh\u1eadn \u0111\u0103ng xu\u1ea5t',
  String messageText =
      'B\u1ea1n c\u00f3 ch\u1eafc ch\u1eafn mu\u1ed1n \u0111\u0103ng xu\u1ea5t kh\u00f4ng?',
  String cancelButtonText = 'H\u1ee7y',
  String confirmButtonText = '\u0110\u0103ng xu\u1ea5t',
  VoidCallback? onCancelTap,
  VoidCallback? onConfirmTap,
}) {
  return showChangeConfirmDialog(
    context: context,
    titleText: titleText,
    messageText: messageText,
    cancelButtonText: cancelButtonText,
    confirmButtonText: confirmButtonText,
    onCancelTap: onCancelTap,
    onConfirmTap: onConfirmTap,
  );
}

class ChangeConfirmDialog extends StatelessWidget {
  const ChangeConfirmDialog({
    super.key,
    required this.titleText,
    required this.messageText,
    this.cancelButtonText = '\u1ede l\u1ea1i',
    this.confirmButtonText = '\u0110\u1ed3ng \u00fd',
    this.onCancelTap,
    this.onConfirmTap,
    this.lottieAssetPath =
        'assets/lottie_json/cat_is_sleeping_and_rolling.json',
  });

  final String titleText;
  final String messageText;
  final String cancelButtonText;
  final String confirmButtonText;
  final VoidCallback? onCancelTap;
  final VoidCallback? onConfirmTap;
  final String lottieAssetPath;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 14.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 120.w,
              height: 120.w,
              child: Lottie.asset(
                lottieAssetPath,
                repeat: true,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              titleText,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            SizedBox(height: 6.h),
            Text(
              messageText,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                  ),
            ),
            SizedBox(height: 14.h),
            Row(
              children: [
                Expanded(
                  child: BasicButton(
                    text: cancelButtonText,
                    border: true,
                    backgroundColor: Colors.white,
                    borderColor: AppColor.skyblue300,
                    textColor: AppColor.skyblue700,
                    onPressed:
                        onCancelTap ?? () => Navigator.pop(context, false),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: BasicButton(
                    text: confirmButtonText,
                    textColor: Colors.white,
                    backgroundColor: AppColor.skyblue500,
                    buttonColor: AppColor.skyblue600,
                    onPressed:
                        onConfirmTap ?? () => Navigator.pop(context, true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
