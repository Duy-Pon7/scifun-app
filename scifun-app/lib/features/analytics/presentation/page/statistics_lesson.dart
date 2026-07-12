import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/cubit/pagination_cubit.dart';
import 'package:sci_fun/common/widget/app_empty_state.dart';
import 'package:sci_fun/common/widget/app_loading_indicator.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/services/share_prefs_service.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/analytics/domain/entities/progress_stats_entity.dart';
import 'package:sci_fun/features/analytics/presentation/components/list_statistics_lesson.dart';
import 'package:sci_fun/features/analytics/presentation/cubits/progress_cubit.dart';
import 'package:sci_fun/features/analytics/presentation/cubits/progress_stats_cubit.dart';
import 'package:sci_fun/features/analytics/presentation/cubits/selected_subject_cubit.dart';
import 'package:sci_fun/features/analytics/presentation/cubits/tab_subjects.dart';
import 'package:sci_fun/features/home/presentation/cubit/dashboard_cubit.dart';
import 'package:sci_fun/features/subject/domain/entity/subject_entity.dart';
import 'package:sci_fun/features/subject/presentation/cubit/subject_cubit.dart';

class StatisticsLesson extends StatefulWidget {
  const StatisticsLesson({super.key});

  @override
  State<StatisticsLesson> createState() => _StatisticsLessonState();
}

class _StatisticsLessonState extends State<StatisticsLesson> {
  static const int _analyticsTabIndex = 1;

  late final ProgressCubit _progressCubit;
  late final ProgressStatsCubit _progressStatsCubit;
  bool _didInitDefaultSubject = false;
  String? _lastAppliedPersistedSubjectId;

  @override
  void initState() {
    super.initState();
    _progressCubit = sl<ProgressCubit>();
    _progressStatsCubit = sl<ProgressStatsCubit>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _fetchProgressStatsIfVisible();
    });
  }

  @override
  void dispose() {
    _progressStatsCubit.close();
    super.dispose();
  }

  void _fetchProgressStatsIfVisible() {
    if (context.read<DashboardCubit>().state == _analyticsTabIndex) {
      _progressStatsCubit.fetchProgressStats();
    }
  }

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
        BlocProvider.value(value: _progressCubit),
        BlocProvider.value(value: _progressStatsCubit),
        BlocProvider(create: (_) => SelectedSubjectCubit()),
      ],
      child: BlocListener<DashboardCubit, int>(
        listenWhen: (previous, current) =>
            previous != _analyticsTabIndex && current == _analyticsTabIndex,
        listener: (context, _) => _progressStatsCubit.fetchProgressStats(),
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
                      child: Text("Lỗi: ${subjectState.error ?? 'Không rõ'}"),
                    );
                  }

                  if (subjectState is PaginationSuccess<SubjectEntity>) {
                    final subjects = subjectState.items;
                    final persistedSubjectId = _persistedSubjectIdIn(subjects);
                    final selectedSubjectCubit =
                        context.read<SelectedSubjectCubit>();

                    if (subjects.isEmpty) {
                      return const Center(
                        child: AppEmptyState(message: 'Không có môn học'),
                      );
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

                    if (!_didInitDefaultSubject) {
                      final defaultId = persistedSubjectId ??
                          _firstNonNullSubjectId(subjects);
                      if (defaultId != null) {
                        _didInitDefaultSubject = true;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (!mounted) return;
                          context
                              .read<SelectedSubjectCubit>()
                              .selectSubject(defaultId);
                        });
                      }
                    }

                    return BlocListener<SelectedSubjectCubit, String?>(
                      listenWhen: (prev, curr) => prev != curr && curr != null,
                      listener: (context, subjectId) {
                        context.read<ProgressCubit>().fetchProgress(subjectId!);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                            child: BlocBuilder<ProgressStatsCubit,
                                ProgressStatsState>(
                              builder: (context, statsState) {
                                final stats = statsState is ProgressStatsLoaded
                                    ? statsState.stats
                                    : const ProgressStatsEntity.empty();

                                return _ProgressStatsOverview(stats: stats);
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            child: TabSubjects(subjects: subjects),
                          ),
                          BlocBuilder<SelectedSubjectCubit, String?>(
                            builder: (context, selectedId) {
                              final String? subjectId = selectedId ??
                                  _firstNonNullSubjectId(subjects);

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
      ),
    );
  }
}

class _ProgressStatsOverview extends StatelessWidget {
  const _ProgressStatsOverview({required this.stats});

  final ProgressStatsEntity stats;

  ProgressStatsPeriodEntity? _latestPeriod(
    List<ProgressStatsPeriodEntity> periods,
  ) {
    if (periods.isEmpty) return null;
    return periods.last;
  }

  String _formatScore(double score) {
    if (score == score.roundToDouble()) {
      return score.toStringAsFixed(0);
    }

    return score
        .toStringAsFixed(2)
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(
          RegExp(r'\.$'),
          '',
        );
  }

  @override
  Widget build(BuildContext context) {
    final day = _latestPeriod(stats.day);
    final week = _latestPeriod(stats.week);
    final month = _latestPeriod(stats.month);

    return Row(
      children: [
        Expanded(
          child: _ProgressStatsCard(
            title: 'Ngày',
            periodLabel: day?.periodLabel ?? 'Hôm nay',
            submissions: day?.totalSubmissions ?? 0,
            completedQuizzes: day?.completedQuizzes ?? 0,
            averageScore: _formatScore(day?.averageScore ?? 0),
            icon: Icons.today_rounded,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _ProgressStatsCard(
            title: 'Tuần',
            periodLabel: week?.periodLabel ?? 'Tuần này',
            submissions: week?.totalSubmissions ?? 0,
            completedQuizzes: week?.completedQuizzes ?? 0,
            averageScore: _formatScore(week?.averageScore ?? 0),
            icon: Icons.date_range_rounded,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _ProgressStatsCard(
            title: 'Tháng',
            periodLabel: month?.periodLabel ?? 'Tháng này',
            submissions: month?.totalSubmissions ?? 0,
            completedQuizzes: month?.completedQuizzes ?? 0,
            averageScore: _formatScore(month?.averageScore ?? 0),
            icon: Icons.calendar_month_rounded,
          ),
        ),
      ],
    );
  }
}

class _ProgressStatsCard extends StatelessWidget {
  const _ProgressStatsCard({
    required this.title,
    required this.periodLabel,
    required this.submissions,
    required this.completedQuizzes,
    required this.averageScore,
    required this.icon,
  });

  final String title;
  final String periodLabel;
  final int submissions;
  final int completedQuizzes;
  final String averageScore;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColor.skyblue200,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.skyblue100.withValues(alpha: 0.6),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  color: AppColor.skyblue100,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  icon,
                  color: AppColor.skyblue700,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColor.skyblue900,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Text(
                '$submissions',
                style: textTheme.titleLarge?.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColor.skyblue700,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                'Lượt nộp',
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 12.sp,
                  color: AppColor.hurricane600,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: _ProgressStatsMetric(
                  label: 'Điểm TB',
                  value: averageScore,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressStatsMetric extends StatelessWidget {
  const _ProgressStatsMetric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColor.skyblue50,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            label,
            style: textTheme.bodySmall?.copyWith(
              fontSize: 15.sp,
              color: AppColor.hurricane600,
            ),
          ),
          Expanded(
            flex: 5,
            child: AutoSizeText(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: textTheme.bodyMedium?.copyWith(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.skyblue800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
