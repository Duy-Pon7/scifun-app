import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/common/widget/app_empty_state.dart';
import 'package:sci_fun/common/widget/app_loading_indicator.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/question/presentation/page/test_page.dart';
import 'package:sci_fun/features/quizz/presentation/cubit/trend_quizz_cubit.dart';

class TrendQuizzesList extends StatelessWidget {
  const TrendQuizzesList({
    super.key,
    this.subjectId,
  });

  final String? subjectId;

  @override
  Widget build(BuildContext context) {
    final normalizedSubjectId = (subjectId ?? '').trim();

    return BlocProvider(
      create: (_) => sl<TrendQuizzCubit>()
        ..fetchTrendQuizzes(
          subjectId: normalizedSubjectId.isEmpty ? null : normalizedSubjectId,
        ),
      child: BlocBuilder<TrendQuizzCubit, TrendQuizzState>(
        builder: (context, state) {
          if (state is TrendQuizzLoading) {
            return const Center(
              child: AppLoadingIndicator(
                message: 'Dang tai bai kiem tra thinh hanh...',
              ),
            );
          }

          if (state is TrendQuizzError) {
            return Center(child: Text(state.message));
          }

          final items = state is TrendQuizzLoaded ? state.trendData.data : [];

          if (items.isEmpty) {
            return const Center(
              child: AppEmptyState(
                message: 'Khong co bai kiem tra thinh hanh',
                animationSize: 120,
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
                child: Text(
                  'Bai kiem tra thinh hanh',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 164.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  itemBuilder: (context, index) {
                    final quizz = items[index];
                    final isPro = quizz.score != null && quizz.score! > 0.8;
                    final level = _normalizeLevel(quizz.level);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          slidePage(TestPage(quizzId: quizz.id ?? '')),
                        );
                      },
                      child: SizedBox(
                        width: 300.w,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: BorderSide(
                              color: isPro
                                  ? AppColor.skyblue600
                                  : Colors.grey[300]!,
                              width: isPro ? 2.0 : 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12.w),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final isCompact = constraints.maxHeight < 110;
                                final imageSize = isCompact ? 40.w : 56.w;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        quizz.topic?.subject?.image != null &&
                                                (quizz.topic?.subject?.image ??
                                                        '')
                                                    .isNotEmpty
                                            ? SizedBox(
                                                width: imageSize,
                                                height: imageSize,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  child: Image.network(
                                                    quizz
                                                        .topic!.subject!.image!,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (_, __, ___) =>
                                                            const Icon(
                                                      Icons.image_not_supported,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Icon(
                                                Icons.quiz,
                                                color: AppColor.skyblue600,
                                              ),
                                        SizedBox(width: 8.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                quizz.title ?? 'No title',
                                                maxLines: isCompact ? 1 : 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: isPro
                                                      ? FontWeight.bold
                                                      : FontWeight.w600,
                                                  fontSize:
                                                      isCompact ? 13.sp : 14.sp,
                                                ),
                                              ),
                                              if (quizz.score != null)
                                                Text(
                                                  'Diem: ${(quizz.score! * 100).toStringAsFixed(0)}%',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: isCompact
                                                        ? 11.sp
                                                        : 12.sp,
                                                    color: AppColor.skyblue600,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (!isCompact) const Spacer(),
                                    if (!isCompact && quizz.description != null)
                                      Text(
                                        quizz.description!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    SizedBox(height: isCompact ? 4.h : 8.h),
                                    Row(
                                      spacing: 10.w,
                                      children: [
                                        if (level != null)
                                          _buildLevelBadge(level),
                                        _buildMetaItem(
                                          icon: Icons.timer,
                                          text: '${quizz.duration ?? 0} phut',
                                        ),
                                        _buildMetaItem(
                                          icon: Icons.help_outline,
                                          text:
                                              '${quizz.questionCount ?? 0} cau',
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => SizedBox(width: 8.w),
                  itemCount: items.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMetaItem({required IconData icon, required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColor.skyblue600.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColor.skyblue600.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: AppColor.skyblue600),
          SizedBox(width: 6.w),
          AutoSizeText(text, style: TextStyle(fontSize: 12.sp)),
        ],
      ),
    );
  }

  Widget _buildLevelBadge(String level) {
    final color = _levelColor(level);
    final chevronCount = _levelChevronCount(level);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TrendLevelChevronIcon(
            count: chevronCount,
            color: color,
            size: 10.sp,
          ),
          SizedBox(width: 6.w),
          AutoSizeText(
            level,
            style: TextStyle(
              fontSize: 11.sp,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String? _normalizeLevel(String? value) {
    final raw = (value ?? '').trim();
    if (raw.isEmpty) return null;
    final lower = raw.toLowerCase();
    if (lower == 'beginner') return 'Beginner';
    if (lower == 'intermediate') return 'Intermediate';
    if (lower == 'advanced') return 'Advanced';
    return raw;
  }

  int _levelChevronCount(String level) {
    final lower = level.toLowerCase();
    if (lower == 'advanced') return 3;
    if (lower == 'intermediate') return 2;
    return 1;
  }

  Color _levelColor(String level) {
    final lower = level.toLowerCase();
    if (lower == 'advanced') return Colors.red.shade700;
    if (lower == 'intermediate') return Colors.orange.shade700;
    return Colors.green.shade700;
  }
}

class _TrendLevelChevronIcon extends StatelessWidget {
  const _TrendLevelChevronIcon({
    required this.count,
    required this.color,
    required this.size,
  });

  final int count;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        count,
        (_) => Transform.translate(
          offset: Offset(0, -1.h),
          child: Icon(
            Icons.keyboard_arrow_up,
            size: size,
            color: color,
          ),
        ),
      ),
    );
  }
}
