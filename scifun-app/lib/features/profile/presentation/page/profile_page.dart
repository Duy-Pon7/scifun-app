import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sci_fun/common/cubit/is_authorized_cubit.dart';
import 'package:sci_fun/common/entities/user_get_entity.dart';
import 'package:sci_fun/common/helper/show_alert_dialog.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/services/share_prefs_service.dart';
import 'package:sci_fun/core/utils/assets/app_vector.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sci_fun/features/auth/presentation/page/signin/signin_page.dart';
import 'package:sci_fun/features/profile/presentation/components/profile/header_profile.dart';
import 'package:sci_fun/features/profile/presentation/cubit/user_cubit.dart';
import 'package:sci_fun/features/profile/presentation/page/about_us/about_us_page.dart';
import 'package:sci_fun/features/profile/presentation/page/change_page/change_infomation_page.dart';
import 'package:sci_fun/features/profile/presentation/page/contact/contact_page.dart';
import 'package:sci_fun/features/profile/presentation/page/policy/policy_page.dart';
import 'package:sci_fun/features/profile/presentation/page/change_pass/change_pass.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<AuthBloc>()..add(AuthGetSession()),
        ),
        BlocProvider(
          create: (_) {
            final token = sl<SharePrefsService>().getUserData();
            if (token != null) {
              return sl<UserCubit>()..getUser(token: token);
            }
            return sl<UserCubit>();
          },
        ),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: ScreenUtil().screenHeight * 0.3,
              decoration: BoxDecoration(
                color: AppColor.primary400,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(ScreenUtil().screenHeight * 0.09),
                  bottomRight:
                      Radius.circular(ScreenUtil().screenHeight * 0.09),
                ),
              ),
            ),
            Positioned(top: 0, right: 0, child: _rightWave()),
            SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      child: Text(
                        "Trang cá nhân",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 20.sp,
                            ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16.w),
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x1AFF0300),
                            blurRadius: 10.r,
                            offset: Offset(0, 2.h),
                          ),
                        ],
                      ),
                      child: BlocBuilder<UserCubit, UserState>(
                        builder: (context, state) {
                          if (state is UserLoaded) {
                            final user = state.user.data;

                            return Column(
                              spacing: 16.h,
                              children: [
                                HeaderProfile(
                                  imgUrl: user?.avatar ??
                                      "https://cdn-icons-png.flaticon.com/512/8345/8345328.png",
                                  name: user?.fullname ?? "Khách",
                                  remainingPackage: user?.subscription
                                              ?.currentPeriodEnd ==
                                          null
                                      ? "0 ngày"
                                      : getRemainingDays(
                                          user!.subscription!.currentPeriodEnd),
                                ),

                                /// ===== GÓI ĐANG DÙNG =====
                                if (user != null) subscriptionCard(user),

                                Column(
                                  spacing: 12.h,
                                  children: [
                                    _sectionTitle("Tài khoản"),
                                    _itemNavigator(
                                        Icons.person, "Thông tin cá nhân", () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ChangeInfomationPage(),
                                        ),
                                      );
                                    }),
                                    _itemNavigator(
                                        Icons.lock, "Đổi mật khẩu đăng nhập",
                                        () {
                                      Navigator.push(
                                        context,
                                        slidePage(const ChangePass()),
                                      );
                                    }),
                                    _sectionTitle("Liên hệ"),
                                    _itemNavigator(
                                        Icons.policy_rounded, "Chính sách", () {
                                      Navigator.push(
                                        context,
                                        slidePage(const PolicyPage(
                                          plainValue:
                                              "Nội dung chính sách (tạm thời hardcode)",
                                        )),
                                      );
                                    }),
                                    _itemNavigator(
                                        Icons.business_rounded, "Về chúng tôi",
                                        () {
                                      Navigator.push(
                                        context,
                                        slidePage(const AboutUsPage(
                                          plainValue:
                                              "Thông tin giới thiệu (tạm thời hardcode)",
                                        )),
                                      );
                                    }),
                                    _itemNavigator(
                                        Icons.call_rounded, "Liên hệ hỗ trợ",
                                        () {
                                      Navigator.push(
                                        context,
                                        slidePage(
                                            ContactPage(settings: const [])),
                                      );
                                    }),
                                    GestureDetector(
                                      onTap: () {
                                        showAlertDialog(
                                          context,
                                          () async {
                                            await sl<SharePrefsService>()
                                                .clear();
                                            sl<IsAuthorizedCubit>()
                                                .isAuthorized();
                                            resetSingleton();
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const SigninPage()),
                                              (route) => false,
                                            );
                                          },
                                          () {},
                                          "Xác nhận đăng xuất",
                                          "Bạn có chắc chắn muốn đăng xuất không?",
                                          "Đăng xuất",
                                          "Hủy",
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(6.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.logout_rounded),
                                            SizedBox(width: 4.w),
                                            Text(
                                              "Đăng xuất",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }

                          // Nếu chưa có user => hiển thị nút đăng xuất
                          return GestureDetector(
                            onTap: () {
                              showAlertDialog(
                                context,
                                () async {
                                  await sl<SharePrefsService>().clear();
                                  sl<IsAuthorizedCubit>().isAuthorized();
                                  resetSingleton();
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (_) => const SigninPage()),
                                    (route) => false,
                                  );
                                },
                                () {},
                                "Xác nhận đăng xuất",
                                "Bạn có chắc chắn muốn đăng xuất không?",
                                "Đăng xuất",
                                "Hủy",
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.all(6.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.logout_rounded),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "Đăng xuất",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 17.sp,
                fontWeight: FontWeight.w400,
              ),
        ),
      ],
    );
  }

  Widget _itemNavigator(
    IconData icon,
    String title,
    void Function()? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.border, width: 0.5.w),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 12.w,
              children: [
                Icon(icon, color: AppColor.primary600),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 18.w),
          ],
        ),
      ),
    );
  }

  SvgPicture _rightWave() {
    return SvgPicture.asset(AppVector.rightWave, fit: BoxFit.cover);
  }

  String getRemainingDays(DateTime? endDate) {
    if (endDate == null) return "0 ngày";
    final now = DateTime.now();
    final difference = endDate.difference(now).inDays;
    return difference <= 0 ? "Hết hạn" : "$difference ngày";
  }
}

