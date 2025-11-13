import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:thilop10_3004/common/helper/transition_page.dart';
import 'package:thilop10_3004/common/widget/basic_button.dart';
import 'package:thilop10_3004/core/utils/assets/app_image.dart';
import 'package:thilop10_3004/core/utils/theme/app_color.dart';
import 'package:thilop10_3004/features/profile/presentation/page/package/payment_page.dart';

class PackageItem extends StatelessWidget {
  const PackageItem({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.maxLines,
    this.onTap,
  });

  final int id;
  final String title;
  final String description;
  final String price;
  final int? maxLines;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(16.w),
        padding: EdgeInsets.all(16.w),
        // height: ScreenUtil().screenHeight * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Color(0x1AFF0300),
              blurRadius: 10.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 24.h,
          children: [
            Column(
              spacing: 12.h,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24.r),
                  child: Image(
                    width: 90.w,
                    image: AssetImage(
                      AppImage.logo,
                    ),
                  ),
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 17.sp,
                      ),
                ),
                RichText(
                  text: TextSpan(
                    text: NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ')
                        .format(double.parse(price)),
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColor.primary500),
                    children: [
                      TextSpan(
                        text: "/năm",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color:
                                  AppColor.hurricane800.withValues(alpha: 0.6),
                            ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.titleSmall,
                  overflow: maxLines != null ? TextOverflow.ellipsis : null,
                  maxLines: maxLines,
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            BasicButton(
              text: "Gia hạn",
              onPressed: () => Navigator.push(
                context,
                slidePage(
                  PaymentPage(
                    id: id,
                    title: title,
                    description: description,
                    price: price,
                  ),
                ),
              ),
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 14.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
