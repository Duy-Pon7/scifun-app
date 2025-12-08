import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/widget/pagination_list_view.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/topic/presentation/cubit/topic_cubit.dart';
import 'package:sci_fun/features/topic/domain/entity/topic_entity.dart';
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
    // Nếu subjectId thay đổi, reload dữ liệu
    if (oldWidget.subjectId != widget.subjectId) {
      cubit.loadInitial(filterId: widget.subjectId);
    }
  }

  @override
  void dispose() {
    // Không close cubit vì nó là LazySingleton
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TopicCubit>.value(
      value: cubit,
      child: Scaffold(
        appBar: BasicAppbar(
          title: widget.subjectName,
          // rightIcon: IconButton(
          //   icon: Icon(Icons.abc, color: AppColor.primary600),
          //   onPressed: () => Navigator.pop(context),
          // ),
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
                    borderRadius: BorderRadius.circular(8)),
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
                      : Icon(Icons.play_lesson, color: AppColor.primary600),
                  title: Text(topic.name ?? 'No title',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: topic.description != null
                      ? Text(
                          topic.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                  trailing: Icon(Icons.arrow_forward_ios,
                      size: 18.sp, color: AppColor.primary600),
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
