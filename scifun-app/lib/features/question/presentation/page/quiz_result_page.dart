import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/helper/get_category_score.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/common/widget/basic_confetti.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/profile/presentation/cubit/pro_cubit.dart';
import 'package:sci_fun/features/quizz/presentation/pages/submission_detail_page.dart';

class QuizResultPage extends StatefulWidget {
  const QuizResultPage({
    super.key,
    required this.result,
  });

  final Map<String, dynamic> result;

  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  bool _didLaunchConfetti = false;

  @override
  Widget build(BuildContext context) {
    final int correctAnswers = widget.result['correctAnswers'] ?? 0;
    final dynamic scoreValue = widget.result['score'] ?? 0;
    final int totalQuestions = widget.result['totalQuestions'] ?? 0;

    final double score = scoreValue is num
        ? scoreValue.toDouble()
        : double.tryParse(scoreValue.toString()) ?? 0;

    final int scoreInt = score.toInt();
    final String performanceTitle = getCategoryScore(scoreInt);

    final Color performanceColor;
    bool shouldCelebrate = false;
    if (scoreInt >= 90) {
      performanceColor = const Color(0xFF17A2B8);
      shouldCelebrate = true;
    } else if (scoreInt >= 80) {
      performanceColor = const Color(0xFF28A745);
      shouldCelebrate = true;
    } else if (scoreInt >= 65) {
      performanceColor = const Color(0xFF0066CC);
      shouldCelebrate = true;
    } else if (scoreInt >= 50) {
      performanceColor = const Color(0xFFFF9800);
    } else {
      performanceColor = const Color(0xFFDC3545);
    }

    if (shouldCelebrate && !_didLaunchConfetti) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _didLaunchConfetti) return;
        _didLaunchConfetti = true;
        launchSuccessConfetti(context);
      });
    }

    final Color accent = AppColor.skyblue500;
    final Color accentDark = AppColor.skyblue700;
    final Color accentLight = AppColor.skyblue50;

    return Scaffold(
      appBar: BasicAppbar(
        title: 'Kết quả bài làm',
        onBackPress: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE5E5),
                  borderRadius: BorderRadius.circular(24.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 32.h),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.emoji_events,
                      size: 120.sp,
                      color: const Color(0xFFFFC107),
                    ),
                    Positioned(
                      left: 20.w,
                      top: 20.h,
                      child: Icon(
                        Icons.star,
                        size: 24.sp,
                        color: const Color(0xFFFFD700),
                      ),
                    ),
                    Positioned(
                      right: 30.w,
                      top: 40.h,
                      child: Container(
                        width: 16.w,
                        height: 16.h,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF6B9D),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 40.w,
                      bottom: 30.h,
                      child: Container(
                        width: 12.w,
                        height: 12.h,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFD700),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 20.w,
                      bottom: 40.h,
                      child: Icon(
                        Icons.star,
                        size: 16.sp,
                        color: const Color(0xFFFFD700),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                performanceTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: performanceColor,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Hoàn thành kiểm tra',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 32.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    value: correctAnswers.toString(),
                    label: 'Số câu đúng',
                  ),
                  _buildStatItem(
                    value: score.toStringAsFixed(1),
                    label: 'Điểm',
                  ),
                  _buildStatItem(
                    value: '$totalQuestions\'0"',
                    label: 'Thời gian',
                  ),
                ],
              ),
              SizedBox(height: 40.h),
              BasicButton(
                onPressed: () {
                  final submissionId = widget.result['submissionId'] ?? '';
                  if (submissionId.isEmpty) {
                    Navigator.of(context).pop();
                    return;
                  }
                  final isPro = context.read<ProCubit>().state;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SubmissionDetailPage(
                        submissionId: submissionId,
                        pro: isPro,
                      ),
                    ),
                  );
                },
                text: 'Xem đáp án',
                width: double.infinity,
                height: 52.h,
                borderRadius: BorderRadius.circular(12.r),
                border: true,
                borderWidth: 1.5.w,
                borderColor: accent,
                backgroundColor: Colors.white,
                buttonColor: accentLight,
                textColor: accent,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 12.h),
              BasicButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                text: 'Quay về',
                width: double.infinity,
                height: 52.h,
                borderRadius: BorderRadius.circular(12.r),
                backgroundColor: accent,
                buttonColor: accentDark,
                textColor: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
