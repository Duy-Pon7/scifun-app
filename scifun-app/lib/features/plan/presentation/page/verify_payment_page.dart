import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/plan/domain/usecase/verify_payment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sci_fun/common/cubit/is_authorized_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/features/profile/presentation/cubit/pro_cubit.dart';

class VerifyPaymentPage extends StatefulWidget {
  const VerifyPaymentPage({super.key});

  @override
  State<VerifyPaymentPage> createState() => _VerifyPaymentPageState();
}

class _VerifyPaymentPageState extends State<VerifyPaymentPage> {
  bool _isLoading = false;
  String? _statusMessage;
  bool _isSuccess = false;

  Future<void> _verifyPayment() async {
    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    try {
      // Lấy appTransId và durationDays đã lưu từ SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final appTransId = prefs.getString('pending_appTransId');
      final durationDays = prefs.getInt('pending_durationDays');

      if (appTransId == null || durationDays == null) {
        setState(() {
          _isLoading = false;
          _statusMessage =
              'Không tìm thấy thông tin giao dịch. Vui lòng thử lại từ trang mua gói.';
          _isSuccess = false;
        });
        return;
      }

      final res = await sl<VerifyPayment>().call(
        VerifyPaymentParams(
          appTransId: appTransId,
          durationDays: durationDays,
        ),
      );

      res.fold(
        (failure) {
          setState(() {
            _isLoading = false;
            _statusMessage = 'Xác thực thất bại: ${failure.message}';
            _isSuccess = false;
          });
        },
        (message) async {
          // Xóa dữ liệu pending sau khi xác thực thành công
          await prefs.remove('pending_appTransId');
          await prefs.remove('pending_durationDays');

          setState(() {
            _isLoading = false;
            _statusMessage =
                'Thanh toán thành công! Đang khởi động lại ứng dụng...';
            _isSuccess = true;
          });

          // Đợi 2 giây để user thấy thông báo thành công
          await Future.delayed(const Duration(seconds: 2));

          // Reset app - reload lại trạng thái user và pro status
          if (mounted) {
            await _resetApp();
          }
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Có lỗi xảy ra: $e';
        _isSuccess = false;
      });
    }
  }

  Future<void> _resetApp() async {
    // Refresh lại thông tin user và pro status
    context.read<IsAuthorizedCubit>().isAuthorized();

    // Lấy token để check pro status
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null) {
      await context.read<ProCubit>().isCheckPro(token: token);
    }

    // Quay về trang chủ và xóa hết stack navigation
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);

      // Show thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Nâng cấp gói thành công! Chào mừng bạn đến với gói Premium.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(title: 'Xác nhận thanh toán'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  color: _isSuccess
                      ? Colors.green.withValues(alpha: 0.1)
                      : AppColor.primary500.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isSuccess
                      ? Icons.check_circle_outline
                      : Icons.payment_outlined,
                  size: 60.w,
                  color: _isSuccess ? Colors.green : AppColor.primary500,
                ),
              ),
              SizedBox(height: 30.h),

              // Title
              Text(
                _isSuccess ? 'Thanh toán thành công!' : 'Xác nhận thanh toán',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: _isSuccess ? Colors.green : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),

              // Description
              Text(
                _isSuccess
                    ? 'Gói Premium của bạn đã được kích hoạt thành công.'
                    : 'Nhấn nút bên dưới để kiểm tra trạng thái thanh toán của bạn.',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30.h),

              // Status message
              if (_statusMessage != null) ...[
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: _isSuccess
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: _isSuccess ? Colors.green : Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isSuccess ? Icons.check_circle : Icons.error_outline,
                        color: _isSuccess ? Colors.green : Colors.red,
                        size: 24.w,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          _statusMessage!,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: _isSuccess
                                ? Colors.green[700]
                                : Colors.red[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),
              ],

              // Button
              if (!_isSuccess && !_isLoading) ...[
                SizedBox(
                  width: double.infinity,
                  child: BasicButton(
                    onPressed: () => _verifyPayment(),
                    text: 'Kiểm tra thanh toán',
                  ),
                ),
                SizedBox(height: 16.h),

                // Back button
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Quay lại',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],

              // Loading indicator
              if (_isLoading) ...[
                SizedBox(height: 20.h),
                const CircularProgressIndicator(),
                SizedBox(height: 16.h),
                Text(
                  'Đang kiểm tra thanh toán...',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
