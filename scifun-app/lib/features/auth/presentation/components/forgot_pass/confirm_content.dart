import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/common/widget/custom_network_asset_image.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/auth/presentation/page/forgot_pass/otp_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sci_fun/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sci_fun/common/helper/show_alert_dialog_custom.dart';

class ConfirmContent extends StatefulWidget {
  final String email;
  final String phone;
  final String avatar;
  final String fullName;

  const ConfirmContent(
      {super.key,
      required this.email,
      required this.phone,
      required this.avatar,
      required this.fullName});

  @override
  State<ConfirmContent> createState() => _ConfirmContentState();
}

class _ConfirmContentState extends State<ConfirmContent> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          EasyLoading.show(
              status: 'Đang tải', maskType: EasyLoadingMaskType.black);
        } else if (state is AuthFailure) {
          EasyLoading.dismiss();
          showCustomAlertDialog(context, 'Lỗi', state.message, 'Đồng ý');
        } else if (state is AuthMessageSuccess) {
          EasyLoading.dismiss();
          EasyLoading.showToast(state.message,
              toastPosition: EasyLoadingToastPosition.bottom);
          Navigator.pushReplacement(
            context,
            slidePage(OtpPage(
                flag: true,
                email: widget.email,
                phone: widget.phone,
                password: "password",
                confirmPassword: "confirmPassword",
                otpAlreadySent: true)),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 40.h),
        width: double.infinity,
        child: Column(
          spacing: 32.h,
          children: [
            _avtAndName(widget.avatar.isNotEmpty
                ? widget.avatar
                : "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541"),
            Text(
              "Đây là tài khoản của bạn?",
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: AppColor.primary500,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            _listButton(),
          ],
        ),
      ),
    );
  }

  Widget _avtAndName(String imgUrl) => Column(
        spacing: 12.h,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(55.r),
            child: CustomNetworkAssetImage(
              imagePath: imgUrl,
              width: 110.w,
              height: 110.w,
            ),
          ),
          Text(
            widget.fullName,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      );

  Widget _listButton() => Column(
        spacing: 16.h,
        children: [
          BasicButton(
            text: "Đúng vậy",
            onPressed: () => context
                .read<AuthBloc>()
                .add(AuthSendResetEmail(email: widget.email)),
            width: double.infinity,
            fontSize: 18.sp,
            padding: EdgeInsets.symmetric(
              vertical: 14.h,
              horizontal: 20.w,
            ),
            backgroundColor: AppColor.primary600,
          ),
          BasicButton(
            text: "Không phải",
            onPressed: () => Navigator.of(context).pop(),
            width: double.infinity,
            fontSize: 18.sp,
            padding: EdgeInsets.symmetric(
              vertical: 14.h,
              horizontal: 20.w,
            ),
            textColor: AppColor.primary600,
            backgroundColor: AppColor.primary600.withValues(alpha: 0.16),
          ),
        ],
      );
}
