import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:sci_fun/common/cubit/obscure_text_cubit.dart';
import 'package:sci_fun/common/helper/show_alert_dialog_custom.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/common/widget/basic_input_field.dart';
import 'package:sci_fun/common/widget/basic_text_button.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/services/share_prefs_service.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sci_fun/features/auth/presentation/page/forgot_pass/forgot_pass_page.dart';
import 'package:sci_fun/features/auth/presentation/page/signup/signup_page.dart';
import 'package:sci_fun/features/home/presentation/page/dashboard_page.dart';
import 'package:sci_fun/features/onboarding/presentation/page/subject_focus_onboarding_page.dart';
import 'package:sci_fun/features/profile/presentation/cubit/user_cubit.dart';

class SigninForm extends StatefulWidget {
  const SigninForm({super.key});

  @override
  State<SigninForm> createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passCon = TextEditingController();
  final TextEditingController _emailCon = TextEditingController();
  late final AuthBloc authBloc;

  @override
  void initState() {
    super.initState();
    authBloc = context.read<AuthBloc>();
  }

  @override
  void dispose() {
    _passCon.dispose();
    _emailCon.dispose();
    super.dispose();
  }

  Future<void> _listener(BuildContext context, AuthState state) async {
    if (!context.mounted) return;
    print('statesignin $state');

    if (state is AuthLoading) {
      EasyLoading.show(
        status: 'Đang tải',
        maskType: EasyLoadingMaskType.black,
      );
      return;
    }

    await EasyLoading.dismiss();
    if (!context.mounted) return;

    if (state is AuthFailure) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        showCustomAlertDialog(
          context,
          'Đăng nhập thất bại',
          state.message,
          'Đồng ý',
        );
      });
      return;
    }

    if (state is AuthUserLoginSuccess) {
      if (!state.isGuest) {
        final userId = sl<SharePrefsService>().getUserData();
        if (userId != null && userId.isNotEmpty) {
          final userCubit = context.read<UserCubit>();
          await userCubit.getUser(token: userId);
        }
      }
      if (!context.mounted) return;

      final shouldShowOnboarding = state.isFirstLogin == true;

      Navigator.pushAndRemoveUntil(
        context,
        shouldShowOnboarding
            ? MaterialPageRoute(
                builder: (_) => const SubjectFocusOnboardingPage(),
              )
            : DashboardPage.route(),
        (route) => false,
      );
    }
  }

  void _onSignin() {
    if (!_formKey.currentState!.validate()) return;
    if (authBloc.state is AuthLoading) return;

    FocusScope.of(context).unfocus();
    authBloc.add(
      AuthLogin(
        password: _passCon.text.trim(),
        email: _emailCon.text.trim(),
      ),
    );
  }

  void _onGuestSignin() {
    if (authBloc.state is AuthLoading) return;

    FocusScope.of(context).unfocus();
    authBloc.add(AuthGuestLogin());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (_, current) =>
          current is AuthLoading ||
          current is AuthFailure ||
          current is AuthUserLoginSuccess,
      listener: _listener,
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            spacing: 16.h,
            children: [
              _emailnameField(),
              _passwordField(),
              _forgotPassword(),
              _signInButton(),
              _guestSignInButton(),
              _navigateSignUp(),
            ],
          ),
        );
      },
    );
  }

  Widget _emailnameField() => BasicInputField(
        controller: _emailCon,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Nhập email';
          }
          return null;
        },
        hintText: 'Email',
        textInputAction: TextInputAction.next,
      );

  Widget _passwordField() => BlocProvider(
        create: (context) => sl<ObscureTextCubit>(),
        child: BlocBuilder<ObscureTextCubit, bool>(
          builder: (context, state) {
            return BasicInputField(
              controller: _passCon,
              hintText: 'Nhập mật khẩu',
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
                  state
                      ? Symbols.visibility_rounded
                      : Symbols.visibility_off_rounded,
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
          text: 'Quên mật khẩu?',
          onPressed: () {
            Navigator.push(context, slidePage(ForgotPassPage()));
          },
          fontWeight: FontWeight.w600,
        ),
      );

  Widget _signInButton() => BasicButton(
        text: 'Đăng nhập',
        onPressed: _onSignin,
        width: double.infinity,
        fontSize: 18.sp,
        padding: EdgeInsets.symmetric(
          vertical: 14.h,
          horizontal: 20.w,
        ),
        backgroundColor: AppColor.skyblue400,
      );

  Widget _guestSignInButton() => BasicButton(
        onPressed: _onGuestSignin,
        width: double.infinity,
        border: true,
        borderColor: AppColor.hurricane200,
        backgroundColor: Colors.white,
        textColor: AppColor.hurricane800,
        fontSize: 18.sp,
        padding: EdgeInsets.symmetric(
          vertical: 14.h,
          horizontal: 20.w,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Symbols.person_outline_rounded,
              size: 20.sp,
              color: AppColor.hurricane800,
            ),
            SizedBox(width: 8.w),
            Text(
              'Đăng nhập khách',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.hurricane800,
                  ),
            ),
          ],
        ),
      );

  Widget _navigateSignUp() => Align(
        alignment: Alignment.center,
        child: RichText(
          text: TextSpan(
            text: 'Chưa có tài khoản? ',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: AppColor.hurricane800,
                  fontWeight: FontWeight.w600,
                ),
            children: [
              TextSpan(
                text: 'ĐĂNG KÝ',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppColor.skyblue500,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColor.skyblue500,
                    ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      slidePage(SignupPage()),
                      (route) => false,
                    );
                  },
              ),
            ],
          ),
        ),
      );

  String getRemainingDays(DateTime? endDate) {
    if (endDate == null) return '0 ngày';

    final now = DateTime.now();
    final difference = endDate.difference(now).inDays;

    if (difference <= 0) return 'Hết hạn';
    return '$difference ngày';
  }
}
