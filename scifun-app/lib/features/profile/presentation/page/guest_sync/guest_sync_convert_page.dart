import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/common/widget/basic_input_field.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/auth/presentation/page/forgot_pass/otp_page.dart';

class GuestSyncConvertPage extends StatefulWidget {
  const GuestSyncConvertPage({
    super.key,
    this.initialEmail = '',
    this.initialPassword = '',
    this.initialFullname = '',
  });

  final String initialEmail;
  final String initialPassword;
  final String initialFullname;

  @override
  State<GuestSyncConvertPage> createState() => _GuestSyncConvertPageState();
}

class _GuestSyncConvertPageState extends State<GuestSyncConvertPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailCon;
  late final TextEditingController _passwordCon;
  late final TextEditingController _fullnameCon;

  bool _isSubmitting = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailCon = TextEditingController(text: widget.initialEmail.trim());
    _passwordCon = TextEditingController(text: widget.initialPassword.trim());
    _fullnameCon = TextEditingController(text: widget.initialFullname.trim());
  }

  @override
  void dispose() {
    _emailCon.dispose();
    _passwordCon.dispose();
    _fullnameCon.dispose();
    super.dispose();
  }

  String _extractServerMessage(
    dynamic data, {
    String fallback = 'Đồng bộ dữ liệu thất bại',
  }) {
    if (data == null) return fallback;

    if (data is String) {
      final text = data.trim();
      return text.isEmpty ? fallback : text;
    }

    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }
      if (message is List && message.isNotEmpty) {
        return message.first.toString();
      }

      final error = data['error'];
      if (error is String && error.trim().isNotEmpty) {
        return error.trim();
      }
    }

    return fallback;
  }

  void _navigateToOtpPage() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      slidePage(
        OtpPage(
          email: _emailCon.text.trim(),
          phone: _fullnameCon.text.trim(),
          password: _passwordCon.text,
          confirmPassword: _passwordCon.text,
          otpAlreadySent: true,
          isGuestConvertFlow: true,
        ),
      ),
    );
  }

  Future<void> _submitSync() async {
    if (_isSubmitting) return;
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _isSubmitting = true);

    EasyLoading.show(
      status: 'Đang đồng bộ...',
      maskType: EasyLoadingMaskType.black,
    );

    try {
      final res = await sl<DioClient>().post(
        url: UserApiUrls.guestConvert,
        data: {
          'email': _emailCon.text.trim(),
          'password': _passwordCon.text,
          'fullname': _fullnameCon.text.trim(),
        },
      );

      if (res.data is Map<String, dynamic>) {
        final status = (res.data['status'] as num?)?.toInt();
        if (status != null && (status < 200 || status >= 300)) {
          throw DioException(
            requestOptions: res.requestOptions,
            response: res,
            type: DioExceptionType.badResponse,
          );
        }
      }

      final message = _extractServerMessage(
        res.data,
        fallback: 'Đồng bộ thành công, vui lòng nhập OTP',
      );
      await EasyLoading.dismiss();
      EasyLoading.showToast(
        message,
        toastPosition: EasyLoadingToastPosition.bottom,
      );

      _navigateToOtpPage();
    } on DioException catch (e) {
      await EasyLoading.dismiss();
      final message = _extractServerMessage(
        e.response?.data,
        fallback: e.message ?? 'Đồng bộ dữ liệu thất bại',
      );
      EasyLoading.showToast(
        message,
        toastPosition: EasyLoadingToastPosition.bottom,
      );
    } catch (_) {
      await EasyLoading.dismiss();
      EasyLoading.showToast(
        'Đồng bộ dữ liệu thất bại',
        toastPosition: EasyLoadingToastPosition.bottom,
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: const BasicAppbar(
          title: 'Đồng bộ tài khoản guest',
          showTitle: true,
          showBack: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: AppColor.skyblue50,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      'Nhập thông tin tài khoản, nhấn đồng bộ để hệ thống gửi OTP xác nhận.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  BasicInputField(
                    controller: _fullnameCon,
                    hintText: 'Họ và tên',
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Symbols.person_outline_rounded),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập họ và tên';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12.h),
                  BasicInputField(
                    controller: _emailCon,
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Symbols.email),
                    validator: (value) {
                      final email = (value ?? '').trim();
                      if (email.isEmpty) {
                        return 'Vui lòng nhập email';
                      }
                      final emailReg = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                      if (!emailReg.hasMatch(email)) {
                        return 'Email không hợp lệ';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12.h),
                  BasicInputField(
                    controller: _passwordCon,
                    hintText: 'Mật khẩu',
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    obscureText: _obscurePassword,
                    prefixIcon: const Icon(Symbols.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Symbols.visibility
                            : Symbols.visibility_off,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    validator: (value) {
                      final pass = value ?? '';
                      if (pass.isEmpty) {
                        return 'Vui lòng nhập mật khẩu';
                      }
                      if (pass.length < 6) {
                        return 'Mật khẩu phải từ 6 ký tự';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.h),
                  BasicButton(
                    text: _isSubmitting ? 'Đang đồng bộ...' : 'Đồng bộ dữ liệu',
                    onPressed: _submitSync,
                    width: double.infinity,
                    fontSize: 17.sp,
                    backgroundColor: AppColor.skyblue400,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
