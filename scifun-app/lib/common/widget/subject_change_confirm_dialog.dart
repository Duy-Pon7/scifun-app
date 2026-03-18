import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';

Future<bool?> showSubjectChangeConfirmDialog({
  required BuildContext context,
  required String nextSubjectName,
}) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return SubjectChangeConfirmDialog(
        nextSubjectName: nextSubjectName,
      );
    },
  );
}

class SubjectChangeConfirmDialog extends StatelessWidget {
  const SubjectChangeConfirmDialog({
    super.key,
    required this.nextSubjectName,
  });

  final String nextSubjectName;

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
                'assets/lottie_json/cat_is_sleeping_and_rolling.json',
                repeat: true,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'B\u1ea1n c\u00f3 mu\u1ed1n \u0111\u1ed5i sang m\u00f4n "$nextSubjectName" kh\u00f4ng?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            SizedBox(height: 6.h),
            Text(
              'X\u00e1c nh\u1eadn \u0111\u1ec3 ti\u1ebfp t\u1ee5c.',
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
                    text: '\u1ede l\u1ea1i',
                    border: true,
                    backgroundColor: Colors.white,
                    borderColor: AppColor.skyblue300,
                    textColor: AppColor.skyblue700,
                    onPressed: () => Navigator.pop(context, false),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: BasicButton(
                    text: '\u0110\u1ed5i m\u00f4n',
                    textColor: Colors.white,
                    backgroundColor: AppColor.skyblue500,
                    buttonColor: AppColor.skyblue600,
                    onPressed: () => Navigator.pop(context, true),
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
