import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
          : "http://3004.mevivu.net/$imagePath",
      fit: fit,
      width: width,
      height: height,
      errorWidget: (context, url, error) => Center(
        child: Icon(
          Icons.error,
          size: 18,
          color: Colors.red,
        ),
      ),
    );
  }
}
