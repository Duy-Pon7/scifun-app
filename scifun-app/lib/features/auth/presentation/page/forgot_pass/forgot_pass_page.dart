import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thilop10_3004/common/widget/basic_appbar.dart';
import 'package:thilop10_3004/core/utils/theme/app_color.dart';
import 'package:thilop10_3004/features/auth/presentation/components/forgot_pass/forgot_pass_form.dart';
import 'package:thilop10_3004/features/auth/presentation/widget/background_auth.dart';
import 'package:thilop10_3004/features/auth/presentation/widget/logo_title_widget.dart';

class ForgotPassPage extends StatelessWidget {
  const ForgotPassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: BasicAppbar(
          title: Text(
            "Quên mật khẩu",
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
            onPressed: () => Navigator.of(context).pop(),
          ),
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
