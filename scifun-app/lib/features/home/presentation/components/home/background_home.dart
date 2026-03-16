import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/core/utils/assets/app_image.dart';
import 'package:sci_fun/core/utils/subject_theme_helper.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';

class BackgroundHome extends StatelessWidget {
  const BackgroundHome({
    super.key,
    required this.child,
    this.subjectName,
  });
  final Widget child;
  final String? subjectName;

  @override
  Widget build(BuildContext context) {
    final themeType = SubjectThemeHelper.resolveTheme(subjectName);
    final backgroundColor = switch (themeType) {
      SubjectThemeType.physics => AppColor.skyblue400,
      SubjectThemeType.chemistry => AppColor.red400,
      SubjectThemeType.biology => AppColor.yellowgreen400,
    };
    final waveAsset = switch (themeType) {
      SubjectThemeType.physics => AppImage.waveRightHomeBlue,
      SubjectThemeType.chemistry => AppImage.waveRightHomeRed,
      SubjectThemeType.biology => AppImage.waveRightHomeGreen,
    };

    return Stack(
      children: [
        Container(
          height: ScreenUtil().screenHeight * 0.4,
          decoration: BoxDecoration(
            color: backgroundColor,
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
            waveAsset,
          ),
        ),
        child,
      ],
    );
  }
}
