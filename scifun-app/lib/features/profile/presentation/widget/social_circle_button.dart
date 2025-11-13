import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialCircleButton extends StatelessWidget {
  final String imageUrl;
  final String linkUrl;
  final Color backgroundColor;

  const SocialCircleButton({
    super.key,
    required this.imageUrl,
    required this.linkUrl,
    this.backgroundColor = AppColor.primary400,
  });

  Future<void> _launchUrl() async {
    final uri = Uri.parse(linkUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $linkUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launchUrl,
      child: Container(
        width: 48.w,
        height: 48.h,
        decoration: BoxDecoration(
          color: AppColor.primary50,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Image.asset(
            imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
