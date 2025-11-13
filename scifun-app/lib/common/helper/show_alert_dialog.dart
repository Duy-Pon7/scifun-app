import 'package:flutter/cupertino.dart';
import 'package:thilop10_3004/core/utils/theme/app_color.dart';

void showAlertDialog(
  BuildContext context,
  VoidCallback onPressed,
  VoidCallback? onCancel,
  String title,
  String content,
  String titleButton,
  String? cancelText,
) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(
          content,
        ),
        actions: <CupertinoDialogAction>[
          if (onCancel != null)
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                onCancel();
                Navigator.of(context).pop();
              },
              child: Text(
                cancelText ?? "Hủy",
                style: TextStyle(
                  color: AppColor.primary500,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(context).pop();
              onPressed();
            },
            child: Text(
              titleButton,
              style: TextStyle(
                color: AppColor.primary500,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    },
  );
}
