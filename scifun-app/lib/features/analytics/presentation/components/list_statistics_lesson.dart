import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:thilop10_3004/core/utils/theme/app_color.dart';
import 'package:thilop10_3004/features/analytics/presentation/widget/custom_expansion_tile_lesson.dart';
import 'package:thilop10_3004/features/analytics/presentation/widget/lesson_item.dart';
import 'package:thilop10_3004/features/home/domain/entity/lesson_entity.dart';
import 'package:thilop10_3004/features/home/presentation/cubit/progress_cubit.dart';

class ListStatisticsLesson extends StatelessWidget {
  final int? subjectId;
  const ListStatisticsLesson({super.key, required this.subjectId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgressCubit, ProgressState>(
      builder: (context, state) {
        print("State: $state");
        if (state is ProgressLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ProgressLoaded) {
          final groupedLessons = groupBy(state.progress.lessons,
              (LessonEntity e) => e.lessonCategory?.name ?? 'Khác');

          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 40.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: LinearProgressIndicator(
                        value: state.progress.progress.completionPercentage
                                .toDouble() /
                            100,
                        minHeight: 6,
                        backgroundColor: Color(0xFF787880).withOpacity(0.16),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.red),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 32.w, vertical: 4.h),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final progress = state
                              .progress.progress.completionPercentage
                              .toDouble()
                              .clamp(0, 100);
                          final barWidth = constraints.maxWidth;
                          final currentOffset = barWidth * progress / 100;

                          return SizedBox(
                            height: 24.h,
                            child: Stack(
                              children: [
                                // 0% bên trái
                                Positioned(
                                  left: 0,
                                  child: Text(
                                    "0%",
                                    style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),

                                // 100% bên phải
                                Positioned(
                                  right: 0,
                                  child: Text(
                                    "100%",
                                    style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),

                                // % hiện tại — chỉ hiển thị khi không phải 0% hoặc 100%
                                if (progress > 0 && progress < 100)
                                  Positioned(
                                    left: currentOffset -
                                        20.w, // căn giữa tương đối
                                    child: Text(
                                      "${progress.round()}%",
                                      style: TextStyle(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(height: 40.h),
                ...groupedLessons.entries.map((entry) {
                  final categoryName = entry.key;
                  final lessons = entry.value;
                  print(lessons);
                  return Column(
                    children: [
                      CustomExpansionTileLesson(
                        completedCount: lessons
                            .where((l) =>
                                l.quizz.isNotEmpty &&
                                l.quizz.first.quizResult != null)
                            .length,
                        title: categoryName,
                        backgroundColor: Colors.white,
                        borderColor: AppColor.primary300,
                        iconColor: AppColor.primary600,
                        titleFontSize: 18.sp,
                        children: lessons.map((lesson) {
                          final quizResult = lesson.quizz.isNotEmpty
                              ? lesson.quizz.first.quizResult
                              : null;
                          return LessonItem(
                            title: lesson.name ?? "",
                            completedTime: quizResult?.updatedAt != null
                                ? DateFormat('HH:mm - dd/MM/yyyy')
                                    .format(quizResult!.updatedAt!)
                                : '---',
                            score: quizResult?.score != null
                                ? "${quizResult!.score} điểm"
                                : "",
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16.h),
                    ],
                  );
                }).toList(),
                // CustomExpansionTileLesson(
                //   completedCount: 2,
                //   title: 'Phân tích bài học',
                //   backgroundColor: Colors.white,
                //   borderColor: AppColor.primary300,
                //   iconColor: AppColor.primary600,
                //   titleFontSize: 18.sp,
                //   children: [
                //     LessonItem(
                //       title: 'Bài 1: Đạo hàm số thập phân',
                //       completedTime: '15:30 20/3/2024',
                //       score: '10 điểm',
                //     ),
                //     LessonItem(
                //       title: 'Bài 2: Thần số học',
                //       completedTime: '15:30 20/3/2024',
                //       score: '10 điểm',
                //     ),
                //   ],
                // ),
              ],
            ),
          );
        } else if (state is ProgressError) {
          return Center(child: Text("Lỗi: ${state.message}"));
        }
        return SizedBox.shrink();
      },
    );
  }
}
