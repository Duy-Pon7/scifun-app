import 'package:flutter/material.dart';
import 'package:sci_fun/features/auth/presentation/components/signup/signup_form.dart';
import 'package:sci_fun/features/auth/presentation/widget/background_auth.dart';
import 'package:sci_fun/features/auth/presentation/widget/logo_title_widget.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: BackgroundAuth(
          child: SingleChildScrollView(
            child: LogoTitleWidget(
              title: "Đăng ký",
              child: SignupForm(),
            ),
          ),
        ),
      ),
    );
  }
}
