import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';

class PolicyPage extends StatelessWidget {
  final String? plainValue;
  const PolicyPage({super.key, required this.plainValue});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: BasicAppbar(
          title: "Chính sách",
          showTitle: true,
          showBack: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
