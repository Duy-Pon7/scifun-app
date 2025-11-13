import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thilop10_3004/common/widget/basic_appbar.dart';
import 'package:thilop10_3004/core/utils/theme/app_color.dart';
import 'package:thilop10_3004/features/auth/presentation/components/signup/add_infomation_form.dart';
import 'package:thilop10_3004/features/auth/presentation/widget/background_auth.dart';

class AddInfomationPage extends StatelessWidget {
  final String phone;
  final String password;
  final String confirmPassword;
  final String email;

  const AddInfomationPage(
      {super.key,
      required this.phone,
      required this.email,
      required this.password,
      required this.confirmPassword});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          "Thông tin tài khoản",
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
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: AddInfomationForm(
              phone: phone,
              email: email,
              password: password,
              confirmPassword: confirmPassword),
        ),
      ),
    );
  }
}
