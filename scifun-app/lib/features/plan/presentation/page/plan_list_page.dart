import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/plan/presentation/cubit/plan_cubit.dart';
import 'package:sci_fun/features/plan/domain/entity/plan_entity.dart';
import 'package:sci_fun/features/plan/domain/usecase/create_checkout.dart';
import 'package:sci_fun/features/plan/domain/usecase/verify_payment.dart';
import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sci_fun/features/plan/presentation/page/verify_payment_page.dart';

class PlanListPage extends StatefulWidget {
  const PlanListPage({super.key});

  @override
  State<PlanListPage> createState() => _PlanListPageState();
}

class _PlanListPageState extends State<PlanListPage> {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _uriSub;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  void _initDeepLinks() async {
    _appLinks = AppLinks();

    // Khi app mở lại từ ZaloPay
    _uriSub = _appLinks.uriLinkStream.listen((Uri uri) async {
      if (uri.scheme == "myapp" && uri.host == "payment") {
        print("Return from ZaloPay: $uri");

        final status = uri.queryParameters["status"];

        // Lấy appTransId và durationDays đã lưu từ SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final appTransId = prefs.getString('pending_appTransId');
        final durationDays = prefs.getInt('pending_durationDays');

        if (appTransId != null && durationDays != null) {
          // show loading
          if (mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          }

          final res = await sl<VerifyPayment>().call(VerifyPaymentParams(
              appTransId: appTransId, durationDays: durationDays));

          // close loading
          if (mounted) Navigator.of(context).pop();

          // Xóa dữ liệu pending sau khi xác thực
          await prefs.remove('pending_appTransId');
          await prefs.remove('pending_durationDays');

          res.fold(
            (failure) => ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(failure.message))),
            (message) async {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Thanh toán xác thực: $message')),
              );
            },
          );
        } else {
          // fallback: show status only
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Kết quả thanh toán: status=$status')),
            );
          }
        }
      }
    });

    // App được mở từ trạng thái terminated
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null &&
        initialUri.scheme == "myapp" &&
        initialUri.host == "payment") {
      print("Initial link from ZaloPay: $initialUri");

      final status = initialUri.queryParameters["status"];

      // Lấy appTransId và durationDays đã lưu từ SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final appTransId = prefs.getString('pending_appTransId');
      final durationDays = prefs.getInt('pending_durationDays');

      if (appTransId != null && durationDays != null) {
        // show loading
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        }

        final res = await sl<VerifyPayment>().call(VerifyPaymentParams(
            appTransId: appTransId, durationDays: durationDays));

        // close loading
        if (mounted) Navigator.of(context).pop();

        // Xóa dữ liệu pending sau khi xác thực
        await prefs.remove('pending_appTransId');
        await prefs.remove('pending_durationDays');

        res.fold(
          (failure) => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(failure.message))),
          (message) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Initial link: thanh toán xác thực: $message')),
          ),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Initial link: status=$status')),
          );
        }
      }
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
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        appBar: const BasicAppbar(
          title: 'Gói dịch vụ',
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const VerifyPaymentPage(),
              ),
            );
          },
          backgroundColor: AppColor.primary500,
          icon: const Icon(Icons.verified_outlined, color: Colors.white),
          label: const Text(
            'Xác nhận thanh toán',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: BlocBuilder<PlanCubit, PlanState>(
            builder: (context, state) {
              if (state is PlanLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is PlansLoaded) {
                final plans = state.plans;
                if (plans.isEmpty) {
                  return const Center(child: Text('Không có gói nào'));
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
                    style: TextStyle(fontSize: 14.sp, color: Colors.red),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final Plan plan;

  const _PlanCard({required this.plan});

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
          /// Header
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

          /// Price
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

          /// Description (placeholder)
          Text(
            'Truy cập đầy đủ các tính năng học tập và nội dung nâng cao.',
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey[600],
            ),
          ),

          SizedBox(height: 16.h),

          /// Button
          SizedBox(
            width: double.infinity,
            height: 44.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                backgroundColor: AppColor.primary400,
              ),
              onPressed: () async {
                final price = plan.price ?? 0;
                final durationDays = plan.durationDays ?? 7;

                // show loading
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );

                final res = await sl<CreateCheckout>().call(
                    CreateCheckoutParams(
                        price: price, durationDays: durationDays));

                // close loading
                Navigator.of(context).pop();

                res.fold(
                  (failure) => ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(failure.message))),
                  (checkoutResponse) async {
                    try {
                      // Lưu appTransId và durationDays vào SharedPreferences
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString(
                          'pending_appTransId', checkoutResponse.appTransId);
                      await prefs.setInt('pending_durationDays',
                          checkoutResponse.durationDays);

                      final payUrl = checkoutResponse.payUrl;

                      // Debug: in ra payUrl để kiểm tra
                      print("PayUrl from server: $payUrl");
                      print("AppTransId: ${checkoutResponse.appTransId}");
                      print("DurationDays: ${checkoutResponse.durationDays}");

                      // Thử mở app ZaloPay Sandbox trước
                      // ZaloPay Sandbox có scheme: zalopay-sandbox-ca://
                      // ZaloPay production có scheme: zalopay://
                      final zaloPaySandboxUrl = payUrl.replaceFirst(
                          'https://', 'zalopay-sandbox-ca://');

                      bool launched = false;
                      if (await canLaunchUrlString(zaloPaySandboxUrl)) {
                        launched = await launchUrlString(zaloPaySandboxUrl,
                            mode: LaunchMode.externalApplication);
                        print("Launched ZaloPay Sandbox app: $launched");
                      }

                      // Nếu không mở được app ZaloPay, fallback mở trình duyệt
                      if (!launched) {
                        print("Fallback to browser: $payUrl");
                        await launchUrlString(payUrl,
                            mode: LaunchMode.externalApplication);
                      }
                    } catch (e) {
                      print("Error launching payment: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Không thể mở đường dẫn thanh toán')),
                      );
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
          )
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
          fontSize: 12.sp,
          color: Colors.blue,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
