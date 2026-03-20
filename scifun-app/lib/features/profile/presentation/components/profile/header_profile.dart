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
    required this.isGuest,
  });
  final String imgUrl;
  final String name;
  final String remainingPackage;
  final bool isGuest;

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
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          alignment: WrapAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColor.skyblue50,
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Text(
                'Con $remainingPackage',
                style: TextStyle(
                  color: AppColor.skyblue700,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                ),
              ),
            ),
            if (isGuest)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2CC),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  'Tai khoan khach',
                  style: TextStyle(
                    color: const Color(0xFF8A6700),
                    fontWeight: FontWeight.w700,
                    fontSize: 12.sp,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
