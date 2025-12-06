import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/features/analytics/presentation/components/list_statistics_lesson.dart';
import 'package:sci_fun/features/analytics/presentation/cubits/progress_cubit.dart';
import 'package:sci_fun/features/analytics/presentation/cubits/tab_subjects.dart';
import 'package:sci_fun/features/home/presentation/cubit/select_tab_cubit.dart';
import 'package:sci_fun/features/subject/presentation/cubit/subject_cubit.dart';

class StatisticsLesson extends StatefulWidget {
  const StatisticsLesson({super.key});

  @override
  State<StatisticsLesson> createState() => _StatisticsLessonState();
}

class _StatisticsLessonState extends State<StatisticsLesson> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SelectTabCubit()),
        BlocProvider(
          create: (context) => sl<SubjectCubit>()..getSubjects(searchQuery: ""),
        ),
        BlocProvider(
          create: (context) => sl<ProgressCubit>(),
        ),
      ],
      child: Scaffold(
        appBar: BasicAppbar(title: 'Thống kê', showBack: false),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: TabSubjects(), // Tab chọn subject
              ),
              BlocBuilder<SubjectCubit, SubjectState>(
                builder: (context, subjectState) {
                  if (subjectState is SubjectLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (subjectState is SubjectsLoaded) {
                    final subjects = subjectState.subjectList;
                    print("Subjects: $subjects");
                    return BlocBuilder<SelectTabCubit, int>(
                      builder: (context, selectedIndex) {
                        if (selectedIndex >= subjects.length) {
                          return Center(child: Text("Không có môn học"));
                        }

                        final selectedSubject = subjects[selectedIndex];
                        final subjectId = selectedSubject.id;
                        print("Selected Subject ID: $subjectId");

                        // Trigger fetchProgress whenever tab changes
                        if (subjectId != null) {
                          context
                              .read<ProgressCubit>()
                              .fetchProgress(subjectId);
                        }

                        return ListStatisticsLesson(
                          subjectId: subjectId,
                        );
                      },
                    );
                  } else if (subjectState is SubjectError) {
                    return Center(child: Text("Lỗi: ${subjectState.message}"));
                  }
                  return SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
