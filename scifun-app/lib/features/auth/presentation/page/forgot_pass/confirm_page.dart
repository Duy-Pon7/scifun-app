import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/auth/presentation/components/forgot_pass/confirm_content.dart';
import 'package:sci_fun/features/auth/presentation/widget/background_auth.dart';

class ConfirmPage extends StatelessWidget {
  final String email;
  final String phone;
  final String avatar;
  final String fullName;
  const ConfirmPage(
      {super.key,
      required this.email,
      required this.phone,
      required this.avatar,
      required this.fullName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: "Chi tiết lịch sử gói cước",
        showTitle: true,
        showBack: true,
      ),
      body: BackgroundAuth(
        child: SingleChildScrollView(
          child: ConfirmContent(
            email: email,
            phone: phone,
            avatar: avatar,
            fullName: fullName,
          ),
        ),
      ),
    );
  }
}
