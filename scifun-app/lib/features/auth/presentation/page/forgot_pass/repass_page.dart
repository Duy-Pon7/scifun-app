import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/auth/presentation/components/forgot_pass/repass_form.dart';
import 'package:sci_fun/features/auth/presentation/page/signin/signin_page.dart';
import 'package:sci_fun/features/auth/presentation/widget/background_auth.dart';

class RepassPage extends StatelessWidget {
  final String email;
  const RepassPage({super.key, required this.email});

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
          child: RepassForm(email: email),
        ),
      ),
    );
  }
}
