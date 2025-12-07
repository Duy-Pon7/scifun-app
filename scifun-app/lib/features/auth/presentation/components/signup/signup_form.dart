import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/cubit/obscure_text_cubit.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/common/widget/basic_input_field.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sci_fun/features/auth/presentation/page/forgot_pass/otp_page.dart';
import 'package:sci_fun/features/auth/presentation/page/signin/signin_page.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneCon = TextEditingController();
  final TextEditingController _passCon = TextEditingController();
  final TextEditingController _confirmPassCon = TextEditingController();
  final TextEditingController _emailCon = TextEditingController();

  final FocusNode _passFocus = FocusNode();
  final FocusNode _confirmPassFocus = FocusNode();
  late final authBloc = context.read<AuthBloc>();
  @override
  void dispose() {
    super.dispose();
    _phoneCon.dispose();
    _passCon.dispose();
    _emailCon.dispose();
    _confirmPassCon.dispose();
    _passFocus.dispose();
    _confirmPassFocus.dispose();
  }

  void _onSignup() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      final String email = _emailCon.text.trim();
      final String password = _passCon.text.trim();
      final String passswordConfimation = _confirmPassCon.text.trim();
      final String fullname = _phoneCon.text.trim();
      authBloc.add(AuthSignup(
        email: email,
        password: password,
        passwordConfimation: passswordConfimation,
        fullname: fullname,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        print("Auth State: $state");
        if (state is AuthUserSuccess) {
          // After successful signup, navigate to OTP page
          EasyLoading.dismiss();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpPage(
                email: _emailCon.text.trim(),
                phone: _phoneCon.text.replaceAll(' ', '').trim(),
                password: _passCon.text.trim(),
                confirmPassword: _confirmPassCon.text.trim(),
              ),
            ),
          );
        } else if (state is AuthLoading) {
          EasyLoading.show(
            status: 'Đang tải',
            maskType: EasyLoadingMaskType.black,
          );
        } else if (state is AuthFailure) {
          EasyLoading.dismiss();
          EasyLoading.showToast(state.message,
              toastPosition: EasyLoadingToastPosition.bottom);
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          spacing: 16.h,
          children: [
            _fullnameField(),
            _emailnameField(),
            _passwordField(),
            _confirmPassField(),
            _signUpButton(),
            _navigateSignUp(),
          ],
        ),
      ),
    );
  }

  Widget _fullnameField() => BasicInputField(
        controller: _phoneCon,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Nhập họ tên';
          }
          return null;
        },
        hintText: "Họ tên",
        textInputAction: TextInputAction.next,
      );

  Widget _emailnameField() => BasicInputField(
        controller: _emailCon,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Nhập email';
          }
          return null;
        },
        hintText: "Email",
        textInputAction: TextInputAction.next,
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
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.visiblePassword,
              obscureText: state,
              suffixIcon: IconButton(
                icon: Icon(
                  state ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () =>
                    context.read<ObscureTextCubit>().toggleObscureText(),
              ),
              focusNode: _passFocus,
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(_confirmPassFocus),
            );
          },
        ),
      );

  Widget _confirmPassField() => BlocProvider(
        create: (context) => sl<ObscureTextCubit>(),
        child: BlocBuilder<ObscureTextCubit, bool>(
          builder: (context, state) {
            return BasicInputField(
              controller: _confirmPassCon,
              hintText: "Nhập lại mật khẩu",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Không được để trống';
                } else if (value != _passCon.text) {
                  return 'Mật khẩu không khớp';
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
              focusNode: _confirmPassFocus,
            );
          },
        ),
      );

  Widget _signUpButton() => BasicButton(
        text: "Đăng ký",
        onPressed: () => _onSignup(),
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
            text: "Đã có tài khoản? ",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: AppColor.hurricane800,
                  fontWeight: FontWeight.w600,
                ),
            children: [
              TextSpan(
                  text: "ĐĂNG NHẬP",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColor.primary500,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColor.primary500,
                      ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        slidePage(SigninPage()),
                        (route) => false,
                      );
                    })
            ],
          ),
        ),
      );
}
