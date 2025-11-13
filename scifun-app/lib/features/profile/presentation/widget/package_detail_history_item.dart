import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/core/enums/enum_package.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/profile/domain/entities/package_history_entity.dart';
import 'package:sci_fun/features/profile/presentation/page/package/payment_page.dart';

class PackageDetailHistoryItem extends StatefulWidget {
  const PackageDetailHistoryItem({
    super.key,
    required this.item,
    required this.title,
    required this.price,
    required this.date,
    required this.status,
  });
  final NotificationEntity? item;
  final String title;
  final String price;
  final DateTime date;
  final PackageStatus status;

  @override
  State<PackageDetailHistoryItem> createState() =>
      _PackageDetailHistoryItemState();
}

class _PackageDetailHistoryItemState extends State<PackageDetailHistoryItem> {
  @override
  Widget build(BuildContext context) {
    final formattedPrice = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ')
        .format(double.tryParse(widget.price) ?? 0);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: GestureDetector(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColor.primary200,
            borderRadius: BorderRadius.circular(12.r),
            // border: Border.all(
            //   width: 0.3.w,
            //   color: Colors.black.withValues(alpha: 0.3),
            // ),
            boxShadow: [
              BoxShadow(
                color: Color(0x40AA9C9C),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 6.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 12.w,
                children: [
                  Flexible(
                    flex: 3,
                    child: Text(
                      'Thời gian mua: ',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Text(
                      DateFormat('dd/MM/yyyy HH:mm')
                          .format(widget.date.toLocal()),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 6.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 12.w,
                children: [
                  Flexible(
                    flex: 3,
                    child: Text(
                      'Số tiền: ',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w400,
                          ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Column(
                      spacing: 6.h,
                      children: [
                        Text(
                          formattedPrice,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 6.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 12.w,
                children: [
                  Flexible(
                    flex: 3,
                    child: Text(
                      'Người thụ hưởng: ',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Column(
                      spacing: 6.h,
                      children: [
                        Text(
                          widget.item?.bank?.accountHolder ?? "Không rõ",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 6.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 12.w,
                children: [
                  Flexible(
                    flex: 3,
                    child: Text(
                      'Ngân hàng: ',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Column(
                      spacing: 6.h,
                      children: [
                        Text(
                          widget.item?.bank?.name ?? "Không rõ",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 6.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 12.w,
                children: [
                  Text(
                    'STK: ',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Column(
                    spacing: 6.h,
                    children: [
                      Text(
                        widget.item?.bank?.account ?? "Không rõ",
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 6.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 12.w,
                children: [
                  Text(
                    'Trạng thái: ',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Column(
                    spacing: 6.h,
                    children: [
                      Text(
                        widget.status.description,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                  color: widget.status.color,
                                ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              _buyBackButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buyBackButton() => BasicButton(
        text: "Mua lại gói",
        onPressed: () {
          Navigator.push(
            context,
            slidePage(
              PaymentPage(
                id: widget.item?.package?.id ?? 0,
                title: widget.item?.package?.name ?? "",
                description: widget.item?.package?.description[0] ?? "",
                price: widget.item?.package?.price ?? 0.0.toString(),
              ),
            ),
          );
        },
        width: double.infinity,
        fontSize: 18.sp,
        padding: EdgeInsets.symmetric(
          vertical: 14.h,
          horizontal: 20.w,
        ),
        backgroundColor: AppColor.primary600,
        borderRadius: BorderRadius.circular(40.r),
      );
}
