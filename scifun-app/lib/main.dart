import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/app_loading_indicator.dart';
import 'package:sci_fun/common/cubit/is_authorized_cubit.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/services/share_prefs_service.dart';
import 'package:sci_fun/core/services/sound_service.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/core/utils/theme/app_theme.dart';
import 'package:sci_fun/features/analytics/presentation/cubits/progress_cubit.dart';
import 'package:sci_fun/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sci_fun/features/auth/presentation/page/signin/signin_page.dart';
import 'package:sci_fun/features/home/presentation/cubit/dashboard_cubit.dart';
import 'package:sci_fun/features/home/presentation/page/dashboard_page.dart';
import 'package:sci_fun/features/profile/presentation/bloc/package_bloc.dart';
import 'package:sci_fun/features/profile/presentation/cubit/pro_cubit.dart';
import 'package:sci_fun/features/profile/presentation/cubit/user_cubit.dart';
import 'package:sci_fun/features/quizz/presentation/cubit/quizz_cubit.dart';
import 'package:sci_fun/features/subject/presentation/cubit/subject_cubit.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await initializeDependencies();
  _configureEasyLoading();

  runApp(
    ScreenUtilInit(
      designSize: const Size(473, 932),
      minTextAdapt: true,
      child: DevicePreview(
        enabled: false,
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: sl<AuthBloc>()),
            BlocProvider.value(value: sl<UserCubit>()),
            BlocProvider.value(value: sl<ProCubit>()),
            BlocProvider.value(value: sl<PackageBloc>()),
            BlocProvider.value(value: sl<IsAuthorizedCubit>()..isAuthorized()),
            BlocProvider.value(value: sl<DashboardCubit>()),
            BlocProvider(create: (context) => sl<QuizzCubit>()),
            BlocProvider(create: (_) => sl<SubjectCubit>()),
            BlocProvider.value(value: sl<ProgressCubit>()),
          ],
          child: const MyApp(),
        ),
      ),
    ),
  );

  WidgetsBinding.instance.addPostFrameCallback((_) {
    unawaited(_bootstrapSound());
  });
}

void _configureEasyLoading() {
  EasyLoading.instance
    ..indicatorWidget = const AppLoadingIndicator(size: 120, message: '')
    ..maskType = EasyLoadingMaskType.black
    ..maskColor = Colors.black.withValues(alpha: 0.45)
    ..userInteractions = false
    ..dismissOnTap = false;
}

Future<void> _bootstrapSound() async {
  try {
    final prefs = sl<SharePrefsService>();
    final isBackgroundMusicEnabled = prefs.getBackgroundMusicEnabled();
    final backgroundMusicVolume = prefs.getBackgroundMusicVolume();

    await SoundService.instance.init();
    await SoundService.instance.setLoopVolume(backgroundMusicVolume);
    await SoundService.instance.setLoopEnabled(isBackgroundMusicEnabled);
    await SoundService.instance.playLoop(
      SoundLoopTrack.gameBackground,
      volume: backgroundMusicVolume,
    );
  } catch (_) {
    // Continue app startup even if background music cannot start.
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(SoundService.instance.resumeLoop());
      return;
    }

    unawaited(SoundService.instance.pauseLoop());
  }

  void _unlockAudioAfterUserGesture() {
    unawaited(SoundService.instance.registerUserGesture());
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppColor.themeNotifier,
      builder: (context, _, __) {
        return BlocBuilder<IsAuthorizedCubit, bool>(
          builder: (context, isAuthorized) {
            return Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: (_) => _unlockAudioAfterUserGesture(),
              child: MaterialApp(
                locale: const Locale('vi'),
                supportedLocales: const [
                  Locale('vi'),
                  Locale('en'),
                ],
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                debugShowCheckedModeBanner: false,
                title: 'Sci Fun',
                theme: AppTheme.theme,
                builder: EasyLoading.init(),
                home: isAuthorized ? DashboardPage() : const SigninPage(),
              ),
            );
          },
        );
      },
    );
  }
}
