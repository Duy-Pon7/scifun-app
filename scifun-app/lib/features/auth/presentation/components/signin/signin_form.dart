import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thilop10_3004/common/cubit/obscure_text_cubit.dart';
import 'package:thilop10_3004/common/helper/show_alert_dialog_custom.dart';
import 'package:thilop10_3004/common/helper/text_formatter.dart';
import 'package:thilop10_3004/common/helper/transition_page.dart';
import 'package:thilop10_3004/common/widget/basic_button.dart';
import 'package:thilop10_3004/common/widget/basic_input_field.dart';
import 'package:thilop10_3004/common/widget/basic_text_button.dart';
import 'package:thilop10_3004/core/di/injection.dart';
import 'package:thilop10_3004/core/utils/theme/app_color.dart';
import 'package:thilop10_3004/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:thilop10_3004/features/auth/presentation/page/forgot_pass/forgot_pass_page.dart';
import 'package:thilop10_3004/features/auth/presentation/page/signup/signup_page.dart';
import 'package:thilop10_3004/features/home/presentation/page/dashboard_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:thilop10_3004/features/profile/presentation/page/package/package_page.dart';

class SigninForm extends StatefulWidget {
  const SigninForm({super.key});

  @override
  State<SigninForm> createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneCon = TextEditingController();
  final TextEditingController _passCon = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _phoneCon.dispose();
    _passCon.dispose();
  }

  void _listener(BuildContext context, AuthState state) {
    print("statesignin $state");
    if (state is AuthLoading) {
      EasyLoading.show(
        status: 'Đang tải',
        maskType: EasyLoadingMaskType.black,
      );
    } else if (state is AuthFailure) {
      EasyLoading.dismiss();
      // EasyLoading.showToast(state.message,
      //     toastPosition: EasyLoadingToastPosition.bottom);
      showCustomAlertDialog(
        context,
        "Đăng nhập thất bại",
        state.message,
        "Đồng ý",
      );
    } else if (state is AuthUserLoginSuccess) {
      EasyLoading.dismiss();

      final package = state.package;
      final now = DateTime.now();

      if (package == null ||
          package.endDate == null ||
          package.endDate!.isBefore(now)) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PackagePage(
                  flagpop: false,
                  fullname: "Khách",
                  remainingPackage: getRemainingDays(state.package?.endDate)),
            ));
      } else {
        // Gói còn hạn → vào Dashboard
        Navigator.pushAndRemoveUntil(
          context,
          DashboardPage.route(),
          (route) => false,
        );
      }
    }
  }

  void _onSignin() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      context.read<AuthBloc>().add(AuthLogin(
          password: _passCon.text.trim(),
          phone: _phoneCon.text.replaceAll(' ', '').trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: _listener,
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            spacing: 16.h,
            children: [
              _phoneField(),
              _passwordField(),
              _forgotPassword(),
              _signInButton(),
              _navigateSignUp(),
            ],
          ),
        );
      },
    );
  }

  Widget _phoneField() => BasicInputField(
        controller: _phoneCon,
        hintText: "Số điện thoại",
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Không được để trống';
          } else if (value.length < 12) {
            return 'Số điện thoại không hợp lệ';
          }
          return null;
        },
        inputFormatters: [TextFormatter.phoneFormat],
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.phone,
      );

  Widget _passwordField() => BlocProvider(
        create: (context) => sl<ObscureTextCubit>(),
        child: BlocBuilder<ObscureTextCubit, bool>(
          builder: (context, state) {
            return BasicInputField(
              controller: _passCon,
              hintText: "Nhập mật khẩu",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Không được để trống';
                }
                return null;
              },
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.visiblePassword,
              obscureText: state,
              suffixIcon: IconButton(
                icon: Icon(
                  state ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () =>
                    context.read<ObscureTextCubit>().toggleObscureText(),
              ),
            );
          },
        ),
      );

  Widget _forgotPassword() => Align(
        alignment: Alignment.centerRight,
        child: BasicTextButton(
          text: "Quên mật khẩu?",
          onPressed: () {
            Navigator.push(context, slidePage(ForgotPassPage()));
          },
          fontWeight: FontWeight.w600,
        ),
      );

  Widget _signInButton() => BasicButton(
        text: "Đăng nhập",
        onPressed: () => _onSignin(),
        width: double.infinity,
        fontSize: 18.sp,
        padding: EdgeInsets.symmetric(
          vertical: 14.h,
          horizontal: 20.w,
        ),
        backgroundColor: AppColor.primary600,
      );

  Widget _navigateSignUp() => Align(
        alignment: Alignment.center,
        child: RichText(
          text: TextSpan(
            text: "Chưa có tài khoản? ",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: AppColor.hurricane800,
                  fontWeight: FontWeight.w600,
                ),
            children: [
              TextSpan(
                  text: "ĐĂNG KÝ",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColor.primary500,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColor.primary500,
                      ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushAndRemoveUntil(
                          context, slidePage(SignupPage()), (route) => false);
                    })
            ],
          ),
        ),
      );
  String getRemainingDays(DateTime? endDate) {
    if (endDate == null) return "0 ngày";

    final now = DateTime.now();
    final difference = endDate.difference(now).inDays;

    // Nếu còn 0 hoặc âm ngày thì xem như hết hạn
    if (difference <= 0) return "Hết hạn";
    return "$difference ngày";
  }
}
