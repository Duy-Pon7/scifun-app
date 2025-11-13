import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sci_fun/common/cubit/obscure_text_cubit.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/common/widget/basic_input_field.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/utils/assets/app_vector.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sci_fun/features/auth/presentation/page/signin/signin_page.dart';

class RepassForm extends StatefulWidget {
  final String email;
  const RepassForm({super.key, required this.email});

  @override
  State<RepassForm> createState() => _RepassFormState();
}

class _RepassFormState extends State<RepassForm> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _passCon = TextEditingController();
  final TextEditingController _rePassCon = TextEditingController();

  final FocusNode _passFocus = FocusNode();
  final FocusNode _confirmPassFocus = FocusNode();
  late final authBloc = context.read<AuthBloc>();
  @override
  void dispose() {
    super.dispose();
    _passCon.dispose();
    _rePassCon.dispose();
    _passFocus.dispose();
    _confirmPassFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          // Show error message
          EasyLoading.dismiss();
          EasyLoading.showToast(state.message,
              toastPosition: EasyLoadingToastPosition.bottom);
        } else if (state is AuthUserSuccess) {
          // Navigate to success page
          EasyLoading.dismiss();
          EasyLoading.showToast("Cập nhật mật khẩu thành công",
              toastPosition: EasyLoadingToastPosition.bottom);
          Navigator.pushAndRemoveUntil(
            context,
            slidePage(SigninPage()),
            (route) => false,
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 40.h),
        width: double.infinity,
        child: Column(
          spacing: 32.h,
          children: [
            SvgPicture.asset(AppVector.iconPasswordCheck),
            Text(
              "Tạo mật khẩu mới",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: AppColor.primary500,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            Form(
              key: formKey,
              child: Column(
                spacing: 12.h,
                children: [
                  _passwordField(),
                  _rePasswordField(),
                  _changePassButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _passwordField() => BlocProvider(
        create: (context) => sl<ObscureTextCubit>(),
        child: BlocBuilder<ObscureTextCubit, bool>(
          builder: (context, state) {
            return BasicInputField(
              controller: _passCon,
              hintText: "Nhập mật khẩu mới",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Không được để trống';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.visiblePassword,
              obscureText: state,
              focusNode: _passFocus,
              suffixIcon: IconButton(
                icon: Icon(
                  state ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () =>
                    context.read<ObscureTextCubit>().toggleObscureText(),
              ),
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(_confirmPassFocus),
            );
          },
        ),
      );

  Widget _rePasswordField() => BlocProvider(
        create: (context) => sl<ObscureTextCubit>(),
        child: BlocBuilder<ObscureTextCubit, bool>(
          builder: (context, state) {
            return BasicInputField(
              controller: _rePassCon,
              hintText: "Nhập lại mật khẩu mới",
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
              focusNode: _confirmPassFocus,
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

  Widget _changePassButton() => BasicButton(
        text: "Lưu mật khẩu mới",
        onPressed: () {
          if (formKey.currentState!.validate()) {
            FocusScope.of(context).unfocus();
            authBloc.add(AuthResetPassword(
                email: widget.email,
                newPass: _passCon.text,
                newPassConfirm: _rePassCon.text));
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
