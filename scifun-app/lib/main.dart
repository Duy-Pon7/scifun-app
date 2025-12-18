import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:sci_fun/common/cubit/is_authorized_cubit.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/utils/theme/app_theme.dart';
import 'package:sci_fun/features/address/presentation/cubit/address_cubit.dart';
import 'package:sci_fun/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sci_fun/features/auth/presentation/page/signin/signin_page.dart';
import 'package:sci_fun/features/home/presentation/cubit/dashboard_cubit.dart';
import 'package:sci_fun/features/home/presentation/page/dashboard_page.dart';
import 'package:sci_fun/features/leaderboards/presentation/cubit/leaderboards_cubit.dart';
import 'package:sci_fun/features/profile/presentation/bloc/package_bloc.dart';
import 'package:sci_fun/features/profile/presentation/cubit/user_cubit.dart';
import 'package:sci_fun/features/quizz/presentation/cubit/quizz_cubit.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await initializeDependencies();
  await TeXRenderingServer.start();
  runApp(
    ScreenUtilInit(
      designSize: const Size(473, 932),
      minTextAdapt: true,
      child: DevicePreview(
        enabled: false,
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => sl<AuthBloc>(),
            ),
            BlocProvider(
              create: (_) => sl<UserCubit>(),
            ),
            BlocProvider(
              create: (_) => sl<PackageBloc>(),
            ),
            BlocProvider(
              create: (_) => sl<AddressCubit>(),
            ),
            BlocProvider(
                create: (_) => sl<IsAuthorizedCubit>()..isAuthorized()),
            BlocProvider(create: (_) => sl<DashboardCubit>()),
            BlocProvider(create: (_) => sl<LeaderboardsCubit>()),
            BlocProvider(
              create: (context) => sl<QuizzCubit>(),
            )
          ],
          child: MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IsAuthorizedCubit, bool>(
      builder: (context, isAuthorized) => MaterialApp(
        locale: const Locale('vi'),
        supportedLocales: const [
          Locale('vi'), // Tiếng Việt
          Locale('en'), // Tiếng Anh (tuỳ chọn)
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
        // home: AddInfomationPage(),
      ),
    );
  }
}
