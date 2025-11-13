import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';

class NotiOfDay extends StatelessWidget {
  const NotiOfDay({super.key, required this.date, required this.notiItems});
  final DateTime date;
  final List<Widget> notiItems;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat("dd/MM/yyyy").format(date),
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColor.hurricane800.withValues(alpha: 0.6),
              ),
        ),
        notiItems.isNotEmpty
            ? Column(
                spacing: 16.h,
                children: notiItems,
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
