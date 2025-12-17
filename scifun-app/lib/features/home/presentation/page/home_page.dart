import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/services/share_prefs_service.dart';
import 'package:sci_fun/core/services/ws_bootstrap.dart';
import 'package:sci_fun/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sci_fun/features/home/presentation/components/home/background_home.dart';
import 'package:sci_fun/features/home/presentation/components/home/header_home.dart';
import 'package:sci_fun/features/home/presentation/components/home/list_subjects.dart';
import 'package:sci_fun/features/home/presentation/cubit/news_cubit.dart';
import 'package:sci_fun/features/home/presentation/widget/comment_page.dart';
import 'package:sci_fun/features/profile/presentation/cubit/user_cubit.dart';
import 'package:sci_fun/features/quizz/presentation/pages/trend_quizzes_page.dart';
import 'package:sci_fun/features/subject/presentation/cubit/subject_cubit.dart';

String wsUrlForEnvironment({int port = 5000}) {
  if (kIsWeb)
    return 'wss://localhost:$port/ws'; // web can use localhost and wss if server has cert
  if (Platform.isAndroid)
    return 'ws://10.0.2.2:$port/ws'; // Android emulator -> host machine
  if (Platform.isIOS)
    return 'ws://localhost:$port/ws'; // iOS simulator can use localhost
  return 'ws://localhost:$port/ws';
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Check if user has token before calling AuthGetSession
    final hasToken = sl<SharePrefsService>().getAuthToken() != null;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final authBloc = sl<AuthBloc>();
            if (hasToken) {
              authBloc.add(AuthGetSession());
            }
            return authBloc;
          },
        ),
        BlocProvider(
          create: (_) {
            final token = sl<SharePrefsService>().getUserData();
            if (token != null) {
              print("Creating UserCubit with token: $token");
              return sl<UserCubit>()..getUser(token: token);
            }
            return sl<UserCubit>();
          },
        ),
        BlocProvider(
          create: (context) => sl<NewsCubit>()..getNews(),
        ),
        BlocProvider(
          create: (context) => sl<SubjectCubit>()..getSubjects(searchQuery: ""),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthUserSuccess) {
                EasyLoading.dismiss();
              } else if (state is AuthFailure) {
                EasyLoading.dismiss();
                // Không hiển thị toast error nếu getSession fail vì user có thể chưa login
                print("AuthBloc Error: ${state.message}");
              } else {
                EasyLoading.dismiss();
              }
            },
          ),
          BlocListener<SubjectCubit, SubjectState>(
            listener: (context, state) {
              if (state is SubjectsLoaded) {
                EasyLoading.dismiss();
              } else if (state is SubjectError) {
                EasyLoading.dismiss();
                EasyLoading.showToast(state.message,
                    toastPosition: EasyLoadingToastPosition.bottom);
              } else {
                EasyLoading.dismiss();
              }
            },
          ),
          BlocListener<NewsCubit, NewsState>(
            listener: (context, state) {
              if (state is NewsLoading) {
                EasyLoading.show(
                  status: 'Đang tải',
                  maskType: EasyLoadingMaskType.black,
                );
              } else if (state is NewsLoaded) {
                EasyLoading.dismiss();
              } else if (state is NewsError) {
                EasyLoading.dismiss();
                EasyLoading.showToast(
                  state.message,
                  toastPosition: EasyLoadingToastPosition.bottom,
                );
              }
            },
          ),
        ],
        child: BackgroundHome(
          child: SafeArea(
            child: Builder(builder: (newcontext) {
              return RefreshIndicator(
                onRefresh: () async {
                  newcontext.read<NewsCubit>().getNews();
                  newcontext.read<SubjectCubit>().getSubjects(searchQuery: "");
                  if (hasToken) {
                    newcontext.read<AuthBloc>().add(AuthGetSession());
                  }
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      spacing: 16.h,
                      children: [
                        HeaderHome(),
                        ListSubjects(),
                        TrendQuizzesList(),
                        CommentPage(),
                        WsBootstrap(
                          wsUrl: wsUrlForEnvironment(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
