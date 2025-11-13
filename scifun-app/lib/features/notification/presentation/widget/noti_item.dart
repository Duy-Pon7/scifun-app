import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:sci_fun/common/cubit/paginator_cubit.dart';
import 'package:sci_fun/common/helper/show_alert_dialog.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/core/utils/assets/app_image.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/notification/data/models/noti_model.dart';
import 'package:sci_fun/features/notification/presentation/cubit/noti_cubit.dart';
import 'package:sci_fun/features/notification/presentation/page/noti_detail_page.dart';

class NotiItem extends StatelessWidget {
  const NotiItem({
    super.key,
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.isRead,
  });
  final int? id;
  final String title;
  final String content;
  final DateTime date;
  final int? isRead;

  @override
  Widget build(BuildContext context) {
    late final notiCubit = context.read<NotiCubit>();

    return GestureDetector(
      onTap: () async {
        await notiCubit.markNotificationAsRead(newsId: id ?? 0);
        await notiCubit.fetchNotiDetail(newsId: id ?? 0);

        // Đợi đến khi trang chi tiết đóng lại (pop)
        await Navigator.push(
          context,
          slidePage(
            BlocProvider.value(
              value: notiCubit,
              child: NotiDetailPage(),
            ),
          ),
        );

        // Load lại danh sách khi quay lại
        await context.read<PaginatorCubit<NotiModel, dynamic>>().refreshData();
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor.primary100,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Slidable(
          key: ValueKey(id),
          endActionPane: ActionPane(
            motion: ScrollMotion(),
            extentRatio: 0.2,
            children: [
              CustomSlidableAction(
                flex: 1,
                onPressed: (_) {
                  showAlertDialog(
                    context,
                    () async {
                      await context
                          .read<NotiCubit>()
                          .deleteNoti(newsId: id ?? 0);
                      await context
                          .read<PaginatorCubit<NotiModel, dynamic>>()
                          .refreshData();
                    },
                    () {},
                    "Xác nhận xóa",
                    "Bạn chắc chắn muốn xóa?",
                    "Xóa",
                    null,
                  );
                },
                backgroundColor: AppColor.primary100,
                padding: EdgeInsets.zero,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16.r),
                  bottomRight: Radius.circular(16.r),
                ),
                child: SizedBox(
                  width: 60.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Xóa",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColor.primary800,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isRead == 1 ? AppColor.primary50 : Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.3),
                width: 0.5.w,
              ),
            ),
            child: Column(
              spacing: 12.h,
              children: [
                Row(
                  spacing: 16.w,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: AppColor.primary200,
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Image.asset(
                        AppImage.noti,
                        width: 51.w,
                        height: 38.h,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                            maxLines: 1,
                          ),
                          Text(
                            content,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    if (isRead == 1)
                      Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            width: 11.w,
                            height: 11.w,
                            decoration: BoxDecoration(
                              color: AppColor.primary600,
                              borderRadius: BorderRadius.circular(5.5.r),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('HH:mm - dd/MM/yyyy').format(date),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColor.hurricane800.withValues(alpha: 0.6),
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
