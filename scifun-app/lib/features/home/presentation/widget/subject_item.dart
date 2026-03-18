import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/custom_network_asset_image.dart';

class SubjectItem extends StatelessWidget {
  const SubjectItem({
    super.key,
    required this.subjectName,
    required this.imagePath,
    required this.onTap,
    this.isSelected = false,
    this.selectedBackgroundColor,
    this.selectedBorderColor,
    this.selectedTextColor,
  });

  final String subjectName;
  final String imagePath;
  final VoidCallback onTap;
  final bool isSelected;
  final Color? selectedBackgroundColor;
  final Color? selectedBorderColor;
  final Color? selectedTextColor;

  @override
  Widget build(BuildContext context) {
    final cardColor =
        isSelected ? (selectedBackgroundColor ?? Colors.white) : Colors.white;
    final borderColor = isSelected
        ? (selectedBorderColor ?? Colors.transparent)
        : Colors.transparent;
    final textColor =
        isSelected ? (selectedTextColor ?? Colors.black87) : Colors.black;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            margin: EdgeInsets.only(top: 34.h),
            width: 125.w,
            height: 160.h,
            padding: EdgeInsets.fromLTRB(10.w, 46.h, 10.w, 12.h),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: isSelected
                    ? borderColor.withValues(alpha: 0.35)
                    : Colors.transparent,
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? borderColor.withValues(alpha: 0.20)
                      : Colors.grey.withValues(alpha: 0.1),
                  spreadRadius: 0.5,
                  blurRadius: 6,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                subjectName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: 82.w,
            height: 82.w,
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color:
                  isSelected ? cardColor.withValues(alpha: 0.65) : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? borderColor.withValues(alpha: 0.30)
                    : Colors.white,
                width: isSelected ? 1.2 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.r),
              child: CustomNetworkAssetImage(
                imagePath: imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
