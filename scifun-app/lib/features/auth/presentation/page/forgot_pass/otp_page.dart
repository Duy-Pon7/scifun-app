import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sci_fun/features/auth/presentation/components/forgot_pass/otp_form.dart';
import 'package:sci_fun/features/auth/presentation/cubit/otp_cubit.dart';
import 'package:sci_fun/features/auth/presentation/widget/background_auth.dart';

class OtpPage extends StatefulWidget {
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final bool? flag;
  final bool otpAlreadySent;
  const OtpPage(
      {super.key,
      this.flag,
      required this.email,
      required this.phone,
      required this.password,
      required this.confirmPassword,
      this.otpAlreadySent = false});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  late final blocAuth = context.read<AuthBloc>();
  @override
  void initState() {
    // If OTP was already sent (flow from ForgotPassForm / ConfirmContent sent it), skip sending again
    if (!widget.otpAlreadySent) {
      if (widget.flag == true) {
        blocAuth.add(AuthSendResetEmail(email: widget.email));
      } else {
        // For signup flow we should send the initial OTP using SendEmail
        // instead of calling ResendOtp which is intended for subsequent sends
        blocAuth.add(AuthSendEmail(email: widget.email));
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: "Chi tiết lịch sử gói cước",
        showTitle: true,
        showBack: true,
      ),
      body: BlocProvider(
        create: (context) => sl<OtpCubit>()..startCountdown(),
        child: MultiBlocListener(
          listeners: [
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                print("stateauth $state");
                if (state is AuthMessageSuccess) {
                  EasyLoading.showToast(state.message,
                      toastPosition: EasyLoadingToastPosition.bottom);
                } else if (state is AuthFailure) {
                  EasyLoading.showToast(state.message,
                      toastPosition: EasyLoadingToastPosition.bottom);
                }
              },
            ),
          ],
          child: BackgroundAuth(
            child: SingleChildScrollView(
              child: OtpForm(
                  flag: widget.flag,
                  email: widget.email,
                  phoneNumber: widget.phone,
                  password: widget.password,
                  confirmPassword: widget.confirmPassword),
            ),
          ),
        ),
      ),
    );
  }
}
