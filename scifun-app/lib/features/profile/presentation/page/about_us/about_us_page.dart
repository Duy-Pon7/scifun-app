import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/utils/assets/app_image.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';

class AboutUsPage extends StatelessWidget {
  final String? plainValue;
  const AboutUsPage({super.key, required this.plainValue});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: BasicAppbar(
          title: "Về chúng tôi",
          showTitle: true,
          showBack: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      16.r), // bo góc, dùng .r nếu dùng ScreenUtil
                  child: Image.asset(
                    AppImage.aboutus,
                    width: double.infinity,
                    height: 260.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              Html(
                data: plainValue ?? "<p>Không có nội dung.</p>",
                style: {
                  "body": Style(
                    fontSize: FontSize(16.sp),
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                  "p": Style(margin: Margins.only(bottom: 12)),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
