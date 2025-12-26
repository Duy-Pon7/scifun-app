import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/helper/get_category_score.dart';
import 'package:sci_fun/features/quizz/presentation/pages/submission_detail_page.dart';

class QuizResultPage extends StatelessWidget {
  final Map<String, dynamic> result;

  const QuizResultPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final int correctAnswers = result["correctAnswers"] ?? 0;
    final dynamic scoreValue = result["score"] ?? 0;
    final int totalQuestions = result["totalQuestions"] ?? 0;

    // Convert score to double if needed
    final double score =
        scoreValue is int ? scoreValue.toDouble() : scoreValue as double;

    // Determine performance level using getCategoryScore
    final String performanceTitle = getCategoryScore(score.toInt());

    final Color performanceColor;
    switch (performanceTitle) {
      case 'Xuất sắc':
        performanceColor = const Color(0xFF17A2B8);
        break;
      case 'Giỏi':
        performanceColor = const Color(0xFF28A745);
        break;
      case 'Khá':
        performanceColor = const Color(0xFF0066CC);
        break;
      case 'Trung bình':
        performanceColor = const Color(0xFFFF9800);
        break;
      default: // Chưa đạt
        performanceColor = const Color(0xFFDC3545);
    }

    return Scaffold(
      appBar: const BasicAppbar(title: 'Kết quả bài làm'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Trophy Section with pink background
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
                    // Trophy Icon
                    Icon(
                      Icons.emoji_events,
                      size: 120.sp,
                      color: const Color(0xFFFFC107),
                    ),
                    // Celebration particles
                    Positioned(
                      left: 20.w,
                      top: 20.h,
                      child: Icon(Icons.star,
                          size: 24.sp, color: const Color(0xFFFFD700)),
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
                      child: Icon(Icons.star,
                          size: 16.sp, color: const Color(0xFFFFD700)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              // Performance Title
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
              // Subtitle
              Text(
                'Hoàn thành kiểm tra',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 32.h),
              // Stats Row
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
                    value: '${totalQuestions}\'${0}"',
                    label: 'Thời gian',
                  ),
                ],
              ),
              SizedBox(height: 40.h),
              // Buttons
              OutlinedButton(
                onPressed: () {
                  final submissionId = result['submissionId'] ?? '';
                  if (submissionId.isEmpty) {
                    // fallback: just pop if no submission id
                    Navigator.of(context).pop();
                    return;
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SubmissionDetailPage(
                        submissionId: submissionId,
                        pro: false,
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  side: const BorderSide(color: Color(0xFF17A2B8), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  'Xem đáp án',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFF17A2B8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF17A2B8),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  'Bài học tiếp theo',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
