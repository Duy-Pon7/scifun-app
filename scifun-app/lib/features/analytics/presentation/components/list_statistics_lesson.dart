import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/analytics/presentation/widget/custom_expansion_tile_lesson.dart';
import 'package:sci_fun/features/analytics/presentation/widget/lesson_item.dart';
import 'package:sci_fun/features/analytics/presentation/cubits/progress_cubit.dart';

class ListStatisticsLesson extends StatelessWidget {
  final String? subjectId;
  const ListStatisticsLesson({super.key, required this.subjectId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgressCubit, ProgressState>(
      builder: (context, state) {
        print("ProgressCubit: $state");
        if (state is ProgressLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ProgressLoaded) {
          final topics = state.progress.topics;
          final progress = state.progress.progress ?? 0;

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
                        value: progress.toDouble() / 100,
                        minHeight: 6,
                        backgroundColor:
                            Color(0xFF787880).withValues(alpha: .16),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColor.primary600),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 32.w, vertical: 4.h),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final progressValue =
                              progress.toDouble().clamp(0, 100);
                          final barWidth = constraints.maxWidth;

                          double rawOffset = barWidth * progressValue / 100;
                          double textWidth =
                              36.w; // ước lượng chiều rộng chữ "100%"
                          double safeOffset = rawOffset - textWidth / 2;

                          safeOffset =
                              safeOffset.clamp(0, barWidth - textWidth);
                          return SizedBox(
                            height: 24.h,
                            child: Stack(
                              children: [
                                // % hiện tại — chỉ hiển thị khi không phải 0% hoặc 100%
                                if (progressValue > 0 && progressValue < 100)
                                  Positioned(
                                    left: safeOffset,
                                    child: Text(
                                      "${progressValue.round()}%",
                                      style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.primary600,
                                      ),
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
                ...topics.map((topic) {
                  return Column(
                    children: [
                      CustomExpansionTileLesson(
                        completedCount: topic.completedQuizzes ?? 0,
                        title: topic.name ?? "Không có tên",
                        backgroundColor: Colors.white,
                        borderColor: AppColor.primary300,
                        iconColor: AppColor.primary600,
                        titleFontSize: 18.sp,
                        children: [
                          LessonItem(
                            title: topic.name ?? "Không có tên",
                            completedTime:
                                '${topic.completedQuizzes}/${topic.totalQuizzes} bài',
                            score: topic.averageScore != null
                                ? "${topic.averageScore} điểm"
                                : "---",
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                    ],
                  );
                }),
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
