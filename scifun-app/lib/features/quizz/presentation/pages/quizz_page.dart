import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/widget/pagination_list_view.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/quizz/presentation/cubit/quizz_cubit.dart';
import 'package:sci_fun/features/quizz/domain/entity/quizz_entity.dart';
import 'package:sci_fun/features/question/presentation/page/test_page.dart';

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

  @override
  void initState() {
    super.initState();
    cubit = sl<QuizzCubit>();
    cubit.loadInitial(filterId: widget.topicId);
  }

  @override
  void didUpdateWidget(QuizzPage oldWidget) {
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
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 12.0.h),
          child: PaginationListView<QuizzEntity>(
            cubit: cubit,
            itemBuilder: (context, quizz) {
              final isPro = quizz.accessTier == 'PRO';
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(
                    color: isPro ? AppColor.primary600 : Colors.grey[300]!,
                    width: isPro ? 2.0 : 1.0,
                  ),
                ),
                child: Stack(
                  children: [
                    ListTile(
                      leading: quizz.topic?.subject?.image != null &&
                              (quizz.topic?.subject?.image ?? '').isNotEmpty
                          ? SizedBox(
                              width: 56.w,
                              height: 56.h,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6.0),
                                child: Image.network(
                                  quizz.topic!.subject!.image!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.image_not_supported),
                                ),
                              ),
                            )
                          : Icon(Icons.quiz, color: AppColor.primary600),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              quizz.title ?? 'No title',
                              style: TextStyle(
                                fontWeight:
                                    isPro ? FontWeight.bold : FontWeight.w600,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: isPro ? AppColor.primary600 : Colors.green,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Text(
                              isPro ? 'PRO' : 'FREE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
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
                          Row(
                            children: [
                              Icon(Icons.timer,
                                  size: 14.sp, color: AppColor.primary600),
                              SizedBox(width: 6.w),
                              Text(
                                '${quizz.duration ?? 0} phút',
                                style: TextStyle(fontSize: 12.sp),
                              ),
                              SizedBox(width: 12.w),
                              Icon(Icons.help_outline,
                                  size: 14.sp, color: AppColor.primary600),
                              SizedBox(width: 6.w),
                              Text(
                                '${quizz.questionCount ?? 0} câu',
                                style: TextStyle(fontSize: 12.sp),
                              ),
                              if (quizz.uniqueUserCount != null &&
                                  quizz.uniqueUserCount! > 0) ...[
                                SizedBox(width: 12.w),
                                Icon(Icons.people,
                                    size: 14.sp, color: AppColor.primary600),
                                SizedBox(width: 4.w),
                                Text(
                                  '${quizz.uniqueUserCount}',
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                              ]
                            ],
                          )
                        ],
                      ),
                      onTap: () {
                        // Navigate to TestPage với quizzId
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
                    if (isPro)
                      Positioned(
                        top: 8.h,
                        right: 8.w,
                        child: Icon(
                          Icons.star,
                          color: AppColor.primary600,
                          size: 18.sp,
                        ),
                      ),
                  ],
                ),
              );
            },
            emptyWidget: const Center(child: Text('Không có bài kiểm tra')),
          ),
        ),
      ),
    );
  }
}
