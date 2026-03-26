import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sci_fun/common/cubit/is_authorized_cubit.dart';
import 'package:sci_fun/common/entities/user_get_entity.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/common/widget/change_confirm_dialog.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/services/share_prefs_service.dart';
import 'package:sci_fun/core/services/sound_service.dart';
import 'package:sci_fun/core/utils/assets/app_vector.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sci_fun/features/auth/presentation/page/signin/signin_page.dart';
import 'package:sci_fun/features/chat/admin_chat_page.dart';
import 'package:sci_fun/features/chat/chat_connection_config.dart';
import 'package:sci_fun/features/chat/user_chat_page.dart';
import 'package:sci_fun/features/plan/presentation/page/plan_list_page.dart';
import 'package:sci_fun/features/profile/presentation/components/profile/header_profile.dart';
import 'package:sci_fun/features/profile/presentation/cubit/user_cubit.dart';
import 'package:sci_fun/features/profile/presentation/page/about_us/about_us_page.dart';
import 'package:sci_fun/features/profile/presentation/page/change_page/change_infomation_page.dart';
import 'package:sci_fun/features/profile/presentation/page/change_pass/change_pass.dart';
import 'package:sci_fun/features/profile/presentation/page/contact/contact_page.dart';
import 'package:sci_fun/features/profile/presentation/page/guest_sync/guest_sync_procedure_page.dart';
import 'package:sci_fun/features/profile/presentation/page/policy/policy_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final UserCubit _userCubit;

  @override
  void initState() {
    super.initState();
    _userCubit = context.read<UserCubit>();
    _userCubit.getUser(token: sl<SharePrefsService>().getUserData()!);
  }

  Future<void> _openChatSupport() async {
    final apiBase = dotenv.get('BASE_URL').replaceAll(RegExp(r'/+$'), '');
    final isAdmin = await _isCurrentUserAdmin();

    if (!mounted) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => isAdmin
            ? AdminChatPage(
                apiBaseUrl: apiBase,
                wsUrl: wsUrlForEnvironment(),
                getToken: getChatToken,
              )
            : UserChatPage(
                apiBaseUrl: apiBase,
                wsUrl: wsUrlForEnvironment(),
                getToken: getChatToken,
              ),
      ),
    );
  }

  Future<bool> _isCurrentUserAdmin() async {
    final userState = _userCubit.state;
    if (userState is UserLoaded) {
      final role = userState.user.data?.role?.trim().toUpperCase();
      if (role == 'ADMIN') {
        return true;
      }
      if (role != null && role.isNotEmpty) {
        return false;
      }
    }

    final token = await getChatToken();
    if (token == null || token.isEmpty) return false;

    try {
      final parts = token.split('.');
      if (parts.length < 2) return false;
      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final map = jsonDecode(payload);
      if (map is! Map<String, dynamic>) return false;
      final role = map['role']?.toString().trim().toUpperCase();
      return role == 'ADMIN';
    } catch (_) {
      return false;
    }
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

  Future<void> _toggleBackgroundMusic(bool isEnabled) async {
    final prefs = sl<SharePrefsService>();
    await prefs.saveBackgroundMusicEnabled(isEnabled);
    await SoundService.instance.setLoopEnabled(isEnabled);

    if (!isEnabled) return;
    final volume = prefs.getBackgroundMusicVolume();
    await SoundService.instance.playLoop(
      SoundLoopTrack.gameBackground,
      volume: volume,
    );
  }

  Future<void> _setBackgroundMusicVolume(double volume) async {
    await sl<SharePrefsService>().saveBackgroundMusicVolume(volume);
    await SoundService.instance.setLoopVolume(volume);
  }

  Future<void> _openSoundSettings() async {
    final prefs = sl<SharePrefsService>();
    var isBackgroundMusicEnabled = prefs.getBackgroundMusicEnabled();
    var backgroundMusicVolume = prefs.getBackgroundMusicVolume();

    if (!mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final bottomPadding = MediaQuery.of(sheetContext).viewPadding.bottom;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding:
                  EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 14.h + bottomPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(22.r),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 54.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD3D8E1),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Âm thanh',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6FAFF),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColor.skyblue100),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.music_note_rounded,
                          color: AppColor.skyblue600,
                          size: 22.sp,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            'Nhạc nền',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        Switch.adaptive(
                          value: isBackgroundMusicEnabled,
                          activeColor: AppColor.skyblue600,
                          onChanged: (value) {
                            setModalState(() {
                              isBackgroundMusicEnabled = value;
                            });
                            unawaited(_toggleBackgroundMusic(value));
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Âm lượng nhạc nền ${(backgroundMusicVolume * 100).round()}%',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4F4F4F),
                        ),
                  ),
                  Slider(
                    value: backgroundMusicVolume,
                    min: 0,
                    max: 1,
                    divisions: 20,
                    activeColor: AppColor.skyblue500,
                    inactiveColor: AppColor.skyblue100,
                    onChanged: (value) {
                      setModalState(() {
                        backgroundMusicVolume = value;
                      });
                      unawaited(SoundService.instance.setLoopVolume(value));
                    },
                    onChangeEnd: (value) {
                      unawaited(_setBackgroundMusicVolume(value));
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

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
                color: AppColor.skyblue400,
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
                        'Trang cá nhân',
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
                          final user =
                              state is UserLoaded ? state.user.data : null;
                          final remainingDays = user?.daysRemaining ?? 0;
                          final isGuest = user?.isGuest == true;

                          return Column(
                            spacing: 16.h,
                            children: [
                              HeaderProfile(
                                imgUrl: user?.avatar ??
                                    'https://cdn-icons-png.flaticon.com/512/8345/8345328.png',
                                name: user?.fullname ?? 'Khách',
                                remainingPackage:
                                    '${remainingDays < 0 ? 0 : remainingDays} ngày',
                                isGuest: isGuest,
                                onGuestSyncTap: isGuest
                                    ? () {
                                        Navigator.push(
                                          context,
                                          slidePage(
                                            const GuestSyncProcedurePage(),
                                          ),
                                        );
                                      }
                                    : null,
                              ),
                              if (user != null) subscriptionCard(user),
                              if (state is UserError) _errorStateBanner(state),
                              _profileActions(),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileActions() {
    return Column(
      spacing: 12.h,
      children: [
        _sectionTitle('Tài khoản'),
        _itemNavigator(Icons.person, 'Thông tin cá nhân', () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChangeInfomationPage(),
            ),
          );
        }),
        _itemNavigator(Icons.lock, 'Đổi mật khẩu đăng nhập', () {
          Navigator.push(
            context,
            slidePage(const ChangePass()),
          );
        }),
        _itemNavigator(Icons.chat_bubble_outline_rounded, 'Chat hỗ trợ', () {
          _openChatSupport();
        }),
        _itemNavigator(Icons.volume_up_rounded, 'Âm thanh', () {
          _openSoundSettings();
        }),
        _itemNavigator(Icons.shopping_cart, 'Mua gói', () {
          Navigator.push(
            context,
            slidePage(const PlanListPage()),
          );
        }),
        _sectionTitle('Liên hệ'),
        _itemNavigator(Icons.policy_rounded, 'Chính sách', () {
          Navigator.push(
            context,
            slidePage(const PolicyPage(
              plainValue: 'Nội dung chính sách (tạm thời hardcode)',
            )),
          );
        }),
        _itemNavigator(Icons.business_rounded, 'Về chúng tôi', () {
          Navigator.push(
            context,
            slidePage(const AboutUsPage(
              plainValue: 'Thông tin giới thiệu (tạm thời hardcode)',
            )),
          );
        }),
        _itemNavigator(Icons.call_rounded, 'Liên hệ hỗ trợ', () {
          Navigator.push(
            context,
            slidePage(ContactPage(settings: const [])),
          );
        }),
        _logoutButton(),
      ],
    );
  }

  Widget _logoutButton() {
    return GestureDetector(
      onTap: () async {
        final shouldLogout = await showLogoutConfirmDialog(
          context: context,
        );
        if (shouldLogout != true || !context.mounted) {
          return;
        }
        await _logoutAndNavigateToSignin();
      },
      child: Container(
        margin: EdgeInsets.all(6.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded),
            SizedBox(width: 4.w),
            Text(
              'Đăng xuất',
              style: TextStyle(
                fontFamily: 'Baloo2',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorStateBanner(UserError state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Text(
        state.message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.red.shade700,
              fontWeight: FontWeight.w600,
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
                fontWeight: FontWeight.w600,
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
                Icon(icon, color: AppColor.skyblue600),
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
}

String formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';
}

Widget subscriptionCard(UserDataEntity user) {
  final sub = user.subscription;
  final isGuest = user.isGuest == true;
  final remainingDays = user.daysRemaining ?? 0;
  final isExpired = remainingDays <= 0;
  final packageLabel = isGuest ? 'GUEST' : (sub?.tier?.toUpperCase() ?? 'FREE');
  final statusLabel =
      isGuest ? 'Tài khoản khách' : (isExpired ? 'Hết hạn' : 'Đang hoạt động');

  return Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: isExpired
            ? [Colors.grey.shade400, Colors.grey.shade300]
            : [AppColor.skyblue500, AppColor.skyblue300],
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Gói đang sử dụng',
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
                statusLabel,
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
        Text(
          packageLabel,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            const Icon(Icons.calendar_month, color: Colors.white, size: 18),
            SizedBox(width: 6.w),
            Expanded(
              child: Text(
                sub?.currentPeriodEnd == null
                    ? 'Không có ngày hết hạn'
                    : 'Hết hạn: ${formatDate(sub!.currentPeriodEnd!)}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            isExpired
                ? (isGuest ? 'Khách: đã hết hạn' : 'Đã hết hạn')
                : (isGuest
                    ? 'Khách: còn $remainingDays ngày'
                    : 'Còn $remainingDays ngày'),
            style: TextStyle(
              color: isExpired ? Colors.red : AppColor.skyblue600,
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
            ),
          ),
        ),
      ],
    ),
  );
}
