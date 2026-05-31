import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:sci_fun/common/widget/app_loading_indicator.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/quizz/domain/entity/quizz_result_entity.dart';
import 'package:sci_fun/features/quizz/domain/usecase/get_submission_detail.dart'
    as quizz_get_submission_detail;
import 'package:sci_fun/features/quizz/presentation/cubit/submission_detail_cubit.dart';

class SubmissionDetailPage extends StatelessWidget {
  const SubmissionDetailPage({
    super.key,
    required this.submissionId,
    required this.pro,
  });

  final String submissionId;
  final bool pro;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubmissionDetailCubit(
        sl<quizz_get_submission_detail.GetSubmissionDetail>(),
      )..fetchSubmission(submissionId),
      child: Scaffold(
        appBar: const BasicAppbar(
          title: 'Chi tiết bài làm',
        ),
        body: BlocBuilder<SubmissionDetailCubit, SubmissionDetailState>(
          builder: (context, state) {
            if (state is SubmissionDetailLoading) {
              return const Center(
                child: AppLoadingIndicator(
                  message: 'Đang tải chi tiết bài làm...',
                ),
              );
            }

            if (state is SubmissionDetailError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    'Lỗi: ${state.message}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }

            if (state is SubmissionDetailLoaded) {
              return _SubmissionLoadedView(
                data: state.quizzResult,
                pro: pro,
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _SubmissionLoadedView extends StatelessWidget {
  const _SubmissionLoadedView({
    required this.data,
    required this.pro,
  });

  final QuizzResult data;
  final bool pro;

  @override
  Widget build(BuildContext context) {
    final answers = data.answers;

    return Container(
      color: AppColor.skyblue50.withValues(alpha: 0.28),
      child: ListView(
        padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 20.h),
        children: [
          _SubmissionHeaderCard(data: data),
          SizedBox(height: 14.h),
          _AnswerSectionTitle(answerCount: answers.length),
          SizedBox(height: 10.h),
          if (answers.isEmpty)
            _EmptyAnswersCard()
          else
            ...List.generate(
              answers.length,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: _AnswerItemCard(
                  index: index + 1,
                  answer: answers[index],
                  pro: pro,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SubmissionHeaderCard extends StatelessWidget {
  const _SubmissionHeaderCard({
    required this.data,
  });

  final QuizzResult data;

  @override
  Widget build(BuildContext context) {
    final score = data.score ?? 0;
    final answersCount = data.answers.length;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.skyblue500,
            AppColor.skyblue700,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.skyblue700.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.quiz?.title?.trim().isNotEmpty == true
                      ? data.quiz!.title!.trim()
                      : 'Bài kiểm tra',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'ID: ${data.submissionId ?? ''}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.28),
                    ),
                  ),
                  child: Text(
                    '$answersCount câu đã làm',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                constraints: BoxConstraints(minWidth: 52.w),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '$score',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColor.skyblue700,
                    height: 1,
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                'Điểm',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnswerSectionTitle extends StatelessWidget {
  const _AnswerSectionTitle({
    required this.answerCount,
  });

  final int answerCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Câu trả lời',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColor.skyblue100,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '$answerCount câu',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.skyblue700,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyAnswersCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: AppColor.skyblue200,
        ),
      ),
      child: Text(
        'Chưa có câu trả lời nào trong bài làm này.',
        style: TextStyle(
          fontSize: 13.sp,
          color: const Color(0xFF4B5563),
        ),
      ),
    );
  }
}

class _AnswerItemCard extends StatelessWidget {
  const _AnswerItemCard({
    required this.index,
    required this.answer,
    required this.pro,
  });

  final int index;
  final Answer answer;
  final bool pro;

  @override
  Widget build(BuildContext context) {
    final isCorrect = answer.isCorrect ?? false;
    final statusColor =
        isCorrect ? const Color(0xFF1F9D5C) : const Color(0xFFF04438);
    final selectedAnswers = answer.selectedAnswers.isNotEmpty
        ? answer.selectedAnswers
        : const ['Không chọn đáp án'];
    final correctAnswers = answer.correctAnswers.isNotEmpty
        ? answer.correctAnswers
        : const ['Không có dữ liệu đáp án'];
    final explanation = (answer.explanation ?? '').trim();

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34.w,
                height: 34.w,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$index',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16.sp,
                      height: 1,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Text(
                    answer.questionText?.trim().isNotEmpty == true
                        ? answer.questionText!.trim()
                        : 'Câu hỏi $index',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                      height: 1.35,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCorrect ? Symbols.check_rounded : Symbols.close_rounded,
                  size: 18.sp,
                  color: statusColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          _AnswerGroupCard(
            title: 'Bạn đã chọn',
            answers: selectedAnswers,
            backgroundColor: AppColor.skyblue50,
            borderColor: AppColor.skyblue200,
            textColor: const Color(0xFF1F2937),
            chipColor: AppColor.skyblue100,
            chipBorderColor: AppColor.skyblue300,
            chipTextColor: AppColor.skyblue800,
          ),
          SizedBox(height: 8.h),
          _LockedContent(
            isLocked: !pro,
            lockMessage: 'Nâng cấp Pro để xem đáp án đúng',
            borderRadius: BorderRadius.circular(12.r),
            child: _AnswerGroupCard(
              title: 'Đáp án đúng',
              answers: correctAnswers,
              backgroundColor: const Color(0xFFEEF9F1),
              borderColor: const Color(0xFFB6E1C4),
              textColor: const Color(0xFF14532D),
              chipColor: const Color(0xFFD9F2E1),
              chipBorderColor: const Color(0xFFA6D9B7),
              chipTextColor: const Color(0xFF17653C),
            ),
          ),
          if (explanation.isNotEmpty) ...[
            SizedBox(height: 8.h),
            _LockedContent(
              isLocked: !pro,
              lockMessage: 'Nâng cấp Pro để xem giải thích',
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                  ),
                ),
                child: Text(
                  'Giải thích: $explanation',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF374151),
                    height: 1.45,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AnswerGroupCard extends StatelessWidget {
  const _AnswerGroupCard({
    required this.title,
    required this.answers,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.chipColor,
    required this.chipBorderColor,
    required this.chipTextColor,
  });

  final String title;
  final List<String> answers;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color chipColor;
  final Color chipBorderColor;
  final Color chipTextColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: textColor.withValues(alpha: 0.9),
            ),
          ),
          SizedBox(height: 7.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 7.h,
            children: answers
                .map(
                  (text) => _AnswerPill(
                    text: text,
                    backgroundColor: chipColor,
                    borderColor: chipBorderColor,
                    textColor: chipTextColor,
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _AnswerPill extends StatelessWidget {
  const _AnswerPill({
    required this.text,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });

  final String text;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 0.72.sw),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(11.r),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          color: textColor,
          height: 1.35,
        ),
      ),
    );
  }
}

class _LockedContent extends StatelessWidget {
  const _LockedContent({
    required this.isLocked,
    required this.lockMessage,
    required this.borderRadius,
    required this.child,
  });

  final bool isLocked;
  final String lockMessage;
  final BorderRadius borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!isLocked) {
      return child;
    }

    return Stack(
      children: [
        child,
        Positioned.fill(
          child: ClipRRect(
            borderRadius: borderRadius,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4.5, sigmaY: 4.5),
              child: Container(
                color: Colors.white.withValues(alpha: 0.65),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 7.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: const Color(0xFFD1D5DB),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Symbols.lock_rounded,
                        size: 15.sp,
                        color: const Color(0xFF6B7280),
                      ),
                      SizedBox(width: 6.w),
                      Flexible(
                        child: Text(
                          lockMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF4B5563),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
