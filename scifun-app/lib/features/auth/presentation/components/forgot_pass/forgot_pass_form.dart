import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/helper/text_formatter.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/common/widget/basic_input_field.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/auth/presentation/bloc/auth_bloc.dart';

class ForgotPassForm extends StatefulWidget {
  const ForgotPassForm({super.key});

  @override
  State<ForgotPassForm> createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCon = TextEditingController();
  final _emailCon = TextEditingController();
  late final authBloc = context.read<AuthBloc>();
  @override
  void dispose() {
    super.dispose();
    _phoneCon.dispose();
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
          EasyLoading.showToast(state.message,
              toastPosition: EasyLoadingToastPosition.bottom);
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          spacing: 32.h,
          children: [
            _emailnameField(),
            _phoneField(),
            _continueButton(),
          ],
        ),
      ),
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
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.phone,
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
  Widget _continueButton() => BasicButton(
        text: "Tiếp tục",
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            FocusScope.of(context).unfocus();
            authBloc.add(AuthCheckEmailPhone(
                phone: _phoneCon.text.replaceAll(' ', '').trim(),
                email: _emailCon.text.trim()));

            // Navigator.push(context, slidePage(ConfirmPage()));
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
