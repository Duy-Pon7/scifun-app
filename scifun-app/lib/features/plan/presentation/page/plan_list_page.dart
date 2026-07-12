import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sci_fun/common/cubit/is_authorized_cubit.dart';
import 'package:sci_fun/common/widget/app_empty_state.dart';
import 'package:sci_fun/common/widget/app_loading_indicator.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/widget/change_confirm_dialog.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/services/share_prefs_service.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/plan/domain/entity/checkout_response.dart';
import 'package:sci_fun/features/plan/domain/entity/plan_entity.dart';
import 'package:sci_fun/features/plan/domain/usecase/create_checkout.dart';
import 'package:sci_fun/features/plan/presentation/cubit/plan_cubit.dart';
import 'package:sci_fun/features/profile/presentation/cubit/pro_cubit.dart';
import 'package:sci_fun/features/profile/presentation/cubit/user_cubit.dart';
import 'package:sci_fun/features/profile/presentation/helper/guest_feature_guard.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PlanListPage extends StatefulWidget {
  const PlanListPage({super.key});

  @override
  State<PlanListPage> createState() => _PlanListPageState();
}

class _PlanListPageState extends State<PlanListPage> {
  static const _pendingPaymentRefKey = 'pending_payment_ref';
  static const _pendingDurationDaysKey = 'pending_durationDays';
  static const _lastHandledCallbackKey = 'last_payment_callback_signature';
  static String? _lastHandledCallbackInMemory;
  static final Set<String> _processingCallbacks = <String>{};

  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _uriSub;
  bool _shouldRefreshCallerOnExit = false;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  bool _isPaymentCallbackUri(Uri uri) {
    final scheme = uri.scheme.toLowerCase();
    final host = uri.host.toLowerCase();

    if (scheme != 'myapp' && scheme != 'yourapp') {
      return false;
    }

    return host == 'payment' || host == 'payment-result';
  }

  bool _isPaymentSuccess(Uri uri) {
    final resultCode =
        uri.queryParameters['resultCode'] ?? uri.queryParameters['resultcode'];
    if (resultCode != null) {
      return resultCode == '0';
    }

    final status = uri.queryParameters['status']?.toLowerCase();
    if (status == null) {
      return false;
    }

    return status == '1' ||
        status == 'success' ||
        status == 'succeeded' ||
        status == 'paid';
  }

  String _callbackStatus(Uri uri) {
    final resultCode =
        uri.queryParameters['resultCode'] ?? uri.queryParameters['resultcode'];
    if (resultCode != null) {
      return 'resultCode=$resultCode';
    }
    final status = uri.queryParameters['status'];
    if (status != null) {
      return 'status=$status';
    }
    return 'unknown';
  }

  String _callbackSignature(Uri uri) {
    final requestId =
        uri.queryParameters['requestId'] ?? uri.queryParameters['requestid'];
    if (requestId != null && requestId.isNotEmpty) {
      return 'requestId:$requestId';
    }

    final orderId =
        uri.queryParameters['orderId'] ?? uri.queryParameters['orderid'];
    if (orderId != null && orderId.isNotEmpty) {
      return 'orderId:$orderId';
    }

    final transId =
        uri.queryParameters['transId'] ?? uri.queryParameters['transid'];
    if (transId != null && transId.isNotEmpty) {
      return 'transId:$transId';
    }

    return 'uri:${uri.toString()}';
  }

  Future<bool> _isDuplicateCallback(String signature) async {
    if (signature.isEmpty) return false;
    if (_processingCallbacks.contains(signature)) return true;
    if (_lastHandledCallbackInMemory == signature) return true;

    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_lastHandledCallbackKey);
    if (stored == signature) {
      _lastHandledCallbackInMemory = signature;
      return true;
    }

