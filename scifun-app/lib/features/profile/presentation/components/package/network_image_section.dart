import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/custom_network_asset_image.dart'; // import widget bạn vừa tạo
import 'package:sci_fun/core/utils/theme/app_color.dart';

class NetworkImageSection extends StatelessWidget {
  final String? imageUrl; // URL hình ảnh

  const NetworkImageSection({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenUtil().screenWidth * 0.35,
      height: ScreenUtil().screenWidth * 0.6,
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? CustomNetworkAssetImage(
              imagePath: imageUrl!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            )
          : DottedBorder(
              options: RoundedRectDottedBorderOptions(
                radius: Radius.circular(16.r),
                color: AppColor.primary500,
                strokeWidth: 1.w,
              ),
              child: Center(
                child: Text(
                  "Chưa có ảnh",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 17.sp,
                      ),
                ),
              ),
            ),
    );
  }
}
