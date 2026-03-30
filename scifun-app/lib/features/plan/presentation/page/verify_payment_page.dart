import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sci_fun/common/cubit/is_authorized_cubit.dart';
import 'package:sci_fun/common/widget/app_loading_indicator.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/profile/presentation/cubit/pro_cubit.dart';

class VerifyPaymentPage extends StatefulWidget {
  const VerifyPaymentPage({super.key});

  @override
  State<VerifyPaymentPage> createState() => _VerifyPaymentPageState();
}

class _VerifyPaymentPageState extends State<VerifyPaymentPage> {
  static const _pendingPaymentRefKey = 'pending_payment_ref';
  static const _pendingDurationDaysKey = 'pending_durationDays';

  bool _isLoading = false;
  String? _statusMessage;
  bool _isSuccess = false;
  String? _paymentRef;
  int? _durationDays;

  @override
  void initState() {
    super.initState();
    _loadPendingPayment();
  }

  Future<void> _loadPendingPayment() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _paymentRef = prefs.getString(_pendingPaymentRefKey) ??
          prefs.getString('pending_appTransId');
      _durationDays = prefs.getInt(_pendingDurationDaysKey) ??
          prefs.getInt('pending_durationDays');
    });
  }

  Future<void> _clearPendingPayment() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pendingPaymentRefKey);
    await prefs.remove(_pendingDurationDaysKey);

    // Cleanup old keys kept for backward compatibility.
    await prefs.remove('pending_appTransId');
    await prefs.remove('pending_durationDays');
  }

  Future<void> _verifyPayment() async {
    final isAuthorizedCubit = context.read<IsAuthorizedCubit>();
    final proCubit = context.read<ProCubit>();

    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        setState(() {
          _isLoading = false;
          _statusMessage =
              'Không tìm thấy phiên đăng nhập. Vui lòng đăng nhập lại rồi kiểm tra thanh toán.';
          _isSuccess = false;
        });
        return;
      }

      if (_paymentRef == null || _paymentRef!.isEmpty) {
        setState(() {
          _isLoading = false;
          _statusMessage =
              'Không tìm thấy giao dịch đang chờ. Hãy thực hiện thanh toán từ trang mua gói.';
          _isSuccess = false;
        });
        return;
      }

      isAuthorizedCubit.isAuthorized();
      final isPro = await proCubit.isCheckPro(token: token);

      if (!isPro) {
        setState(() {
          _isLoading = false;
          _statusMessage =
              'Chưa xác nhận được thanh toán MoMo (${_paymentRef!}). Nếu bạn vừa thanh toán, chờ 10-30 giây rồi kiểm tra lại.';
          _isSuccess = false;
        });
        return;
      }

      await _clearPendingPayment();

      setState(() {
        _isLoading = false;
        _statusMessage =
            'Thanh toán thành công (${_paymentRef!}). Đang khởi động lại ứng dụng...';
        _isSuccess = true;
      });

      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        await _resetApp();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Có lỗi xảy ra: $e';
        _isSuccess = false;
      });
    }
  }

  Future<void> _resetApp() async {
    final isAuthorizedCubit = context.read<IsAuthorizedCubit>();
    final proCubit = context.read<ProCubit>();

    isAuthorizedCubit.isAuthorized();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null) {
      await proCubit.isCheckPro(token: token);
    }

    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
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
      appBar: const BasicAppbar(title: 'Kiểm tra thanh toán'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  color: _isSuccess
                      ? Colors.green.withValues(alpha: 0.1)
                      : AppColor.skyblue500.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isSuccess ? Symbols.check_circle_outline : Symbols.payment,
                  size: 60.w,
                  color: _isSuccess ? Colors.green : AppColor.skyblue500,
                ),
              ),
              SizedBox(height: 30.h),
              Text(
                _isSuccess
                    ? 'Thanh toán thành công!'
                    : 'Kiểm tra thanh toán MoMo',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: _isSuccess ? Colors.green : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Text(
                _isSuccess
                    ? 'Gói Premium của bạn đã được kích hoạt thành công.'
                    : 'Nhấn nút bên dưới để đồng bộ trạng thái gói sau khi thanh toán MoMo.',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              if (_paymentRef != null && _paymentRef!.isNotEmpty) ...[
                Text(
                  'Mã giao dịch: $_paymentRef',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              if (_durationDays != null) ...[
                SizedBox(height: 4.h),
                Text(
                  'Thời hạn gói: $_durationDays ngày',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
              SizedBox(height: 30.h),
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
                        _isSuccess
                            ? Symbols.check_circle
                            : Symbols.error_outline,
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
              if (!_isSuccess && !_isLoading) ...[
                SizedBox(
                  width: double.infinity,
                  child: BasicButton(
                    onPressed: _verifyPayment,
                    text: 'Kiểm tra trạng thái gói',
                  ),
                ),
                SizedBox(height: 16.h),
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
              if (_isLoading) ...[
                SizedBox(height: 20.h),
                const AppLoadingIndicator(
                  message: 'Đang kiểm tra trạng thái thanh toán...',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
