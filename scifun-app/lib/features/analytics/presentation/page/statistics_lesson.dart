import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/features/analytics/presentation/components/list_statistics_lesson.dart';
import 'package:sci_fun/features/analytics/presentation/cubits/progress_cubit.dart';
import 'package:sci_fun/features/analytics/presentation/cubits/selected_subject_cubit.dart';
import 'package:sci_fun/features/analytics/presentation/cubits/tab_subjects.dart';
import 'package:sci_fun/features/subject/presentation/cubit/subject_cubit.dart';

class StatisticsLesson extends StatefulWidget {
  const StatisticsLesson({super.key});

  @override
  State<StatisticsLesson> createState() => _StatisticsLessonState();
}

class _StatisticsLessonState extends State<StatisticsLesson> {
  bool _didInitDefaultSubject = false;

  String? _firstNonNullSubjectId(List subjects) {
    for (final s in subjects) {
      final id = s.id; // SubjectEntity/SubjectModel của em
      if (id != null) return id as String;
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
        body: SingleChildScrollView(
          child: BlocBuilder<SubjectCubit, SubjectState>(
            builder: (context, subjectState) {
              if (subjectState is SubjectLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (subjectState is SubjectError) {
                return Center(child: Text("Lỗi: ${subjectState.message}"));
              }

              if (subjectState is SubjectsLoaded) {
                final subjects = subjectState.subjectList;

                if (subjects.isEmpty) {
                  return const Center(child: Text("Không có môn học"));
                }

                // Set default subjectId đúng 1 lần (sau khi có subjects)
                if (!_didInitDefaultSubject) {
                  final defaultId = _firstNonNullSubjectId(subjects);
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
    );
  }
}
