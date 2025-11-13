import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sci_fun/common/widget/basic_text_button.dart';
import 'package:sci_fun/core/utils/assets/app_vector.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sci_fun/features/auth/presentation/cubit/otp_cubit.dart';
import 'package:sci_fun/features/auth/presentation/cubit/otp_state.dart';
import 'package:sci_fun/features/auth/presentation/page/forgot_pass/repass_page.dart';
import 'package:sci_fun/features/auth/presentation/page/signup/add_infomation_page.dart';

class OtpForm extends StatefulWidget {
  const OtpForm(
      {super.key,
      this.flag,
      required this.email,
      required this.phoneNumber,
      required this.password,
      required this.confirmPassword});
  final bool? flag;
  final String email;
  final String phoneNumber;
  final String password;
  final String confirmPassword;

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  late final authBloc = context.read<AuthBloc>();
  late final otpCubit = context.read<OtpCubit>();
  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OtpCubit, OtpState>(
      listener: (context, state) {
        if (state is OtpSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Mã OTP chính xác"),
              backgroundColor: Colors.green,
            ),
          );
          print(widget.flag);
          if (widget.flag == true) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RepassPage(email: widget.email),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AddInfomationPage(
                  email: widget.email,
                  phone: widget.phoneNumber,
                  password: widget.password,
                  confirmPassword: widget.confirmPassword,
                ),
              ),
            );
          }
        } else if (state is OtpFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Mã OTP không chính xác"),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is OtpResendError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is OtpResendSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Mã OTP đã được gửi lại."),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 40.h),
        width: double.infinity,
        child: Column(
          spacing: 32.h,
          children: [
            SvgPicture.asset(AppVector.iconSmsNoti),
            Column(
              spacing: 12.h,
              children: [
                Text(
                  "Nhập mã xác minh",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: AppColor.primary500,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  "Mã đã được gửi đến số ${widget.phoneNumber.replaceRange(0, 7, '*******')}",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 17.sp,
                      ),
                ),
              ],
            ),
            Column(
              spacing: 12.h,
              children: [
                _optRow(),
                BlocBuilder<OtpCubit, OtpState>(
                  builder: (context, state) {
                    if (state is OtpCountdownState) {
                      if (state.canResend) {
                        return BasicTextButton(
                          text: "Gửi lại mã mới",
                          textColor: AppColor.primary600,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w400,
                          onPressed: () async {
                            await otpCubit.resendOtp();
                            authBloc.add(AuthResendOtp(email: widget.email));
                            for (var controller in _controllers) {
                              controller.clear();
                            }
                            _focusNodes[0].requestFocus();
                          },
                        );
                      } else {
                        return Text(
                          "Có thể gửi lại mã sau ${_formatTime(state.remainingTime)}",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 17.sp,
                                    color: AppColor.hurricane800
                                        .withValues(alpha: 0.3),
                                  ),
                        );
                      }
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _otpField(int index) {
    return Container(
      width: 50.w,
      height: 50.w,
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: RawKeyboardListener(
        focusNode: FocusNode(), // focus riêng cho keyboard
        onKey: (event) {
          if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            if (_controllers[index].text.isEmpty && index > 0) {
              _focusNodes[index - 1].requestFocus();
              _controllers[index - 1].clear();
            }
          }
        },
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          textInputAction:
              index == 5 ? TextInputAction.done : TextInputAction.next,
          maxLength: 1,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: Color(0xff413E3E).withValues(alpha: 0.3),
                width: 0.5.w,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: AppColor.primary600,
                width: 0.8.w,
              ),
            ),
            counterText: '',
            filled: true,
            fillColor: Colors.white,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1),
          ],
          onChanged: (value) {
            if (value.isNotEmpty) {
              if (index < 5) {
                _focusNodes[index + 1].requestFocus();
              } else {
                _focusNodes[index].unfocus();
              }
            }

            final code = _controllers.map((c) => c.text).join();
            if (code.length == 6) {
              otpCubit.verifyOtp(widget.email, code);
            }
          },
        ),
      ),
    );
  }

  Widget _optRow() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          6,
          (index) => _otpField(index),
        ),
      );
}
