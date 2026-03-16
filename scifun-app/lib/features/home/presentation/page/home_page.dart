import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final persistedSubjectName =
        (sl<SharePrefsService>().getSelectedSubjectName() ?? '').trim();
    final activeSubjectName = persistedSubjectName.isNotEmpty
        ? persistedSubjectName
        : _selectedSubjectName;

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
                          HeaderHome(subjectName: activeSubjectName),
                          ListSubjects(
                            onSubjectSelected: (subjectId, subjectName) {
                              _saveAndApplySelectedSubject(
                                subjectId: subjectId,
                                subjectName: subjectName,
                              );
                            },
                          ),
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
        floatingActionButton: FloatingActionButton.extended(
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
          tooltip: 'Đổi môn học',
          icon: const Icon(Icons.swap_horiz_rounded),
          label: const Text('Đổi môn'),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
