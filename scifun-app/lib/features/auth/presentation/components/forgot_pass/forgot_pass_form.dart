import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/common/widget/basic_input_field.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sci_fun/features/auth/presentation/page/forgot_pass/otp_page.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/common/helper/show_alert_dialog_custom.dart';

class ForgotPassForm extends StatefulWidget {
  const ForgotPassForm({super.key});

  @override
  State<ForgotPassForm> createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCon = TextEditingController();
  late final authBloc = context.read<AuthBloc>();
  @override
  void dispose() {
    super.dispose();
    _emailCon.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          EasyLoading.show(
            status: 'Đang tải',
            maskType: EasyLoadingMaskType.black,
          );
        } else if (state is AuthFailure) {
          EasyLoading.dismiss();
          // Show dialog with server message (e.g., "Email không tồn tại")
          showCustomAlertDialog(context, 'Lỗi', state.message, 'Đồng ý');
        } else if (state is AuthMessageSuccess) {
          EasyLoading.dismiss();
          EasyLoading.showToast(state.message,
              toastPosition: EasyLoadingToastPosition.bottom);

          // OTP already sent; navigate and avoid re-sending inside OtpPage
          Navigator.push(
            context,
            slidePage(OtpPage(
              flag: true,
              email: _emailCon.text.trim(),
              phone: '',
              password: '',
              confirmPassword: '',
              otpAlreadySent: true,
            )),
          );
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          spacing: 32.h,
          children: [
            _emailnameField(),
            _continueButton(),
          ],
        ),
      ),
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
        hintText: "Email",
        textInputAction: TextInputAction.next,
      );
  Widget _continueButton() => BasicButton(
        text: "Tiếp tục",
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            FocusScope.of(context).unfocus();

            // Call forgot-password API via bloc; navigation happens on success
            authBloc.add(AuthSendResetEmail(email: _emailCon.text.trim()));
          }
        },
        width: double.infinity,
        fontSize: 18.sp,
        padding: EdgeInsets.symmetric(
          vertical: 14.h,
          horizontal: 20.w,
        ),
        backgroundColor: AppColor.primary600,
      );
}
