import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/services/share_prefs_service.dart';
import 'package:sci_fun/core/services/ws_bootstrap.dart';
import 'package:sci_fun/core/utils/subject_theme_helper.dart';
import 'package:sci_fun/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sci_fun/features/chat/chat_connection_config.dart';
import 'package:sci_fun/features/home/presentation/components/home/background_home.dart';
import 'package:sci_fun/features/home/presentation/components/home/header_home.dart';
import 'package:sci_fun/features/home/presentation/components/home/list_subjects.dart';
import 'package:sci_fun/features/home/presentation/cubit/news_cubit.dart';
import 'package:sci_fun/features/comment/presentation/pages/comment_page.dart';
import 'package:sci_fun/features/profile/presentation/cubit/user_cubit.dart';
import 'package:sci_fun/features/quizz/presentation/pages/trend_quizzes_page.dart';
import 'package:sci_fun/common/cubit/pagination_cubit.dart';
import 'package:sci_fun/features/subject/domain/entity/subject_entity.dart';
import 'package:sci_fun/features/subject/presentation/cubit/subject_cubit.dart';
import 'package:sci_fun/features/subject/presentation/page/change_subject_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  String _selectedSubjectId = '';
  String _selectedSubjectName = '';

  @override
  void initState() {
    super.initState();
    _loadSelectedSubjectFromPrefs();
  }

  void _loadSelectedSubjectFromPrefs() {
    final prefs = sl<SharePrefsService>();
    final savedId = (prefs.getSelectedSubjectId() ?? '').trim();
    final savedName = (prefs.getSelectedSubjectName() ?? '').trim();

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedSubjectId = savedId;
      _selectedSubjectName = savedName;
    });
  }

  void _saveAndApplySelectedSubject({
    required String subjectId,
    required String subjectName,
  }) {
    final normalizedId = subjectId.trim();
    if (normalizedId.isEmpty) {
      return;
    }

    final normalizedName =
        subjectName.trim().isEmpty ? 'Vật lý' : subjectName.trim();

    if (_selectedSubjectId == normalizedId &&
        _selectedSubjectName == normalizedName) {
      return;
    }

    sl<SharePrefsService>().saveSelectedSubject(
      subjectId: normalizedId,
      subjectName: normalizedName,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedSubjectId = normalizedId;
      _selectedSubjectName = normalizedName;
    });
  }

  void _syncSelectedSubjectFromServer(List<SubjectEntity> subjects) {
    if (subjects.isEmpty) {
      return;
    }

    final prefs = sl<SharePrefsService>();
    final savedId = (prefs.getSelectedSubjectId() ?? '').trim();
    final savedName = (prefs.getSelectedSubjectName() ?? '').trim();

    if (savedId.isNotEmpty) {
      String resolvedName = savedName;

      if (resolvedName.isEmpty) {
        for (final subject in subjects) {
          if ((subject.id ?? '') == savedId) {
            resolvedName = (subject.name ?? '').trim();
            break;
          }
        }
      }

      _saveAndApplySelectedSubject(
        subjectId: savedId,
        subjectName: resolvedName,
      );
      return;
    }

    SubjectEntity? defaultSubject;
    for (final subject in subjects) {
      if ((subject.id ?? '').isEmpty) {
        continue;
      }
      if (SubjectThemeHelper.isPhysics(subject.name)) {
        defaultSubject = subject;
        break;
      }
    }

    if (defaultSubject == null) {
      for (final subject in subjects) {
        if ((subject.id ?? '').isNotEmpty) {
          defaultSubject = subject;
          break;
        }
      }
    }

    if (defaultSubject == null || (defaultSubject.id ?? '').isEmpty) {
      return;
    }

    _saveAndApplySelectedSubject(
      subjectId: defaultSubject.id!,
      subjectName: (defaultSubject.name ?? '').trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final persistedSubjectId =
        (sl<SharePrefsService>().getSelectedSubjectId() ?? '').trim();
    final persistedSubjectName =
        (sl<SharePrefsService>().getSelectedSubjectName() ?? '').trim();
    final activeSubjectId = persistedSubjectId.isNotEmpty
        ? persistedSubjectId
        : _selectedSubjectId.trim();
    final activeSubjectName = persistedSubjectName.isNotEmpty
        ? persistedSubjectName
        : _selectedSubjectName;
    final buttonWidth = 150.w;
    final buttonHeight = 52.h;
    final catSize = 72.w;
    final catOverlap = 8.h;

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
            BlocListener<SubjectCubit, PaginationState<SubjectEntity>>(
              listener: (context, state) {
                if (state is PaginationSuccess<SubjectEntity>) {
                  EasyLoading.dismiss();
                  _syncSelectedSubjectFromServer(state.items);
                } else if (state is PaginationError<SubjectEntity>) {
                  EasyLoading.dismiss();
                  EasyLoading.showToast(state.error ?? 'Lỗi',
                      toastPosition: EasyLoadingToastPosition.bottom);
                } else {
                  EasyLoading.dismiss();
                }
              },
            ),
          ],
          child: BackgroundHome(
            subjectName: activeSubjectName,
            child: SafeArea(
              child: Builder(builder: (newcontext) {
                return Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          newcontext.read<NewsCubit>().getNews();
                          newcontext
                              .read<SubjectCubit>()
                              .getSubjects(searchQuery: "");
                          newcontext.read<AuthBloc>().add(AuthGetSession());
                        },
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.only(
                            left: 16.w,
                            right: 16.w,
                            top: 16.w,
                            bottom:
                                MediaQuery.of(newcontext).padding.bottom + 96.h,
                          ),
                          children: [
                            HeaderHome(subjectName: activeSubjectName),
                            SizedBox(height: 16.h),
                            ListSubjects(
                              selectedSubjectId: _selectedSubjectId,
                              onSubjectSelected: (subjectId, subjectName) {
                                _saveAndApplySelectedSubject(
                                  subjectId: subjectId,
                                  subjectName: subjectName,
                                );
                              },
                            ),
                            SizedBox(height: 16.h),
                            TrendQuizzesList(
                              key: ValueKey('trend-$activeSubjectId'),
                              subjectId: activeSubjectId,
                            ),
                            SizedBox(height: 16.h),
                            CommentPage(),
                            SizedBox(height: 16.h),
                            WsBootstrap(
                              wsUrl: wsUrlForEnvironment(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
        floatingActionButton: SizedBox(
          width: buttonWidth,
          height: buttonHeight + catSize - catOverlap,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: IgnorePointer(
                  child: SizedBox(
                    width: catSize + 14,
                    height: catSize + 14,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Lottie.asset(
                        'assets/lottie_json/cat_is_sleeping_and_rolling.json',
                        repeat: true,
                        delegates: LottieDelegates(
                          values: [
                            ValueDelegate.transformOpacity(
                              ['White Solid 1', '**'],
                              value: 0,
                            ),
                            ValueDelegate.opacity(
                              ['White Solid 1', '**'],
                              value: 0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Tooltip(
                  message: 'Đổi môn học',
                  child: BasicButton(
                    width: buttonWidth,
                    height: buttonHeight,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<SubjectCubit>(),
                            child: const ChangeSubjectPage(),
                          ),
                        ),
                      ).then((_) => _loadSelectedSubjectFromPrefs());
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Symbols.swap_horiz_rounded,
                          size: 18.sp,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Đổi môn',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.sp,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
