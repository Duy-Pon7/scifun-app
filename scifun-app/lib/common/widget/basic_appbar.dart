import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';
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
    final titleWidget = showTitle
        ? Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 19.sp,
              fontFamily: 'Baloo2',
              fontWeight: FontWeight.w600,
            ),
          )
        : const SizedBox.shrink();

    return PreferredSize(
      preferredSize: preferredSize,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AppBar(
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(),
            centerTitle: true,
            toolbarHeight: preferredSize.height,
            titleSpacing: 0,
            title: Row(
              children: <Widget>[
                SizedBox(
                  width: 48,
                  child: Center(child: _buildLeft(context)),
                ),
                Expanded(
                  child: Center(child: titleWidget),
                ),
                SizedBox(
                  width: 48,
                  child: Center(child: _buildRight()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeft(BuildContext context) {
    if (leftIcon != null) {
      return leftIcon!;
    }

    if (!showBack) {
      return const SizedBox.shrink();
    }

    return IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(
        Symbols.arrow_back_ios_new_rounded,
        color: AppColor.skyblue600,
        size: 20,
      ),
      onPressed: onBackPress ?? () => Navigator.maybePop(context),
    );
  }

  Widget _buildRight() {
    return rightIcon ?? const SizedBox.shrink();
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
