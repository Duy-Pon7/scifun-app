import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/helper/level_helper.dart';
import 'package:sci_fun/common/widget/app_empty_state.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/widget/change_confirm_dialog.dart';
import 'package:sci_fun/common/widget/pagination_list_view.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/services/share_prefs_service.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/profile/presentation/cubit/user_cubit.dart';
import 'package:sci_fun/features/topic/domain/entity/topic_entity.dart';
import 'package:sci_fun/features/topic/presentation/cubit/topic_cubit.dart';
import 'package:sci_fun/features/video/presentation/pages/video_page.dart';

class TopicPage extends StatefulWidget {
  final String subjectId;
  final String subjectName;

  const TopicPage({
    super.key,
    required this.subjectId,
    required this.subjectName,
  });

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  late final TopicCubit cubit;
  String? _userLevel;

  @override
  void initState() {
    super.initState();
    cubit = sl<TopicCubit>();
    _userLevel = _resolveCurrentUserLevel() ??
        LevelHelper.normalize(sl<SharePrefsService>().getOnboardingLevel()) ??
        LevelHelper.beginner;
    cubit.loadInitial(filterId: widget.subjectId);
  }

  @override
  void didUpdateWidget(TopicPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.subjectId != widget.subjectId) {
      cubit.loadInitial(filterId: widget.subjectId);
    }
  }

  String? _resolveCurrentUserLevel() {
    UserCubit? userCubit;
    try {
      userCubit = BlocProvider.of<UserCubit>(context);
    } catch (_) {
      userCubit = null;
    }

    if (userCubit == null) {
      return null;
    }

    final state = userCubit.state;
    if (state is UserLoaded) {
      return LevelHelper.normalize(state.user.data?.level);
    }
    return null;
  }

  bool _needsHigherLevelConfirmation(String? topicLevel) {
    final userRank = LevelHelper.rank(_userLevel) ?? 1;
    final topicRank = LevelHelper.rank(topicLevel);

    if (topicRank == null) {
      return false;
    }

    return topicRank > userRank;
  }

  Future<void> _openTopic(TopicEntity topic) async {
    final latestUserLevel = _resolveCurrentUserLevel();
    if (latestUserLevel != null) {
      _userLevel = latestUserLevel;
    }

    if (_needsHigherLevelConfirmation(topic.level)) {
      final shouldContinue = await showChangeConfirmDialog(
        context: context,
        titleText: 'Bạn có chắc muốn tham gia không?',
        messageText: 'Kiến thức của chủ đề này khó hơn mức hiện tại của bạn.',
        confirmButtonText: 'Tham gia',
      );

      if (shouldContinue != true || !mounted) {
        return;
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPage(
          topicId: topic.id ?? '',
          topicName: topic.name ?? '',
        ),
      ),
    );
  }

  Color _levelColor(String? level) {
    final normalized = LevelHelper.normalize(level);
    if (normalized == LevelHelper.advanced) return Colors.red.shade700;
    if (normalized == LevelHelper.intermediate) return Colors.orange.shade700;
    return Colors.green.shade700;
  }

  Widget _buildTopicLevelIndicator(String? level) {
    final normalized = LevelHelper.normalize(level);
    final rank = LevelHelper.rank(normalized) ?? 0;
    final activeColor = _levelColor(normalized);
    final label =
        normalized != null ? LevelHelper.toVietnamese(normalized) : 'Chưa rõ';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: activeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: activeColor.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(3, (index) {
            final isActive = index < rank;
            return Padding(
              padding: EdgeInsets.only(right: index == 2 ? 0 : 2.w),
              child: Icon(
                Icons.keyboard_arrow_up_rounded,
                size: 14.sp,
                color: isActive ? activeColor : Colors.grey.shade400,
              ),
            );
          }),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: activeColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TopicCubit>.value(
      value: cubit,
      child: Scaffold(
        appBar: BasicAppbar(
          title: widget.subjectName,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0.w,
            vertical: 12.0.h,
          ),
          child: PaginationListView<TopicEntity>(
            cubit: cubit,
            itemBuilder: (context, topic) {
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: topic.image != null && topic.image!.isNotEmpty
                      ? SizedBox(
                          width: 56.w,
                          height: 56.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: Image.network(
                              topic.image!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.image_not_supported),
                            ),
                          ),
                        )
                      : Icon(Icons.play_lesson, color: AppColor.skyblue600),
                  title: Text(
                    topic.name ?? 'No title',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (topic.description != null &&
                          topic.description!.trim().isNotEmpty)
                        Text(
                          topic.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      SizedBox(height: 6.h),
                      _buildTopicLevelIndicator(topic.level),
                    ],
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 18.sp,
                    color: AppColor.skyblue600,
                  ),
                  onTap: () => _openTopic(topic),
                ),
              );
            },
            emptyWidget: const Center(
              child: AppEmptyState(message: 'Không có chủ đề nào'),
            ),
          ),
        ),
      ),
    );
  }
}
