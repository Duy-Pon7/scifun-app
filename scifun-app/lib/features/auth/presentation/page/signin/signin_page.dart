import 'package:flutter/material.dart';
import 'package:thilop10_3004/features/auth/presentation/components/signin/signin_form.dart';
import 'package:thilop10_3004/features/auth/presentation/widget/background_auth.dart';
import 'package:thilop10_3004/features/auth/presentation/widget/logo_title_widget.dart';

class SigninPage extends StatelessWidget {
  const SigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: BackgroundAuth(
          child: SingleChildScrollView(
            child: LogoTitleWidget(
              title: "Đăng nhập",
              child: SigninForm(),
            ),
          ),
        ),
      ),
    );
  }
}
