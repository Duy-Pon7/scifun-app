import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';

class CustomNetworkAssetImage extends StatelessWidget {
  const CustomNetworkAssetImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imagePath.startsWith("http")
          ? imagePath
          : "https://res.cloudinary.com/dglm2f7sr/image/upload/v1761373988/default_awmzq0.jpg",
      // imageUrl:
      //     'https://res.cloudinary.com/dglm2f7sr/image/upload/v1761373988/default_awmzq0.jpg',
      fit: fit,
      width: width,
      height: height,
      errorWidget: (context, url, error) => Center(
        child: Icon(
          Icons.error,
          size: 18.sp,
          color: AppColor.primary600,
        ),
      ),
    );
  }
}