String formatDate(DateTime date) {
  return "${date.day.toString().padLeft(2, '0')}/"
      "${date.month.toString().padLeft(2, '0')}/"
      "${date.year}";
}

Widget subscriptionCard(UserDataEntity user) {
  final sub = user.subscription;

  final bool isExpired = sub?.currentPeriodEnd == null
      ? true
      : sub!.currentPeriodEnd!.isBefore(DateTime.now());

  final int remainingDays = sub?.currentPeriodEnd == null
      ? 0
      : sub!.currentPeriodEnd!.difference(DateTime.now()).inDays;

  return Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: isExpired
            ? [Colors.grey.shade400, Colors.grey.shade300]
            : [AppColor.primary500, AppColor.primary300],
      ),
      borderRadius: BorderRadius.circular(20.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8.r,
          offset: Offset(0, 4.h),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Gói đang sử dụng",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                isExpired ? "Hết hạn" : "Đang hoạt động",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        /// Package name
        Text(
          sub?.tier?.toUpperCase() ?? "NODE",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 8.h),

        /// Expire date
        Row(
          children: [
            const Icon(Icons.calendar_month, color: Colors.white, size: 18),
            SizedBox(width: 6.w),
            Text(
              sub?.currentPeriodEnd == null
                  ? "Không có ngày hết hạn"
                  : "Hết hạn: ${formatDate(sub!.currentPeriodEnd!)}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        /// Remaining days badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            isExpired ? "Đã hết hạn" : "Còn $remainingDays ngày",
            style: TextStyle(
              color: isExpired ? Colors.red : AppColor.primary600,
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
            ),
          ),
        ),
      ],
    ),
  );
}
