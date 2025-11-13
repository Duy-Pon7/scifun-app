import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/cubit/is_authorized_cubit.dart';
import 'package:sci_fun/common/cubit/obscure_text_cubit.dart';
import 'package:sci_fun/common/helper/text_formatter.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/common/widget/basic_input_field.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/services/share_prefs_service.dart';
import 'package:sci_fun/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sci_fun/core/utils/assets/app_image.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/auth/presentation/page/signin/signin_page.dart';

class ChangePass extends StatefulWidget {
  const ChangePass({super.key});

  @override
  State<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _passOldCon = TextEditingController();
  final TextEditingController _passNewCon = TextEditingController();
  final TextEditingController _passNewAgainCon = TextEditingController();
  final FocusNode _oldPassFocus = FocusNode();
  final FocusNode _newPassFocus = FocusNode();
  final FocusNode _newPassAgainFocus = FocusNode();

  @override
  @override
  void dispose() {
    _oldPassFocus.dispose();
    _newPassFocus.dispose();
    _newPassAgainFocus.dispose();
    _passOldCon.dispose();
    _passNewCon.dispose();
    _passNewAgainCon.dispose();
    super.dispose();
  }

  void _listener(BuildContext context, AuthState state) async {
    if (state is AuthLoading) {
      EasyLoading.show(
        status: 'Đang tải',
        maskType: EasyLoadingMaskType.black,
      );
    } else if (state is AuthFailure) {
      EasyLoading.dismiss();
      EasyLoading.showToast(
        state.message,
        toastPosition: EasyLoadingToastPosition.bottom,
      );
    } else if (state is AuthMessageSuccess) {
      EasyLoading.dismiss();
      EasyLoading.showToast(
        state.message,
        toastPosition: EasyLoadingToastPosition.bottom,
      );
      await sl<SharePrefsService>().clear();
      sl<IsAuthorizedCubit>().isAuthorized();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const SigninPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: BasicAppbar(
          title: Text(
            "Đổi số mật khẩu",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColor.primary600,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: _listener,
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24.r),
                          child: Image.asset(
                            AppImage.logo,
                            width: 90.w,
                            height: 90.h,
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),
                      _passwordOldField(),
                      SizedBox(height: 16.h),
                      _passwordNewField(),
                      SizedBox(height: 16.h),
                      _passwordNewAgainField(),
                      SizedBox(height: 40.h),
                      _changeButton(),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _changeButton() => BasicButton(
        text: "Lưu thay đổi",
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            FocusScope.of(context).unfocus();
            context.read<AuthBloc>().add(AuthChangePass(
                oldPass: _passOldCon.text.trim(),
                newPass: _passNewCon.text.trim(),
                newPassConfirm: _passNewAgainCon.text.trim()));
          }
        },
        width: double.infinity,
        fontSize: 18.sp,
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
        backgroundColor: AppColor.primary600,
      );

  Widget _passwordOldField() => BlocProvider(
        create: (context) => sl<ObscureTextCubit>(),
        child: BlocBuilder<ObscureTextCubit, bool>(
          builder: (context, state) {
            return BasicInputField(
              controller: _passOldCon,
              hintText: "Mật khẩu cũ",
              prefixIcon: Icon(
                Icons.password,
                color: AppColor.primary600,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Không được để trống';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
              focusNode: _oldPassFocus,
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(_newPassFocus),
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
  Widget _passwordNewField() => BlocProvider(
        create: (context) => sl<ObscureTextCubit>(),
        child: BlocBuilder<ObscureTextCubit, bool>(
          builder: (context, state) {
            return BasicInputField(
              controller: _passNewCon,
              hintText: "Mật khẩu mới",
              prefixIcon: Icon(
                Icons.password,
                color: AppColor.primary600,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Không được để trống';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
              focusNode: _newPassFocus,
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(_newPassAgainFocus),
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
  Widget _passwordNewAgainField() => BlocProvider(
        create: (context) => sl<ObscureTextCubit>(),
        child: BlocBuilder<ObscureTextCubit, bool>(
          builder: (context, state) {
            return BasicInputField(
              controller: _passNewAgainCon,
              hintText: "Nhập lại mật khẩu",
              prefixIcon: Icon(
                Icons.password,
                color: AppColor.primary600,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Không được để trống';
                } else if (value != _passNewCon.text) {
                  return 'Mật khẩu không khớp';
                }
                return null;
              },
              textInputAction: TextInputAction.done,
              focusNode: _newPassAgainFocus,
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
                // Optionally: trigger submit here
              },
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
}
