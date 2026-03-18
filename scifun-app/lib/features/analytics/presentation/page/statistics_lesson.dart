import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/app_loading_indicator.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/services/share_prefs_service.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/analytics/presentation/components/list_statistics_lesson.dart';
import 'package:sci_fun/features/analytics/presentation/cubits/progress_cubit.dart';
import 'package:sci_fun/features/analytics/presentation/cubits/selected_subject_cubit.dart';
import 'package:sci_fun/features/analytics/presentation/cubits/tab_subjects.dart';
import 'package:sci_fun/common/cubit/pagination_cubit.dart';
import 'package:sci_fun/features/subject/domain/entity/subject_entity.dart';
import 'package:sci_fun/features/subject/presentation/cubit/subject_cubit.dart';

class StatisticsLesson extends StatefulWidget {
  const StatisticsLesson({super.key});

  @override
  State<StatisticsLesson> createState() => _StatisticsLessonState();
}

class _StatisticsLessonState extends State<StatisticsLesson> {
  bool _didInitDefaultSubject = false;
  String? _lastAppliedPersistedSubjectId;

  String? _firstNonNullSubjectId(List<SubjectEntity> subjects) {
    for (final s in subjects) {
      final id = (s.id ?? '').trim();
      if (id.isNotEmpty) return id;
    }
    return null;
  }

  String? _persistedSubjectIdIn(List<SubjectEntity> subjects) {
    final persistedId =
        (sl<SharePrefsService>().getSelectedSubjectId() ?? '').trim();
    if (persistedId.isEmpty) {
      return null;
    }

    for (final subject in subjects) {
      if ((subject.id ?? '').trim() == persistedId) {
        return persistedId;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<SubjectCubit>()..getSubjects(searchQuery: ""),
        ),
        BlocProvider.value(
          value: sl<ProgressCubit>(),
        ),
        BlocProvider(
          create: (_) => SelectedSubjectCubit(),
        ),
      ],
      child: Scaffold(
        appBar: const BasicAppbar(title: 'Thống kê', showBack: false),
        body: ValueListenableBuilder(
          valueListenable: AppColor.themeNotifier,
          builder: (context, _, __) => SingleChildScrollView(
            child: BlocBuilder<SubjectCubit, PaginationState<SubjectEntity>>(
              builder: (context, subjectState) {
                if (subjectState is PaginationLoading<SubjectEntity>) {
                  return const Center(
                    child: AppLoadingIndicator(
                      message: 'Đang tải thống kê...',
                    ),
                  );
                }

                if (subjectState is PaginationError<SubjectEntity>) {
                  return Center(
                      child: Text("Lỗi: ${subjectState.error ?? 'Không rõ'}"));
                }

                if (subjectState is PaginationSuccess<SubjectEntity>) {
                  final subjects = subjectState.items;
                  final persistedSubjectId = _persistedSubjectIdIn(subjects);
                  final selectedSubjectCubit =
                      context.read<SelectedSubjectCubit>();

                  if (subjects.isEmpty) {
                    return const Center(child: Text("Không có môn học"));
                  }

                  if (persistedSubjectId != null &&
                      persistedSubjectId != _lastAppliedPersistedSubjectId &&
                      selectedSubjectCubit.state != persistedSubjectId) {
                    _lastAppliedPersistedSubjectId = persistedSubjectId;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted) return;
                      selectedSubjectCubit.selectSubject(persistedSubjectId);
                    });
                  }

                  // Set default subjectId đúng 1 lần (sau khi có subjects)
                  if (!_didInitDefaultSubject) {
                    final defaultId =
                        persistedSubjectId ?? _firstNonNullSubjectId(subjects);
                    if (defaultId != null) {
                      _didInitDefaultSubject = true;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!mounted) return;
                        // chỉ set state mặc định, không fetch ở đây
                        context
                            .read<SelectedSubjectCubit>()
                            .selectSubject(defaultId);
                      });
                    }
                  }

                  return BlocListener<SelectedSubjectCubit, String?>(
                    listenWhen: (prev, curr) => prev != curr && curr != null,
                    listener: (context, subjectId) {
                      // ✅ fetchProgress chạy ở listener, không chạy trong build
                      context.read<ProgressCubit>().fetchProgress(subjectId!);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          child: TabSubjects(subjects: subjects),
                        ),
                        BlocBuilder<SelectedSubjectCubit, String?>(
                          builder: (context, selectedId) {
                            final String? subjectId =
                                selectedId ?? _firstNonNullSubjectId(subjects);

                            if (subjectId == null) {
                              return const SizedBox.shrink();
                            }

                            return ListStatisticsLesson(subjectId: subjectId);
                          },
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
