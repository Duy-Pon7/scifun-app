import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/services/share_prefs_service.dart';
import 'package:sci_fun/core/services/ws_bootstrap.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sci_fun/features/chat/user_chat_page.dart';
import 'package:sci_fun/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sci_fun/features/home/presentation/components/home/background_home.dart';
import 'package:sci_fun/features/home/presentation/components/home/header_home.dart';
import 'package:sci_fun/features/home/presentation/components/home/list_subjects.dart';
import 'package:sci_fun/features/home/presentation/cubit/news_cubit.dart';
import 'package:sci_fun/features/comment/presentation/pages/comment_page.dart';
import 'package:sci_fun/features/profile/presentation/cubit/user_cubit.dart';
import 'package:sci_fun/features/quizz/presentation/pages/trend_quizzes_page.dart';
import 'package:sci_fun/features/subject/presentation/cubit/subject_cubit.dart';

String wsUrlForEnvironment({int port = 5000}) {
  if (kIsWeb) {
    return 'ws://java-app-9trd.onrender.com/ws'; // web can use localhost and wss if server has cert
  }
  if (Platform.isAndroid) {
    return 'ws://java-app-9trd.onrender.com/ws'; // Android emulator -> host machine
  }
  if (Platform.isIOS) {
    return 'ws://java-app-9trd.onrender.com/ws'; // iOS simulator can use localhost
  }
  return 'ws://java-app-9trd.onrender.com/ws';
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

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final token = sl<SharePrefsService>().getUserData();
            if (token != null) {
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
      child: Scaffold(
        body: MultiBlocListener(
          listeners: [
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                // When a user logs in or session is refreshed, reload user info
                if (state is AuthUserSuccess || state is AuthUserLoginSuccess) {
                  EasyLoading.dismiss();
                  final token = sl<SharePrefsService>().getUserData();
                  if (token != null && token.isNotEmpty) {
                    sl<UserCubit>().getUser(token: token);
                  }
                } else if (state is AuthFailure) {
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
          ],
          child: BackgroundHome(
            child: SafeArea(
              child: Builder(builder: (newcontext) {
                return RefreshIndicator(
                  onRefresh: () async {
                    newcontext.read<NewsCubit>().getNews();
                    newcontext
                        .read<SubjectCubit>()
                        .getSubjects(searchQuery: "");
                    newcontext.read<AuthBloc>().add(AuthGetSession());
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 16.w,
                        right: 16.w,
                        top: 16.w,
                        bottom: MediaQuery.of(newcontext).padding.bottom + 96.h,
                      ),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Prepare api base and token getter
            final apiBase =
                dotenv.get('BASE_URL').replaceAll(RegExp(r'/+$'), '');
            Future<String?> getToken() async {
              try {
                final t = sl<SharePrefsService>().getAuthToken();
                if (t != null && t.isNotEmpty) return t;
              } catch (_) {}
              final storage = const FlutterSecureStorage();
              return await storage.read(key: 'access_token');
            }

            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => UserChatPage(
                apiBaseUrl: apiBase,
                wsUrl: wsUrlForEnvironment(),
                getToken: getToken,
              ),
            ));
          },
          tooltip: 'Chat',
          child: const Icon(Icons.chat),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
