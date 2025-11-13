import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/core/utils/assets/app_image.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';

class BackgroundHome extends StatelessWidget {
  const BackgroundHome({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: ScreenUtil().screenHeight * 0.4,
          decoration: BoxDecoration(
            color: AppColor.primary400,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(ScreenUtil().screenHeight * 0.09),
              bottomRight: Radius.circular(ScreenUtil().screenHeight * 0.09),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Image.asset(
            AppImage.waveRightHome,
          ),
        ),
        child,
      ],
    );
  }
}
