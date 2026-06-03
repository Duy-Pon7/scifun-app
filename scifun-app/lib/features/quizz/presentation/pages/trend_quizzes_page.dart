import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:sci_fun/common/helper/level_helper.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/common/widget/app_empty_state.dart';
import 'package:sci_fun/common/widget/app_loading_indicator.dart';
import 'package:sci_fun/common/widget/change_confirm_dialog.dart';
import 'package:sci_fun/common/widget/level_stat_icon.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/services/share_prefs_service.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/profile/presentation/cubit/user_cubit.dart';
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
                message: 'Đang tải bài kiểm tra thịnh hành...',
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
                message: 'Không có bài kiểm tra thịnh hành',
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
                  'Bài kiểm tra thịnh hành',
                  style: TextStyle(
                    fontSize: 18.sp,
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
                    final level = LevelHelper.normalize(quizz.level);

                    return GestureDetector(
                      onTap: () => _openTrendQuiz(
                        context,
                        quizzId: quizz.id ?? '',
                        quizzLevel: level ?? quizz.level,
                      ),
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
                                final isTight = constraints.maxHeight < 140;
                                final imageSize = isCompact ? 40.w : 56.w;
                                final descriptionMaxLines = isTight ? 1 : 2;
                                final metaSpacing = isTight ? 8.w : 10.w;
                                final metaRunSpacing = isTight ? 4.h : 8.h;
                                final contentGap =
                                    isCompact ? 4.h : (isTight ? 4.h : 8.h);

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
                                                      Symbols
                                                          .image_not_supported,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Icon(
                                                Symbols.quiz_rounded,
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
                                                      isCompact ? 15.sp : 18.sp,
                                                ),
                                              ),
                                              if (quizz.score != null)
                                                Text(
                                                  'Điểm: ${(quizz.score! * 100).toStringAsFixed(0)}%',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: isCompact
                                                        ? 12.sp
                                                        : 14.sp,
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
                                        maxLines: descriptionMaxLines,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    SizedBox(height: contentGap),
                                    Wrap(
                                      spacing: metaSpacing,
                                      runSpacing: metaRunSpacing,
                                      children: [
                                        if (level != null)
                                          _buildLevelBadge(level),
                                        _buildMetaItem(
                                          icon: Symbols.timer_rounded,
                                          text: '${quizz.duration ?? 0} phút',
                                        ),
                                        _buildMetaItem(
                                          icon: Symbols.help_outline_rounded,
                                          text:
                                              '${quizz.questionCount ?? 0} câu',
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
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColor.skyblue600.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColor.skyblue600.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: AppColor.skyblue600),
          AutoSizeText(text, style: TextStyle(fontSize: 14.sp)),
        ],
      ),
    );
  }

  Widget _buildLevelBadge(String level) {
    final color = _levelColor(level);
    final chevronCount = _levelChevronCount(level);
    final displayLevel = LevelHelper.toVietnamese(level);

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
          LevelStatIcon(
            count: chevronCount,
            color: color,
            size: 10.sp,
          ),
          SizedBox(width: 6.w),
          AutoSizeText(
            displayLevel,
            style: TextStyle(
              fontSize: 12.sp,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  int? _levelRank(String? level) {
    return LevelHelper.rank(level);
  }

  String _resolveCurrentUserLevel(BuildContext context) {
    try {
      final userState = context.read<UserCubit>().state;
      if (userState is UserLoaded) {
        final loadedLevel = LevelHelper.normalize(userState.user.data?.level);
        if (loadedLevel != null) {
          return loadedLevel;
        }
      }
    } catch (_) {}

    return LevelHelper.normalize(
            sl<SharePrefsService>().getOnboardingLevel()) ??
        LevelHelper.beginner;
  }

  bool _needsHigherLevelConfirmation({
    required String userLevel,
    required String? quizzLevel,
  }) {
    final userRank = _levelRank(userLevel) ?? 1;
    final quizzRank = _levelRank(quizzLevel);
    if (quizzRank == null) {
      return false;
    }
    return quizzRank > userRank;
  }

  Future<void> _openTrendQuiz(
    BuildContext context, {
    required String quizzId,
    required String? quizzLevel,
  }) async {
    final normalizedId = quizzId.trim();
    if (normalizedId.isEmpty) {
      return;
    }

    final userLevel = _resolveCurrentUserLevel(context);
    if (_needsHigherLevelConfirmation(
      userLevel: userLevel,
      quizzLevel: quizzLevel,
    )) {
      final shouldContinue = await showChangeConfirmDialog(
        context: context,
        titleText: 'Bạn có chắc muốn tham gia không?',
        messageText: 'Bài tập này kiến thức sẽ khó hơn mức hiện tại của bạn.',
        confirmButtonText: 'Tham gia',
      );

      if (shouldContinue != true || !context.mounted) {
        return;
      }
    }

    Navigator.push(
      context,
      slidePage(TestPage(quizzId: normalizedId)),
    );
  }

  int _levelChevronCount(String level) {
    return LevelHelper.rank(level) ?? 1;
  }

  Color _levelColor(String level) {
    final normalized = LevelHelper.normalize(level);
    if (normalized == LevelHelper.advanced) return Colors.red.shade700;
    if (normalized == LevelHelper.intermediate) return Colors.orange.shade700;
    return Colors.green.shade700;
  }
}
