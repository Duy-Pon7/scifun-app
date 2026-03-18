import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:sci_fun/common/widget/custom_network_asset_image.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';

class HeaderProfile extends StatelessWidget {
  static const String _avatarMascotLottiePath =
      'assets/lottie_json/cat_hide_and_seek.json';

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
        SizedBox(
          width: 118.w,
          height: 118.w,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                bottom: 120.h,
                left: 15.w,
                right: 0,
                child: IgnorePointer(
                  child: SizedBox(
                    width: 150.w,
                    height: 150.w,
                    child: Lottie.asset(
                      _avatarMascotLottiePath,
                      fit: BoxFit.contain,
                      repeat: true,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.r),
                  child: CustomNetworkAssetImage(
                    imagePath: imgUrl,
                    width: 100.w,
                    height: 100.w,
                  ),
                ),
              ),
            ],
          ),
        ),
        Text(
          name,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 24.sp,
                color: AppColor.skyblue500,
              ),
        ),
      ],
    );
  }
}
