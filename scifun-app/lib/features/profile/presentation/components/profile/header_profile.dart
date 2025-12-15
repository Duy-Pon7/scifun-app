import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/custom_network_asset_image.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';

class HeaderProfile extends StatelessWidget {
  const HeaderProfile({
    super.key,
    required this.imgUrl,
    required this.name,
    required this.remainingPackage,
  });
  final String imgUrl;
  final String name;
  final String remainingPackage;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 11.h,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50.r),
          child: CustomNetworkAssetImage(
            imagePath: imgUrl,
            width: 100.w,
            height: 100.w,
          ),
        ),
        Text(
          name,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 24.sp,
                color: AppColor.primary500,
              ),
        ),
      ],
    );
  }
}
