import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sci_fun/common/cubit/is_authorized_cubit.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/common/widget/basic_input_field.dart';
import 'package:sci_fun/core/constants/api_urls.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/network/dio_client.dart';
import 'package:sci_fun/core/services/share_prefs_service.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/auth/presentation/page/signin/signin_page.dart';
import 'package:sci_fun/features/profile/presentation/cubit/user_cubit.dart';

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
    String fallback = 'Dong bo du lieu that bai',
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

  Future<void> _logoutAndNavigateToSignin() async {
    await sl<SharePrefsService>().clear();
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'access_token');
    await sl<IsAuthorizedCubit>().logout();
    sl<UserCubit>().clear();
    resetSingleton();

    if (!mounted) {
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SigninPage()),
      (route) => false,
    );
  }

  Future<void> _submitSync() async {
    if (_isSubmitting) return;
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _isSubmitting = true);

    EasyLoading.show(
      status: 'Dang dong bo...',
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
        fallback: 'Dong bo du lieu thanh cong',
      );
      await EasyLoading.dismiss();
      EasyLoading.showToast(
        message,
        toastPosition: EasyLoadingToastPosition.bottom,
      );

      await _logoutAndNavigateToSignin();
    } on DioException catch (e) {
      await EasyLoading.dismiss();
      final message = _extractServerMessage(
        e.response?.data,
        fallback: e.message ?? 'Dong bo du lieu that bai',
      );
      EasyLoading.showToast(
        message,
        toastPosition: EasyLoadingToastPosition.bottom,
      );
    } catch (_) {
      await EasyLoading.dismiss();
      EasyLoading.showToast(
        'Dong bo du lieu that bai',
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
        appBar: AppBar(
          title: const Text('Dong bo tai khoan guest'),
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
                      'Nhap thong tin tai khoan moi. Sau khi dong bo thanh cong, he thong se dang xuat de ban dang nhap lai.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  BasicInputField(
                    controller: _fullnameCon,
                    hintText: 'Ho va ten',
                    textInputAction: TextInputAction.next,
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui long nhap ho va ten';
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
                    prefixIcon: const Icon(Icons.email_outlined),
                    validator: (value) {
                      final email = (value ?? '').trim();
                      if (email.isEmpty) {
                        return 'Vui long nhap email';
                      }
                      final emailReg = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                      if (!emailReg.hasMatch(email)) {
                        return 'Email khong hop le';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12.h),
                  BasicInputField(
                    controller: _passwordCon,
                    hintText: 'Mat khau',
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    obscureText: _obscurePassword,
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    validator: (value) {
                      final pass = value ?? '';
                      if (pass.isEmpty) {
                        return 'Vui long nhap mat khau';
                      }
                      if (pass.length < 6) {
                        return 'Mat khau phai tu 6 ky tu';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.h),
                  BasicButton(
                    text: _isSubmitting ? 'Dang dong bo...' : 'Dong bo du lieu',
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
