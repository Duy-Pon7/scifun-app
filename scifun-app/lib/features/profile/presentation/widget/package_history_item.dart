import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:thilop10_3004/core/enums/enum_package.dart';
import 'package:thilop10_3004/core/utils/theme/app_color.dart';

class PackageHistoryItem extends StatefulWidget {
  const PackageHistoryItem({
    super.key,
    required this.title,
    required this.onTap,
    required this.price,
    required this.date,
    required this.status,
  });
  final String title;
  final void Function()? onTap;
  final String price;
  final DateTime date;
  final PackageStatus status;

  @override
  State<PackageHistoryItem> createState() => _PackageHistoryItemState();
}

class _PackageHistoryItemState extends State<PackageHistoryItem> {
  @override
  Widget build(BuildContext context) {
    final formattedPrice = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ')
        .format(double.tryParse(widget.price) ?? 0);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColor.primary50,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 12.w,
                children: [
                  Flexible(
                    flex: 3,
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
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
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w600,
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
                height: 12.h,
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
                            fontSize: 17.sp,
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
                      DateFormat('dd/MM/yyyy').format(widget.date),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 17.sp,
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
                height: 12.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'Trạng thái: ',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                        children: [
                          TextSpan(
                            text: widget.status.description,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                  color: widget.status.color,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 28.sp,
                    height: 28.sp,
                    decoration: BoxDecoration(
                      color: AppColor.primary600
                          .withValues(alpha: 0.15), // Màu nền
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_forward,
                        size: 17.sp,
                        color: AppColor.primary600, // Màu icon
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
