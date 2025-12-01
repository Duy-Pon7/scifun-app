import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sci_fun/features/home/presentation/components/home/background_home.dart';
import 'package:sci_fun/features/home/presentation/components/home/header_home.dart';
import 'package:sci_fun/features/home/presentation/components/home/list_news.dart';
import 'package:sci_fun/features/home/presentation/components/home/list_subjects.dart';
import 'package:sci_fun/features/home/presentation/cubit/news_cubit.dart';
import 'package:sci_fun/features/subject/presentation/cubit/subject_cubit.dart';

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
          create: (context) => sl<AuthBloc>()..add(AuthGetSession()),
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

                final province = 0;
                final ward = 0;

                print("province $province ward $ward");
              } else if (state is AuthFailure) {
                EasyLoading.dismiss();
                EasyLoading.showToast(state.message,
                    toastPosition: EasyLoadingToastPosition.bottom);
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
                  newcontext.read<AuthBloc>().add(AuthGetSession());
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
                        // ListNews(),
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
