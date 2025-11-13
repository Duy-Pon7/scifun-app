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
        title: Text(
          "Cập nhật mật khẩu",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColor.primary600,
          ),
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            slidePage(SigninPage()),
            (route) => false,
          ),
        ),
      ),
      body: BackgroundAuth(
        child: SingleChildScrollView(
          child: RepassForm(email: email),
        ),
      ),
    );
  }
}
