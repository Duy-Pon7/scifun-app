import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:sci_fun/common/helper/level_helper.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/common/widget/app_empty_state.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/widget/level_stat_icon.dart';
import 'package:sci_fun/common/widget/pagination_list_view.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/services/share_prefs_service.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/plan/presentation/page/plan_list_page.dart';
import 'package:sci_fun/features/profile/presentation/cubit/pro_cubit.dart';
import 'package:sci_fun/features/question/presentation/page/test_page.dart';
import 'package:sci_fun/features/quizz/domain/entity/quizz_entity.dart';
import 'package:sci_fun/features/quizz/presentation/cubit/quizz_cubit.dart';

class QuizzPage extends StatefulWidget {
  final String topicId;
  final String topicName;

  const QuizzPage({
    super.key,
    required this.topicId,
    required this.topicName,
  });

  @override
  State<QuizzPage> createState() => _QuizzPageState();
}

class _QuizzPageState extends State<QuizzPage> {
  late final QuizzCubit cubit;
  late final ProCubit proCubit;
  bool isProUser = false;

  @override
  void initState() {
    super.initState();
    cubit = sl<QuizzCubit>();
    proCubit = context.read<ProCubit>();
    cubit.loadInitial(filterId: widget.topicId);
    _initStateAsync();
  }

  Future<void> _initStateAsync() async {
    final token = sl<SharePrefsService>().getUserData();
    bool pro = false;

    try {
      if (token != null && token.isNotEmpty) {
        pro = await proCubit.isCheckPro(token: token);
      }
    } catch (_) {
      pro = false;
    }

    if (!mounted) return;
    setState(() => isProUser = pro);
  }

  @override
  void didUpdateWidget(covariant QuizzPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.topicId != widget.topicId) {
      cubit.loadInitial(filterId: widget.topicId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuizzCubit>.value(
      value: cubit,
      child: Scaffold(
        appBar: BasicAppbar(
          title: widget.topicName,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: PaginationListView<QuizzEntity>(
            cubit: cubit,
            emptyWidget: const Center(
              child: AppEmptyState(message: 'Không có bài kiểm tra'),
            ),
            itemBuilder: (context, quizz) {
              final bool isQuizPro = quizz.accessTier == 'PRO';
              final bool isLocked = isQuizPro && !isProUser;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color:
                        isQuizPro ? AppColor.skyblue600 : Colors.grey.shade300,
                    width: isQuizPro ? 2 : 1,
                  ),
                ),
                child: Stack(
                  children: [
                    ListTile(
                      leading: _buildLeading(quizz),
                      title: _buildTitle(quizz, isQuizPro),
                      subtitle: _buildSubtitle(quizz),
                      onTap: () {
                        if (isLocked) {
                          Navigator.push(
                            context,
                            slidePage(const PlanListPage()),
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          slidePage(
                            TestPage(
                              quizzId: quizz.id ?? '',
                            ),
                          ),
                        );
                      },
                    ),
                    if (isQuizPro)
                      Positioned(
                        top: 8.h,
                        right: 8.w,
                        child: Icon(
                          Symbols.star,
                          color: AppColor.skyblue600,
                          size: 18.sp,
                        ),
                      ),
                    if (isLocked)
                      Positioned.fill(
                        child: IgnorePointer(
                          ignoring: true,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(
                                Symbols.lock,
                                size: 36,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLeading(QuizzEntity quizz) {
    if (quizz.topic?.subject?.image != null &&
        (quizz.topic?.subject?.image ?? '').isNotEmpty) {
      return SizedBox(
        width: 56.w,
        height: 56.h,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(
            quizz.topic!.subject!.image!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                const Icon(Symbols.image_not_supported),
          ),
        ),
      );
    }
    return Icon(Symbols.quiz, color: AppColor.skyblue600);
  }

  Widget _buildTitle(QuizzEntity quizz, bool isQuizPro) {
    return Row(
      children: [
        Expanded(
          child: Text(
            quizz.title ?? 'No title',
            style: TextStyle(
              fontWeight: isQuizPro ? FontWeight.bold : FontWeight.w600,
              fontSize: 16.sp,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: isQuizPro ? AppColor.skyblue600 : Colors.green,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            isQuizPro ? 'PRO' : 'FREE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubtitle(QuizzEntity quizz) {
    final level = LevelHelper.normalize(quizz.level ?? quizz.topic?.level);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (quizz.description != null)
          Text(
            quizz.description!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey[700],
            ),
          ),
        SizedBox(height: 6.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 6.h,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (level != null) _buildLevelBadge(level),
            _buildMetaItem(
              icon: Symbols.timer,
              text: '${quizz.duration ?? 0} phút',
            ),
            _buildMetaItem(
              icon: Symbols.help_outline,
              text: '${quizz.questionCount ?? 0} câu',
            ),
            if (quizz.uniqueUserCount != null && quizz.uniqueUserCount! > 0)
              _buildMetaItem(
                icon: Symbols.people,
                text: '${quizz.uniqueUserCount}',
              ),
          ],
        ),
      ],
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
          Icon(icon, size: 14.sp, color: AppColor.skyblue600),
          SizedBox(width: 6.w),
          Text(text, style: TextStyle(fontSize: 12.sp)),
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
            size: 11.sp,
          ),
          SizedBox(width: 6.w),
          Text(
            displayLevel,
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
