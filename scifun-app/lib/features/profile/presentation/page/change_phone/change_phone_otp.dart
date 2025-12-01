import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/features/auth/presentation/components/forgot_pass/otp_form.dart';
import 'package:sci_fun/features/auth/presentation/cubit/otp_cubit.dart';
import 'package:sci_fun/features/auth/presentation/cubit/otp_state.dart';
import 'package:sci_fun/features/auth/presentation/page/forgot_pass/repass_page.dart';
import 'package:sci_fun/features/profile/presentation/widget/social_circle_button.dart';
import 'package:sci_fun/features/profile/presentation/widget/text_with_copy_icon.dart';
import 'package:sci_fun/core/utils/assets/app_image.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';

class ChangePhoneOtp extends StatelessWidget {
  const ChangePhoneOtp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: BasicAppbar(
          title: "Nhập mã OTP",
          showTitle: true,
          showBack: true,
        ),
        body: BlocProvider(
          create: (context) => sl<OtpCubit>()..startCountdown(),
          child: BlocListener<OtpCubit, OtpState>(
            listener: (context, state) {
              if (state is OtpResendSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đã gửi lại mã OTP thành công")),
                );
              } else if (state is OtpResendError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              } else if (state is OtpSuccess) {
                Navigator.pushReplacement(
                    context,
                    slidePage(RepassPage(
                      email: "",
                    )));
              } else if (state is OtpFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            child: SingleChildScrollView(
              child: OtpForm(
                email: "test@example.com",
                phoneNumber: "0123456789",
                password: "password",
                confirmPassword: "confirmPassword",
              ),
            ),
          ),
        ),
      ),
    );
  }
}
