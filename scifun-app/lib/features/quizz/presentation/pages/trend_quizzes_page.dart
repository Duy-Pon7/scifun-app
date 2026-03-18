import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/app_loading_indicator.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/features/quizz/presentation/cubit/trend_quizz_cubit.dart';
import 'package:sci_fun/features/question/presentation/page/test_page.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';

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
                child: Text('Không có bài kiểm tra thịnh hành'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Bài kiểm tra thịnh hành',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(
                height: 150.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  itemBuilder: (context, index) {
                    final quizz = items[index];
                    final isPro = quizz.score != null && quizz.score! > 0.8;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          slidePage(TestPage(quizzId: quizz.id ?? '')),
                        );
                      },
                      child: SizedBox(
                        width: 260.w,
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
                                                      BorderRadius.circular(
                                                          6.0),
                                                  child: Image.network(
                                                    quizz
                                                        .topic!.subject!.image!,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (_, __,
                                                            ___) =>
                                                        const Icon(Icons
                                                            .image_not_supported),
                                                  ),
                                                ),
                                              )
                                            : Icon(Icons.quiz,
                                                color: AppColor.skyblue600),
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
                                                  'Điểm: ${(quizz.score! * 100).toStringAsFixed(0)}%',
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
                                            color: Colors.grey[700]),
                                      ),
                                    SizedBox(height: isCompact ? 4.h : 8.h),
                                    Row(
                                      children: [
                                        Icon(Icons.timer,
                                            size: 12.sp,
                                            color: AppColor.skyblue600),
                                        SizedBox(width: 6.w),
                                        Text('${quizz.duration ?? 0} phút',
                                            style: TextStyle(fontSize: 12.sp)),
                                        SizedBox(width: 12.w),
                                        Icon(Icons.help_outline,
                                            size: 12.sp,
                                            color: AppColor.skyblue600),
                                        SizedBox(width: 6.w),
                                        Text('${quizz.questionCount ?? 0} câu',
                                            style: TextStyle(fontSize: 12.sp)),
                                      ],
                                    )
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
}
