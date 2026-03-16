import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/cubit/pagination_cubit.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/widget/pagination_list_view.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/services/share_prefs_service.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/subject/domain/entity/subject_entity.dart';
import 'package:sci_fun/features/subject/presentation/cubit/subject_cubit.dart';
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

  @override
  void initState() {
    super.initState();
    cubit = sl<TopicCubit>();
    cubit.loadInitial(filterId: widget.subjectId);
  }

  @override
  void didUpdateWidget(TopicPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.subjectId != widget.subjectId) {
      cubit.loadInitial(filterId: widget.subjectId);
    }
  }

  void _openSubjectSwitcher() {
    final subjectCubit = context.read<SubjectCubit>();
    final state = subjectCubit.state;

    if (state is! PaginationSuccess<SubjectEntity> &&
        state is! PaginationLoading<SubjectEntity> &&
        state is! PaginationLoadingMore<SubjectEntity>) {
      subjectCubit.loadInitial(searchQuery: '');
    }

    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: BlocBuilder<SubjectCubit, PaginationState<SubjectEntity>>(
            builder: (context, subjectState) {
              if (subjectState is PaginationLoading<SubjectEntity>) {
                return SizedBox(
                  height: 220.h,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              if (subjectState is PaginationSuccess<SubjectEntity>) {
                final subjects = subjectState.items
                    .where((subject) => (subject.id ?? '').isNotEmpty)
                    .toList();

                if (subjects.isEmpty) {
                  return SizedBox(
                    height: 220.h,
                    child: const Center(
                      child: Text('Khong co mon hoc nao'),
                    ),
                  );
                }

                return SizedBox(
                  height: 420.h,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 10.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Chuyen mon hoc',
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.of(sheetContext).pop(),
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: subjects.length,
                          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
                          separatorBuilder: (_, __) => SizedBox(height: 8.h),
                          itemBuilder: (_, index) {
                            final subject = subjects[index];
                            final subjectName =
                                subject.name?.trim().isNotEmpty == true
                                    ? subject.name!.trim()
                                    : 'Mon hoc';
                            final isCurrent = subject.id == widget.subjectId;

                            return ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              tileColor:
                                  isCurrent ? AppColor.skyblue50 : Colors.white,
                              title: Text(
                                subjectName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isCurrent
                                      ? AppColor.skyblue700
                                      : Colors.black87,
                                ),
                              ),
                              trailing: Icon(
                                isCurrent
                                    ? Icons.check_circle_rounded
                                    : Icons.arrow_forward_ios_rounded,
                                size: isCurrent ? 22.sp : 16.sp,
                                color: isCurrent
                                    ? AppColor.skyblue600
                                    : Colors.black54,
                              ),
                              onTap: () async {
                                if (isCurrent) {
                                  Navigator.of(sheetContext).pop();
                                  return;
                                }

                                final targetId = subject.id ?? '';
                                if (targetId.isEmpty) {
                                  Navigator.of(sheetContext).pop();
                                  return;
                                }

                                await sl<SharePrefsService>()
                                    .saveSelectedSubject(
                                  subjectId: targetId,
                                  subjectName: subjectName,
                                );

                                if (!context.mounted) {
                                  return;
                                }

                                Navigator.of(sheetContext).pop();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TopicPage(
                                      subjectId: targetId,
                                      subjectName: subjectName,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }

              return SizedBox(
                height: 220.h,
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      context.read<SubjectCubit>().loadInitial(searchQuery: '');
                    },
                    child: const Text('Tai lai danh sach mon'),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TopicCubit>.value(
      value: cubit,
      child: Scaffold(
        appBar: BasicAppbar(
          title: widget.subjectName,
          rightIcon: IconButton(
            tooltip: 'Chuyen mon',
            icon: Icon(
              Icons.swap_horiz_rounded,
              color: AppColor.skyblue600,
            ),
            onPressed: _openSubjectSwitcher,
          ),
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
                  subtitle: topic.description != null
                      ? Text(
                          topic.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 18.sp,
                    color: AppColor.skyblue600,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPage(
                          topicId: topic.id ?? '',
                          topicName: topic.name ?? '',
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            emptyWidget: const Center(child: Text('No topics found')),
          ),
        ),
      ),
    );
  }
}