    return false;
  }

  Future<void> _markCallbackHandled(String signature) async {
    if (signature.isEmpty) return;
    _lastHandledCallbackInMemory = signature;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastHandledCallbackKey, signature);
  }

  Future<void> _showPaymentResultDialog({
    required String title,
    required String message,
  }) async {
    if (!mounted) return;

    await showChangeConfirmDialog(
      context: context,
      titleText: title,
      messageText: message,
      cancelButtonText: 'Đóng',
      confirmButtonText: 'OK',
    );
  }

  Future<void> _clearPendingPayment() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pendingPaymentRefKey);
    await prefs.remove(_pendingDurationDaysKey);

    // Cleanup old keys kept for backward compatibility.
    await prefs.remove('pending_appTransId');
    await prefs.remove('pending_durationDays');
  }

  Future<bool> _refreshPremiumState() async {
    final isAuthorizedCubit = context.read<IsAuthorizedCubit>();
    final proCubit = context.read<ProCubit>();
    final userCubit = context.read<UserCubit>();

    isAuthorizedCubit.isAuthorized();

    final userId = sl<SharePrefsService>().getUserData()?.trim();
    if (userId == null || userId.isEmpty) {
      return false;
    }

    await userCubit.getUser(
      token: userId,
      forceRefresh: true,
    );

    return proCubit.isCheckPro(token: userId);
  }

  Future<void> _popWithResult() async {
    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(_shouldRefreshCallerOnExit);
  }

  Future<void> _handlePaymentCallback(
    Uri uri, {
    required bool isInitialLink,
  }) async {
    if (!_isPaymentCallbackUri(uri)) return;

    final signature = _callbackSignature(uri);
    if (await _isDuplicateCallback(signature)) {
      debugPrint('Skip duplicate MoMo callback: $signature');
      return;
    }

    _processingCallbacks.add(signature);

    try {
      final prefs = await SharedPreferences.getInstance();
      final paymentRef = prefs.getString(_pendingPaymentRefKey) ??
          prefs.getString('pending_appTransId');

      final callbackSource = isInitialLink ? 'Initial link' : 'Callback';
      debugPrint('$callbackSource from MoMo: $uri');

      if (!_isPaymentSuccess(uri)) {
        await _showPaymentResultDialog(
          title: 'Thanh toán chưa thành công',
          message: 'Thanh toán chưa thành công (${_callbackStatus(uri)}).',
        );
        return;
      }

      _shouldRefreshCallerOnExit = true;

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(
            child: AppLoadingIndicator(
              message: 'Đang cập nhật trạng thái thanh toán...',
            ),
          ),
        );
      }

      bool isPro = false;
      try {
        isPro = await _refreshPremiumState();
        await _clearPendingPayment();
      } finally {
        if (mounted) {
          Navigator.of(context).pop();
        }
      }

      final paymentSuffix =
          paymentRef != null && paymentRef.isNotEmpty ? ' ($paymentRef)' : '';

      if (isPro) {
        await _showPaymentResultDialog(
          title: 'Thanh toán thành công',
          message: 'Thanh toán MoMo thành công$paymentSuffix.',
        );
        return;
      }

      await _showPaymentResultDialog(
        title: 'Đã nhận callback MoMo',
        message:
            'Đã nhận callback MoMo$paymentSuffix. Nếu gói chưa cập nhật, chờ 10-30 giây rồi kiểm tra lại.',
      );
    } finally {
      await _finalizePaymentCallback(signature);
    }
  }

  Future<void> _finalizePaymentCallback(String signature) async {
    _processingCallbacks.remove(signature);
    await _markCallbackHandled(signature);
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    _uriSub = _appLinks.uriLinkStream.listen(
      (Uri uri) => _handlePaymentCallback(uri, isInitialLink: false),
      onError: (Object error) {
        debugPrint('Deep link stream error: $error');
      },
    );

    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      await _handlePaymentCallback(initialUri, isInitialLink: true);
    }
  }

  @override
  void dispose() {
    _uriSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PlanCubit>()..getPlans(),
      child: PopScope<bool>(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            return;
          }

          _popWithResult();
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF6F7FB),
          appBar: BasicAppbar(
            title: 'Gói dịch vụ',
            onBackPress: () {
              _popWithResult();
            },
          ),
          body: Padding(
            padding: EdgeInsets.all(16.w),
            child: BlocBuilder<PlanCubit, PlanState>(
              builder: (context, state) {
                if (state is PlanLoading) {
                  return const Center(
                    child: AppLoadingIndicator(
                      message: 'Đang tải gói dịch vụ...',
                    ),
                  );
                }

                if (state is PlansLoaded) {
                  final plans = state.plans;
                  if (plans.isEmpty) {
                    return const Center(
                      child: AppEmptyState(message: 'Không có gói nào'),
                    );
                  }

                  return ListView.separated(
                    itemCount: plans.length,
                    separatorBuilder: (_, __) => SizedBox(height: 16.h),
                    itemBuilder: (context, index) {
                      return _PlanCard(plan: plans[index]);
                    },
                  );
                }

                if (state is PlanError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(fontSize: 18.sp, color: Colors.red),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  static const _pendingPaymentRefKey = 'pending_payment_ref';
  static const _pendingDurationDaysKey = 'pending_durationDays';

  final Plan plan;

  const _PlanCard({required this.plan});

  Future<void> _savePendingPayment(CheckoutResponse response) async {
    final prefs = await SharedPreferences.getInstance();

    final paymentRef = response.paymentRef;
    if (paymentRef.isNotEmpty) {
      await prefs.setString(_pendingPaymentRefKey, paymentRef);

      // Keep old key for backward compatibility with older screens.
      await prefs.setString('pending_appTransId', paymentRef);
    }

    await prefs.setInt(_pendingDurationDaysKey, response.durationDays);
    await prefs.setInt('pending_durationDays', response.durationDays);
  }

  Future<bool> _launchPayment(CheckoutResponse response) async {
    final preferredUrl = response.preferredLaunchUrl;
    final fallbackUrl = response.payUrl;

    if (preferredUrl.isNotEmpty && await canLaunchUrlString(preferredUrl)) {
      final launchedPreferred = await launchUrlString(
        preferredUrl,
        mode: LaunchMode.externalApplication,
      );
      if (launchedPreferred) return true;
    }

    if (fallbackUrl.isNotEmpty && fallbackUrl != preferredUrl) {
      if (await canLaunchUrlString(fallbackUrl)) {
        return launchUrlString(
          fallbackUrl,
          mode: LaunchMode.externalApplication,
        );
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  plan.name ?? 'Gói dịch vụ',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _DurationBadge(days: plan.durationDays),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            plan.price != null
                ? '${_formatPrice(plan.price!)} VND'
                : 'Miễn phí',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Truy cập đầy đủ các tính năng học tập và nội dung nâng cao.',
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            height: 44.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                backgroundColor: AppColor.skyblue400,
              ),
              onPressed: () async {
                final canAccess = await guardGuestRestrictedFeature(context);
                if (!canAccess || !context.mounted) {
                  return;
                }

                final price = plan.price ?? 0;
                final durationDays = plan.durationDays ?? 7;

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(
                    child: AppLoadingIndicator(
                      message: 'Đang tạo thanh toán...',
                    ),
                  ),
                );

                final res = await sl<CreateCheckout>().call(
                  CreateCheckoutParams(
                      price: price, durationDays: durationDays),
                );

                if (context.mounted) {
                  Navigator.of(context).pop();
                }

                res.fold(
                  (failure) => ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(failure.message))),
                  (checkoutResponse) async {
                    try {
                      await _savePendingPayment(checkoutResponse);

                      final launched = await _launchPayment(checkoutResponse);
                      if (!launched && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Không thể mở đường dẫn thanh toán MoMo'),
                          ),
                        );
                      }
                    } catch (e) {
                      debugPrint('Error launching payment: $e');
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Không thể mở đường dẫn thanh toán MoMo'),
                          ),
                        );
                      }
                    }
                  },
                );
              },
              child: Text(
                'Mua ngay',
                style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
        );
  }
}

class _DurationBadge extends StatelessWidget {
  final int? days;

  const _DurationBadge({this.days});

  @override
  Widget build(BuildContext context) {
    final text = days != null ? '$days ngày' : 'Không giới hạn';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.blue,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
