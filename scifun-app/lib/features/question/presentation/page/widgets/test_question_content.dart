import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/question/domain/entity/question_entity.dart';

class TestQuestionContent extends StatelessWidget {
  const TestQuestionContent({
    super.key,
    required this.exitButton,
    required this.items,
    required this.currentIndex,
    required this.question,
    required this.selectedIds,
    required this.checkedCorrectAnswerIds,
    required this.isMultiSelect,
    required this.isSubmitting,
    required this.isCheckingAnswer,
    required this.isAnswerChecked,
    required this.currentAnswerIsCorrect,
    required this.isExplanationExpanded,
    required this.currentExplanation,
    required this.onToggleExplanation,
    required this.onAnswerTap,
    required this.onPrimaryAction,
  });

  final Widget exitButton;
  final List<QuestionEntity> items;
  final int currentIndex;
  final QuestionEntity question;
  final List<String> selectedIds;
  final Set<String> checkedCorrectAnswerIds;
  final bool isMultiSelect;
  final bool isSubmitting;
  final bool isCheckingAnswer;
  final bool isAnswerChecked;
  final bool currentAnswerIsCorrect;
  final bool isExplanationExpanded;
  final String currentExplanation;
  final VoidCallback onToggleExplanation;
  final void Function(String answerId) onAnswerTap;
  final VoidCallback onPrimaryAction;

