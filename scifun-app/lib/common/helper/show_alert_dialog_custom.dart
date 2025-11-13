import 'package:flutter/cupertino.dart';
import 'package:thilop10_3004/core/utils/theme/app_color.dart';

void showCustomAlertDialog(
  BuildContext context,
  String title,
  String content,
  String buttonText,
) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: CupertinoColors.black,
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: CupertinoColors.black,
            ),
            textAlign: TextAlign.left, // căn trái
          ),
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              buttonText,
              style: TextStyle(
                color: AppColor.primary500, // màu đỏ của bạn
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}
