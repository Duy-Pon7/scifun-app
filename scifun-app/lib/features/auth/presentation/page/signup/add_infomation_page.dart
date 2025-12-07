import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/features/auth/presentation/components/signup/add_infomation_form.dart';
import 'package:sci_fun/features/auth/presentation/widget/background_auth.dart';

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
        title: "Chi tiết lịch sử gói cước",
        showTitle: true,
        showBack: true,
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
