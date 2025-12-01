import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
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
  const OtpPage(
      {super.key,
      this.flag,
      required this.email,
      required this.phone,
      required this.password,
      required this.confirmPassword});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  late final blocAuth = context.read<AuthBloc>();
  @override
  void initState() {
    blocAuth.add(AuthResendOtp(email: widget.email));
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
                  if (state.message == "true") {
                    EasyLoading.showToast(
                        "Đã gửi mã OTP vào email đã nhập: ${widget.email}",
                        toastPosition: EasyLoadingToastPosition.bottom);
                  } else {
                    EasyLoading.showToast("Lỗi gửi mã Otp",
                        toastPosition: EasyLoadingToastPosition.bottom);
                  }
                } else if (state is AuthFailure) {
                  EasyLoading.showToast("Lỗi gửi mã Otp",
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
