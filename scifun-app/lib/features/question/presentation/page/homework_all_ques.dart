import 'package:flutter/material.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/features/home/presentation/widget/question_grid.dart';

class HomeworkAllQues extends StatelessWidget {
  final int totalQuestions;
  final int currentIndex;
  final List<int> answeredQuestionIndexes;
  final Function(int) onQuestionTap;

  const HomeworkAllQues({
    super.key,
    required this.totalQuestions,
    required this.currentIndex,
    required this.answeredQuestionIndexes,
    required this.onQuestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(title: "Tất cả câu hỏi"),
      body: SingleChildScrollView(
        child: QuestionGrid(
          totalQuestions: totalQuestions,
          currentIndex: currentIndex,
          answeredQuestionIndexes: answeredQuestionIndexes,
          onQuestionTap: onQuestionTap,
        ),
      ),
    );
  }
}
