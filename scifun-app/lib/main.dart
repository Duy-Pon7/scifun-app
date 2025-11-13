import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:thilop10_3004/common/cubit/is_authorized_cubit.dart';
import 'package:thilop10_3004/core/di/injection.dart';
import 'package:thilop10_3004/core/utils/theme/app_theme.dart';
import 'package:thilop10_3004/features/address/presentation/cubit/address_cubit.dart';
import 'package:thilop10_3004/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:thilop10_3004/features/auth/presentation/page/auth_redirect_page/auth_redirect_page.dart';
import 'package:thilop10_3004/features/auth/presentation/page/signin/signin_page.dart';
import 'package:thilop10_3004/features/home/presentation/cubit/dashboard_cubit.dart';
import 'package:thilop10_3004/features/profile/presentation/bloc/package_bloc.dart';
import 'package:thilop10_3004/features/profile/presentation/bloc/user_bloc.dart';
import 'package:thilop10_3004/features/profile/presentation/cubit/faqs_cubit.dart';
import 'package:thilop10_3004/features/profile/presentation/cubit/settings_cubit.dart';

void main() async {
  // debugPaintSizeEnabled = true;
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
              create: (_) => sl<UserBloc>(),
            ),
            BlocProvider(
              create: (_) => sl<PackageBloc>(),
            ),
            BlocProvider(
              create: (_) => sl<AddressCubit>(),
            ),
            BlocProvider(create: (_) => sl<SettingsCubit>()..getSettings()),
            BlocProvider(create: (_) => sl<FaqsCubit>()..getFaqs()),
            BlocProvider(
                create: (_) => sl<IsAuthorizedCubit>()..isAuthorized()),
            BlocProvider(create: (_) => sl<DashboardCubit>()),
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
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(1.0),
      ),
      child: BlocBuilder<IsAuthorizedCubit, bool>(
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
          title: 'Ôn Thi Lớp 10 MK SCHOOL',
          theme: AppTheme.theme,
          builder: EasyLoading.init(),
          //TODO: Đang test history packages
          home: isAuthorized ? const AuthRedirectPage() : const SigninPage(),
          // home: AddInfomationPage(),
        ),
      ),
    );
  }
}
