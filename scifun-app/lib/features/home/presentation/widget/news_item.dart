import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sci_fun/common/widget/custom_network_asset_image.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';

class NewsItem extends StatelessWidget {
  const NewsItem({
    super.key,
    required this.image,
    required this.title,
    required this.createdAt,
    required this.description,
    required this.onTap,
  });
  final String image;
  final String title;
  final DateTime createdAt;
  final String description;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            width: 0.3.w,
            color: Colors.black.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x59FF0300),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          spacing: 12.w,
          children: [
            Flexible(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.3,
                    color: Colors.black.withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: CustomNetworkAssetImage(
                    imagePath: image,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 8,
              child: Column(
                spacing: 6.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    DateFormat("dd/MM/yyyy").format(createdAt),
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppColor.hurricane800.withValues(alpha: 0.6),
                        ),
                  ),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppColor.hurricane800.withValues(alpha: 0.6),
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
