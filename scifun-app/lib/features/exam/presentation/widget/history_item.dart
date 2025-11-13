import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/home/domain/entity/quizz_result_entity.dart';

class HistoryItem extends StatelessWidget {
  final QuizzResultEntity item;

  const HistoryItem(this.item);

  @override
  Widget build(BuildContext context) {
    final time = item.createdAt != null
        ? TimeOfDay.fromDateTime(item.createdAt!.toLocal())
        : TimeOfDay(hour: 0, minute: 0);

    final date = item.createdAt != null
        ? '${item.createdAt!.day}/${item.createdAt!.month}/${item.createdAt!.year}'
        : 'N/A';
    final score = item.score?.toString() ?? 'pending';
    final status = item.status;
    return Column(
      children: [
        Divider(height: 1, color: AppColor.hurricane300),
        InkWell(
          onTap: () {}, // TODO: Navigate to detail
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text('${time.format(context)}',
                      style: TextStyle(
                          fontSize: 11.sp, fontWeight: FontWeight.w600)),
                ),
                Expanded(
                  flex: 3,
                  child: Text(date,
                      style: TextStyle(
                          fontSize: 11.sp, fontWeight: FontWeight.w400)),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        status == 'pending' ? 'Đợi chấm' : '$score điểm',
                        style: TextStyle(
                          color: status == 'pending' ? Colors.blue : Colors.red,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded, size: 24.sp),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
