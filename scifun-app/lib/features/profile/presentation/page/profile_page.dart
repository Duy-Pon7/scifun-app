import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thilop10_3004/common/cubit/is_authorized_cubit.dart';
import 'package:thilop10_3004/common/helper/show_alert_dialog.dart';
import 'package:thilop10_3004/common/helper/transition_page.dart';
import 'package:thilop10_3004/core/di/injection.dart';
import 'package:thilop10_3004/core/services/share_prefs_service.dart';
import 'package:thilop10_3004/core/utils/assets/app_vector.dart';
import 'package:thilop10_3004/core/utils/theme/app_color.dart';
import 'package:thilop10_3004/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:thilop10_3004/features/auth/presentation/page/signin/signin_page.dart';
import 'package:thilop10_3004/features/profile/presentation/bloc/user_bloc.dart';
import 'package:thilop10_3004/features/profile/presentation/components/profile/header_profile.dart';
import 'package:thilop10_3004/features/profile/presentation/cubit/faqs_cubit.dart';
import 'package:thilop10_3004/features/profile/presentation/cubit/package_history_cubit.dart';
import 'package:thilop10_3004/features/profile/presentation/cubit/settings_cubit.dart';
import 'package:thilop10_3004/features/profile/presentation/page/about_us/about_us_page.dart';
import 'package:thilop10_3004/features/profile/presentation/page/change_page/change_infomation_page.dart';
import 'package:thilop10_3004/features/profile/presentation/page/contact/contact_page.dart';
import 'package:thilop10_3004/features/profile/presentation/page/faqs/faqs_page.dart';
import 'package:thilop10_3004/features/profile/presentation/page/package/package_history_page.dart';
import 'package:thilop10_3004/features/profile/presentation/page/package/package_page.dart';
import 'package:thilop10_3004/features/profile/presentation/page/policy/policy_page.dart';
import 'package:thilop10_3004/features/profile/presentation/page/change_pass/change_pass.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>()..add(AuthGetSession()),
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
            Positioned(
              top: 0,
              right: 0,
              child: _rightWave(),
            ),
            SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 14.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Trang cá nhân",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20.sp,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16.w),
                      margin: EdgeInsets.symmetric(
                        horizontal: 16.w,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x1AFF0300),
                            blurRadius: 10.r,
                            offset: Offset(0, 2.h),
                          ),
                        ],
                      ),
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          if (state is AuthUserSuccess) {
                            return Column(
                              spacing: 12.h,
                              children: [
                                HeaderProfile(
                                  imgUrl: context.read<AuthBloc>().state
                                          is AuthUserSuccess
                                      ? (context.read<AuthBloc>().state
                                                  as AuthUserSuccess)
                                              .user!
                                              .avatar ??
                                          ""
                                      : 'https://cdn-icons-png.flaticon.com/512/8345/8345328.png',
                                  name: state.user?.fullname ?? "Khách",
                                  remainingPackage: getRemainingDays(
                                      state.user?.package?.endDate),
                                ),
                                Column(
                                  spacing: 12.h,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Tài khoản",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                fontSize: 17.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                        ),
                                      ],
                                    ),
                                    _itemNavigator(
                                        Icons.person, "Thông tin cá nhân", () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BlocProvider.value(
                                            value: context.read<AuthBloc>(),
                                            child: const ChangeInfomationPage(),
                                          ),
                                        ),
                                      ).then((result) {
                                        if (result == true) {
                                          context
                                              .read<AuthBloc>()
                                              .add(AuthGetSession());
                                        }
                                      });
                                    }),
                                    _itemNavigator(
                                      Icons.lock,
                                      "Đổi mật khẩu đăng nhập",
                                      () {
                                        Navigator.push(
                                          context,
                                          slidePage(ChangePass()),
                                        );
                                      },
                                    ),
                                    _itemNavigator(
                                      Icons.article_rounded,
                                      "Gói thành viên",
                                      () {
                                        Navigator.push(
                                          context,
                                          slidePage(PackagePage(
                                              fullname: state.user?.fullname ??
                                                  "Khách",
                                              remainingPackage:
                                                  getRemainingDays(state.user
                                                      ?.package?.endDate))),
                                        );
                                      },
                                    ),
                                    _itemNavigator(
                                      Icons.history,
                                      "Lịch sử mua gói",
                                      () {
                                        Navigator.push(
                                          context,
                                          slidePage(BlocProvider.value(
                                            value: sl<PackageHistoryCubit>(),
                                            child: PackageHistoryPage(),
                                          )),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                BlocBuilder<SettingsCubit, SettingsState>(
                                  builder: (context, state) {
                                    if (state is SettingsLoaded) {
                                      return Column(
                                        spacing: 12.h,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Liên hệ",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                      fontSize: 17.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          _itemNavigator(
                                            Icons.policy_rounded,
                                            "Chính sách",
                                            () {
                                              final settingsState = context
                                                  .read<SettingsCubit>()
                                                  .state;
                                              if (settingsState
                                                  is SettingsLoaded) {
                                                final setting = settingsState
                                                    .newsList
                                                    .firstWhere(
                                                  (e) =>
                                                      e.settingKey == 'policy',
                                                );
                                                Navigator.push(
                                                  context,
                                                  slidePage(PolicyPage(
                                                    plainValue:
                                                        setting.plainValue,
                                                  )),
                                                );
                                              }
                                            },
                                          ),
                                          _itemNavigator(
                                            Icons.business_rounded,
                                            "Về chúng tôi",
                                            () {
                                              final settingsState = context
                                                  .read<SettingsCubit>()
                                                  .state;
                                              if (settingsState
                                                  is SettingsLoaded) {
                                                final setting = settingsState
                                                    .newsList
                                                    .firstWhere(
                                                  (e) =>
                                                      e.settingKey ==
                                                      'introduce',
                                                );
                                                Navigator.push(
                                                  context,
                                                  slidePage(AboutUsPage(
                                                    plainValue:
                                                        setting.plainValue,
                                                  )),
                                                );
                                              }
                                            },
                                          ),
                                          _itemNavigator(
                                            Icons.call_rounded,
                                            "Liên hệ hỗ trợ",
                                            () {
                                              final settingsState = context
                                                  .read<SettingsCubit>()
                                                  .state;

                                              if (settingsState
                                                  is SettingsLoaded) {
                                                // Lọc ra các setting cần dùng
                                                final settings = settingsState
                                                    .newsList
                                                    .where((e) => [
                                                          'email',
                                                          'hotline',
                                                          'address',
                                                          'introduce',
                                                        ].contains(
                                                            e.settingKey))
                                                    .toList();

                                                Navigator.push(
                                                  context,
                                                  slidePage(ContactPage(
                                                      settings: settings)),
                                                );
                                              }
                                            },
                                          ),
                                          BlocBuilder<FaqsCubit, FaqsState>(
                                            builder: (context, state) {
                                              if (state is FaqsLoaded) {
                                                final faqs = state.newsList;
                                                return _itemNavigator(
                                                  Icons.question_mark_rounded,
                                                  "Câu hỏi thường gặp",
                                                  () {
                                                    Navigator.push(
                                                      context,
                                                      slidePage(
                                                          FaqsPage(faqs: faqs)),
                                                    );
                                                  },
                                                );
                                              }
                                              return const SizedBox();
                                            },
                                          ),
                                        ],
                                      );
                                    }
                                    return SizedBox();
                                  },
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showAlertDialog(
                                      context,
                                      () async {
                                        await sl<SharePrefsService>().clear();
                                        sl<IsAuthorizedCubit>().isAuthorized();
                                        resetSingleton();
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (_) => SigninPage()),
                                          (route) => false,
                                        );
                                      },
                                      () {}, // Không làm gì khi cancel
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
                                        Icon(Icons.logout_rounded),
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
                            );
                          }
                          return SizedBox();
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
          border: Border.all(
            color: AppColor.border,
            width: 0.5.w,
          ),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 12.w,
              children: [
                Icon(
                  icon,
                  color: AppColor.primary600,
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18.w,
            )
          ],
        ),
      ),
    );
  }

  SvgPicture _rightWave() {
    return SvgPicture.asset(
      AppVector.rightWave,
      // width: 28.w,
      // height: 28.h,
      // colorFilter: ColorFilter.mode(AppColor.primary500, BlendMode.srcIn),
      fit: BoxFit.cover,
    );
  }

  String getRemainingDays(DateTime? endDate) {
    if (endDate == null) return "0 ngày";

    final now = DateTime.now();
    final difference = endDate.difference(now).inDays;

    // Nếu còn 0 hoặc âm ngày thì xem như hết hạn
    if (difference <= 0) return "Hết hạn";
    return "$difference ngày";
  }
}
