import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';

class TextWithCopyIcon extends StatelessWidget {
  final String label; // Ví dụ: "Sđt:"
  final String value; // Ví dụ: "0912 345 565" (hiển thị)
  final String?
      copyValue; // Nội dung thực sự được sao chép (có thể khác với value)
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final Color dividerColor; // Cho phép tùy chỉnh màu divider

  const TextWithCopyIcon({
    super.key,
    required this.label,
    required this.value,
    this.copyValue,
    this.labelStyle,
    this.valueStyle,
    this.dividerColor = Colors.grey, // mặc định màu xám
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  style:
                      DefaultTextStyle.of(context).style.copyWith(fontSize: 16),
                  children: [
                    TextSpan(text: '$label ', style: labelStyle),
                    TextSpan(text: value, style: valueStyle),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColor.primary600, // màu nền khung
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.copy,
                  size: 20,
                  color: AppColor.hurricane50, // màu icon
                ),
              ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: copyValue ?? value));
                EasyLoading.showToast(
                    toastPosition: EasyLoadingToastPosition.bottom,
                    'Đã sao chép vào clipboard');
              },
            ),
          ],
        ),
        Divider(height: 1, color: dividerColor),
      ],
    );
  }
}
