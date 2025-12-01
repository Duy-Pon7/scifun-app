import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/auth/presentation/components/forgot_pass/forgot_pass_form.dart';
import 'package:sci_fun/features/auth/presentation/widget/background_auth.dart';
import 'package:sci_fun/features/auth/presentation/widget/logo_title_widget.dart';

class ForgotPassPage extends StatelessWidget {
  const ForgotPassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: BasicAppbar(
          title: "Chi tiết lịch sử gói cước",
          showTitle: true,
          showBack: true,
        ),
        body: BackgroundAuth(
          child: SingleChildScrollView(
            child: LogoTitleWidget(
              title: "Nhận mã khôi phục tài khoản",
              child: ForgotPassForm(),
            ),
          ),
        ),
      ),
    );
  }
}
