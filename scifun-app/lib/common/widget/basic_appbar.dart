import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';

class BasicAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showTitle;
  final bool showBack;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final VoidCallback? onBackPress;

  const BasicAppbar({
    super.key,
    required this.title,
    this.showTitle = true,
    this.showBack = true,
    this.leftIcon,
    this.rightIcon,
    this.onBackPress,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      // leadingWidth: 48.w,

      // leading diff
      leading: leftIcon ??
          (showBack
              ? IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: AppColor.primary600),
                  onPressed: onBackPress ?? () => Navigator.pop(context),
                )
              : null),
      title: showTitle
          ? Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 17.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
      centerTitle: true,
      actions: [
        if (rightIcon != null)
          Padding(
            padding: EdgeInsets.only(right: 12.w), // hoặc 16.w
            child: rightIcon!,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
