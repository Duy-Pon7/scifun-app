import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/features/quizz/domain/usecase/get_submission_detail.dart'
    as quizz_get_submission_detail;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/features/quizz/presentation/cubit/submission_detail_cubit.dart';

class SubmissionDetailPage extends StatelessWidget {
  final String submissionId;

  const SubmissionDetailPage({super.key, required this.submissionId});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubmissionDetailCubit(
        sl<quizz_get_submission_detail.GetSubmissionDetail>(),
      )..fetchSubmission(submissionId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chi tiết bài làm'),
          centerTitle: true,
          elevation: 1,
        ),
        body: BlocBuilder<SubmissionDetailCubit, SubmissionDetailState>(
          builder: (context, state) {
            if (state is SubmissionDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is SubmissionDetailError) {
              return Center(child: Text('Lỗi: ${state.message}'));
            }
            if (state is SubmissionDetailLoaded) {
              final data = state.quizzResult;
              return Padding(
                padding: EdgeInsets.all(12.w),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 14.w, vertical: 12.h),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.quiz?.title ?? 'Bài kiểm tra',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    Text(
                                      'ID: ${data.submissionId ?? ''}',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Chip(
                                    label: Text(
                                      '${data.score ?? 0}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp),
                                    ),
                                    backgroundColor: Colors.blue.shade50,
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    '${data.answers.length} câu',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Câu trả lời',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 8.h),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.answers.length,
                        separatorBuilder: (_, __) => SizedBox(height: 8.h),
                        itemBuilder: (context, index) {
                          final answer = data.answers[index];
                          final isCorrect = answer.isCorrect ?? false;
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r)),
                            elevation: 1,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 10.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 18.r,
                                    backgroundColor:
                                        isCorrect ? Colors.green : Colors.red,
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          answer.questionText ??
                                              'Câu ${index + 1}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14.sp),
                                        ),
                                        SizedBox(height: 8.h),
                                        Wrap(
                                          spacing: 8.w,
                                          runSpacing: 6.h,
                                          children: answer.selectedAnswers
                                              .map<Widget>((s) => Chip(
                                                    label: Text(s,
                                                        style: TextStyle(
                                                            fontSize: 12.sp)),
                                                    backgroundColor:
                                                        Colors.blue.shade50,
                                                  ))
                                              .toList(),
                                        ),
                                        SizedBox(height: 6.h),
                                        Wrap(
                                          spacing: 8.w,
                                          runSpacing: 6.h,
                                          children: answer.correctAnswers
                                              .map<Widget>((s) => Chip(
                                                    label: Text(s,
                                                        style: TextStyle(
                                                            fontSize: 12.sp,
                                                            color: Colors
                                                                .green[800])),
                                                    backgroundColor:
                                                        Colors.green.shade50,
                                                  ))
                                              .toList(),
                                        ),
                                        if ((answer.explanation ?? '')
                                            .isNotEmpty)
                                          Padding(
                                            padding:
                                                EdgeInsets.only(top: 8.0.h),
                                            child: Text(
                                              'Giải thích: ${answer.explanation}',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Icon(
                                    isCorrect
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color:
                                        isCorrect ? Colors.green : Colors.red,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
