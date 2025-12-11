import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/features/quizz/presentation/cubit/trend_quizz_cubit.dart';
import 'package:sci_fun/features/question/presentation/page/test_page.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';

class TrendQuizzesList extends StatelessWidget {
  const TrendQuizzesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TrendQuizzCubit>()..fetchTrendQuizzes(),
      child: BlocBuilder<TrendQuizzCubit, TrendQuizzState>(
        builder: (context, state) {
          if (state is TrendQuizzLoading) {
            return const Center(child: CircularProgressIndicator());
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
                                  ? AppColor.primary600
                                  : Colors.grey[300]!,
                              width: isPro ? 2.0 : 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    quizz.topic?.subject?.image != null &&
                                            (quizz.topic?.subject?.image ?? '')
                                                .isNotEmpty
                                        ? SizedBox(
                                            width: 56.w,
                                            height: 56.h,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6.0),
                                              child: Image.network(
                                                quizz.topic!.subject!.image!,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) =>
                                                    const Icon(Icons
                                                        .image_not_supported),
                                              ),
                                            ),
                                          )
                                        : Icon(Icons.quiz,
                                            color: AppColor.primary600),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            quizz.title ?? 'No title',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: isPro
                                                  ? FontWeight.bold
                                                  : FontWeight.w600,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                          if (quizz.score != null)
                                            Text(
                                              'Điểm: ${(quizz.score! * 100).toStringAsFixed(0)}%',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: AppColor.primary600,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                if (quizz.description != null)
                                  Text(
                                    quizz.description!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.grey[700]),
                                  ),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    Icon(Icons.timer,
                                        size: 12.sp,
                                        color: AppColor.primary600),
                                    SizedBox(width: 6.w),
                                    Text('${quizz.duration ?? 0} phút',
                                        style: TextStyle(fontSize: 12.sp)),
                                    SizedBox(width: 12.w),
                                    Icon(Icons.help_outline,
                                        size: 12.sp,
                                        color: AppColor.primary600),
                                    SizedBox(width: 6.w),
                                    Text('${quizz.questionCount ?? 0} câu',
                                        style: TextStyle(fontSize: 12.sp)),
                                  ],
                                )
                              ],
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
