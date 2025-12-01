import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/widget/pagination_list_view.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/topic/presentation/cubit/topic_cubit.dart';
import 'package:sci_fun/features/topic/domain/entity/topic_entity.dart';

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
  void dispose() {
    cubit.close();
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
          padding: const EdgeInsets.all(8.0),
          child: PaginationListView<TopicEntity>(
            cubit: cubit,
            itemBuilder: (context, topic) {
              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0),
                  leading: topic.image != null && topic.image!.isNotEmpty
                      ? SizedBox(
                          width: 56,
                          height: 56,
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
                      : const SizedBox(
                          width: 56,
                          height: 56,
                          child: Icon(Icons.book),
                        ),
                  title: Text(topic.name ?? 'No title'),
                  subtitle: topic.description != null
                      ? Text(
                          topic.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                  onTap: () {
                    // Placeholder for navigation to topic detail
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
