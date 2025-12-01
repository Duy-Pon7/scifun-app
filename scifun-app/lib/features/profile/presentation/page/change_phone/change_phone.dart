import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/helper/text_formatter.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/common/widget/basic_input_field.dart';
import 'package:sci_fun/core/utils/assets/app_image.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/auth/presentation/page/forgot_pass/otp_page.dart';
import 'package:sci_fun/features/profile/presentation/page/change_phone/change_phone_otp.dart';

class ChangePhone extends StatefulWidget {
  const ChangePhone({super.key});

  @override
  State<ChangePhone> createState() => _ChangePhoneState();
}

class _ChangePhoneState extends State<ChangePhone> {
  final TextEditingController _phoneCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: BasicAppbar(
          title: "Đổi số điện thoại",
          showTitle: true,
          showBack: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
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
                    _phoneField(),
                    SizedBox(height: 40.h),
                    _changeButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _changeButton() => BasicButton(
        text: "Gửi mã",
        onPressed: () {
          Navigator.push(context, slidePage(ChangePhoneOtp()));
        },
        width: double.infinity,
        fontSize: 18.sp,
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
        backgroundColor: AppColor.primary600,
      );

  Widget _phoneField() => BasicInputField(
        controller: _phoneCon,
        hintText: "Số điện thoại mới",
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Không được để trống';
          } else if (value.length < 12) {
            return 'Số điện thoại không hợp lệ';
          }
          return null;
        },
        inputFormatters: [TextFormatter.phoneFormat],
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.phone,
      );
}