  @override
  Widget build(BuildContext context) {
    final progress = (currentIndex + 1) / items.length;
    final isLastQuestion = currentIndex == items.length - 1;
    final canAction = isAnswerChecked
        ? !isSubmitting && !isCheckingAnswer
        : selectedIds.isNotEmpty && !isSubmitting && !isCheckingAnswer;
    final primaryLabel = isSubmitting
        ? 'ĐANG GỬI...'
        : isCheckingAnswer
            ? 'ĐANG KIỂM TRA...'
            : isAnswerChecked
                ? (isLastQuestion ? 'NỘP BÀI' : 'TIẾP TỤC')
                : 'KIỂM TRA';
    final accent = AppColor.skyblue500;
    final accentDark = AppColor.skyblue700;
    final accentLight = AppColor.skyblue100;
    final accentMid = AppColor.skyblue300;
    final explanationText = currentExplanation.trim();
    final hasExplanation = explanationText.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            exitButton,
            SizedBox(width: 8.w),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999.r),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 14.h,
                  backgroundColor: const Color(0xFFD9D9D9),
                  valueColor: AlwaysStoppedAnimation<Color>(accent),
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Icon(
              Symbols.favorite_rounded,
              color: const Color(0xFFF8505D),
              size: 24.sp,
            ),
            SizedBox(width: 4.w),
            Text(
              '${items.length}',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFE34D57),
                height: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        Text(
          'Chọn câu đúng',
          style: TextStyle(
            fontSize: 39.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF333333),
            height: 1.1,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120.w,
              height: 120.w,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Lottie.asset(
                  'assets/lottie_json/cat.json',
                  repeat: true,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: QuestionWordBubble(text: question.text ?? ''),
              ),
            ),
          ],
        ),
        if (isMultiSelect)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              'Có thể chọn nhiều đáp án',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.hurricane500,
              ),
            ),
          ),
        if (isAnswerChecked)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              currentAnswerIsCorrect
                  ? 'Bạn đã chọn đúng.'
                  : 'Câu này chưa đúng. Đáp án đúng được tô màu xanh.',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: currentAnswerIsCorrect
                    ? const Color(0xFF1B5E20)
                    : const Color(0xFFB71C1C),
              ),
            ),
          ),
        if (isAnswerChecked && hasExplanation)
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: InkWell(
              borderRadius: BorderRadius.circular(12.r),
              onTap: onToggleExplanation,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: accent.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Giải thích',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: accentDark,
                        ),
                      ),
                    ),
                    Icon(
                      isExplanationExpanded
                          ? Symbols.keyboard_arrow_up_rounded
                          : Symbols.keyboard_arrow_down_rounded,
                      color: accentDark,
                      size: 22.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (isAnswerChecked && hasExplanation && isExplanationExpanded)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColor.hurricane200,
                ),
              ),
              child: Text(
                explanationText,
                style: TextStyle(
                  fontSize: 18.sp,
                  color: const Color(0xFF3D3D3D),
                  height: 1.45,
                ),
              ),
            ),
          ),
        SizedBox(height: 16.h),
        Expanded(
          child: ListView.separated(
            itemCount: question.answers.length,
            separatorBuilder: (_, __) => SizedBox(height: 10.h),
            itemBuilder: (context, index) {
              final answer = question.answers[index];
              final answerId = answer.id;
              final isSelected =
                  answerId != null && selectedIds.contains(answerId);
              final isCorrectAnswer = answerId != null &&
                  checkedCorrectAnswerIds.contains(answerId);
              final isWrongSelected =
                  isAnswerChecked && isSelected && !isCorrectAnswer;
              final shouldHighlightCorrect = isAnswerChecked && isCorrectAnswer;

              final borderColor = isAnswerChecked
                  ? shouldHighlightCorrect
                      ? const Color(0xFF66BB6A)
                      : isWrongSelected
                          ? const Color(0xFFEF5350)
                          : AppColor.hurricane200
                  : (isSelected ? AppColor.skyblue400 : AppColor.hurricane200);

              final backgroundColor = isAnswerChecked
                  ? shouldHighlightCorrect
                      ? const Color(0xFFE8F5E9)
                      : isWrongSelected
                          ? const Color(0xFFFFEBEE)
                          : Colors.white
                  : (isSelected ? accentLight : Colors.white);

              final buttonColor = isAnswerChecked
                  ? shouldHighlightCorrect
                      ? const Color(0xFFA5D6A7)
                      : isWrongSelected
                          ? const Color(0xFFEF9A9A)
                          : AppColor.hurricane100
                  : (isSelected ? accentMid : AppColor.hurricane100);

              final textColor = isAnswerChecked
                  ? shouldHighlightCorrect
                      ? const Color(0xFF1B5E20)
                      : isWrongSelected
                          ? const Color(0xFFB71C1C)
                          : const Color(0xFF4B4B4B)
                  : (isSelected ? accentDark : const Color(0xFF4B4B4B));

              final statusIcon = shouldHighlightCorrect
                  ? Symbols.check_circle_rounded
                  : (isWrongSelected ? Symbols.cancel_rounded : null);
              final statusIconColor = shouldHighlightCorrect
                  ? const Color(0xFF2E7D32)
                  : const Color(0xFFC62828);

              final canTapAnswer = answerId != null &&
                  !isSubmitting &&
                  !isCheckingAnswer &&
                  !isAnswerChecked;

              return BasicButton(
                onPressed: canTapAnswer ? () => onAnswerTap(answerId) : () {},
                width: double.infinity,
                height: 66.h,
                borderRadius: BorderRadius.circular(16.r),
                border: true,
                borderWidth: (isSelected || isAnswerChecked) ? 1.8 : 1.2,
                borderColor: borderColor,
                backgroundColor: backgroundColor,
                buttonColor: buttonColor,
                textColor: textColor,
                buttonHeight: (isSelected || isAnswerChecked) ? 5 : 4,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        answer.text ?? '',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 23.sp,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ),
                    if (statusIcon != null) ...[
                      SizedBox(width: 8.w),
                      Icon(
                        statusIcon,
                        size: 20.sp,
                        color: statusIconColor,
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12.h),
        BasicButton(
          text: primaryLabel,
          width: double.infinity,
          height: 56.h,
          borderRadius: BorderRadius.circular(16.r),
          fontSize: 27.sp,
          fontWeight: FontWeight.w700,
          textColor: canAction ? Colors.white : AppColor.hurricane300,
          backgroundColor: canAction ? accent : AppColor.hurricane100,
          buttonColor: canAction ? accentDark : AppColor.hurricane200,
          onPressed: canAction ? onPrimaryAction : () {},
        ),
      ],
    );
  }
}

class QuestionWordBubble extends StatelessWidget {
  const QuestionWordBubble({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    const Color borderColor = Color(0xFFE2E2E2);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: borderColor, width: 1.3),
          ),
          child: Text(
            text,
            textAlign: TextAlign.left,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 30.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF3D3D3D),
              height: 1.2,
            ),
          ),
        ),
        Positioned(
          left: -7.w,
          top: 22.h,
          child: Transform.rotate(
            angle: -0.785398,
            child: Container(
              width: 15.w,
              height: 15.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  left: BorderSide(color: borderColor, width: 1.3),
                  top: BorderSide(color: borderColor, width: 1.3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
