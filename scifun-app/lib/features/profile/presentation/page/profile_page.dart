import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sci_fun/common/cubit/is_authorized_cubit.dart';
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
import 'package:sci_fun/features/profile/presentation/page/faqs/faqs_page.dart';
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
                            return Column(
                              spacing: 12.h,
                              children: [
                                HeaderProfile(
                                  imgUrl: state.user.data?.avatar ??
                                      "https://cdn-icons-png.flaticon.com/512/8345/8345328.png",
                                  name: state.user.data?.fullname ?? "Khách",
                                  remainingPackage:
                                      getRemainingDays(DateTime.now()),
                                ),
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
                                      Icons.lock,
                                      "Đổi mật khẩu đăng nhập",
                                      () {
                                        Navigator.push(
                                          context,
                                          slidePage(const ChangePass()),
                                        );
                                      },
                                    ),
                                    _itemNavigator(
                                      Icons.article_rounded,
                                      "Gói thành viên",
                                      () {
                                        // Navigator.push(
                                        //   context,
                                        //   slidePage(PackagePage(
                                        //     fullname:
                                        //         state.user.data?.fullname ??
                                        //             "Khách",
                                        //     remainingPackage: getRemainingDays(
                                        //         DateTime.now()),
                                        //   )),
                                        // );
                                      },
                                    ),
                                    _sectionTitle("Liên hệ"),
                                    _itemNavigator(
                                      Icons.policy_rounded,
                                      "Chính sách",
                                      () {
                                        Navigator.push(
                                          context,
                                          slidePage(const PolicyPage(
                                            plainValue:
                                                "Nội dung chính sách (tạm thời hardcode)",
                                          )),
                                        );
                                      },
                                    ),
                                    _itemNavigator(
                                      Icons.business_rounded,
                                      "Về chúng tôi",
                                      () {
                                        Navigator.push(
                                          context,
                                          slidePage(const AboutUsPage(
                                            plainValue:
                                                "Thông tin giới thiệu (tạm thời hardcode)",
                                          )),
                                        );
                                      },
                                    ),
                                    _itemNavigator(
                                      Icons.call_rounded,
                                      "Liên hệ hỗ trợ",
                                      () {
                                        Navigator.push(
                                          context,
                                          slidePage(ContactPage(
                                            settings: const [],
                                          )),
                                        );
                                      },
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
