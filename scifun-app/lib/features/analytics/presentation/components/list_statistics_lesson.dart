import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/app_loading_indicator.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/analytics/domain/entities/progress_entity.dart';
import 'package:sci_fun/features/analytics/presentation/widget/custom_expansion_tile_lesson.dart';
import 'package:sci_fun/features/analytics/presentation/widget/lesson_item.dart';
import 'package:sci_fun/features/analytics/presentation/cubits/progress_cubit.dart';

class ListStatisticsLesson extends StatelessWidget {
  final String? subjectId;
  const ListStatisticsLesson({super.key, required this.subjectId});

  String _getLastSubmissionTime(QuizEntity quiz) {
    if (quiz.lastSubmissionAt == null) return '---';

    final now = DateTime.now();
    final difference = now.difference(quiz.lastSubmissionAt!);

    if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }

  String _getScoreDisplay(QuizEntity quiz) {
    if (quiz.attempts == 0 || quiz.score == null) {
      return '---';
    }
    return '${quiz.score!.toStringAsFixed(2)} điểm';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgressCubit, ProgressState>(
      builder: (context, state) {
        if (state is ProgressLoading) {
          return const Center(
            child: AppLoadingIndicator(
              message: 'Đang tải tiến độ học tập...',
            ),
          );
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
                            AlwaysStoppedAnimation<Color>(AppColor.skyblue600),
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
                                        color: AppColor.skyblue600,
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
                        borderColor: AppColor.skyblue300,
                        iconColor: AppColor.skyblue600,
                        titleFontSize: 18.sp,
                        children: topic.quizzes.map((quiz) {
                          return LessonItem(
                            title: quiz.name ?? "Không có tên",
                            completedTime: _getLastSubmissionTime(quiz),
                            score: _getScoreDisplay(quiz),
                            bestScore: quiz.bestScore,
                            attempts: quiz.attempts ?? 0,
                          );
                        }).toList(),
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
