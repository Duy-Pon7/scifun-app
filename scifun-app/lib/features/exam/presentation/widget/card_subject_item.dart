import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thilop10_3004/common/widget/custom_network_asset_image.dart';

class CardSubjectItem extends StatelessWidget {
  const CardSubjectItem({
    super.key,
    required this.imagePath,
    required this.title,
    this.onTap,
  });

  final String imagePath;
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color(0x33000000),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(100.r),
            bottomLeft: Radius.circular(100.r),
            topRight: Radius.circular(16.r),
            bottomRight: Radius.circular(16.r),
          ),
        ),
        child: Row(
          children: [
            CustomNetworkAssetImage(
              imagePath: imagePath,
              width: 105.w,
              height: 105.w,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
