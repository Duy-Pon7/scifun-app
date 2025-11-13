import 'package:flutter/material.dart';
import 'package:thilop10_3004/core/utils/theme/app_color.dart';

class BasicAppbar extends StatelessWidget implements PreferredSizeWidget {
  const BasicAppbar({
    super.key,
    this.backgroundColor = Colors.white,
    this.leading,
    this.leadingWidth,
    this.title,
    this.actions,
    this.centerTitle,
    this.bottom,
    this.automaticallyImplyLeading = true, // thêm dòng này
  });

  final Color backgroundColor;
  final Widget? leading;
  final double? leadingWidth;
  final Widget? title;
  final List<Widget>? actions;
  final bool? centerTitle;
  final PreferredSizeWidget? bottom;
  final bool automaticallyImplyLeading; // thêm dòng này

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: backgroundColor,
      leading: leading,
      leadingWidth: leadingWidth,
      title: title,
      actions: actions,
      centerTitle: centerTitle,
      bottom: bottom,
      automaticallyImplyLeading:
          automaticallyImplyLeading, // truyền xuống AppBar
      shape: Border(
        bottom: BorderSide(
          color: AppColor.border,
          width: 0.5,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
