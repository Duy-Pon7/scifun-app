import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/exam/presentation/widget/quiz_card.dart';
import 'package:sci_fun/features/home/presentation/cubit/quizz_cubit.dart';

class TestSubjectTopicQuizList extends StatelessWidget {
  final String titleSubject;
  final int lessonId;
  final String lessonTitle;

  const TestSubjectTopicQuizList({
    super.key,
    required this.titleSubject,
    required this.lessonId,
    required this.lessonTitle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<QuizzCubit>()
        ..fetchQuizzByLesson(
          page: 1,
          lessonId: lessonId,
        ),
      child: Scaffold(
        appBar: BasicAppbar(
          title: Text(
            lessonTitle,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon:
                Icon(Icons.arrow_back_ios_rounded, color: AppColor.primary600),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocBuilder<QuizzCubit, QuizzState>(
          builder: (context, state) {
            if (state is QuizzLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is QuizzListLoaded) {
              final quizzes = state.quizzes;

              if (quizzes.isEmpty) {
                return const Center(child: Text("Không có bài quiz nào."));
              }

              return GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                itemCount: quizzes.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.h,
                  mainAxisSpacing: 12.w,
                  childAspectRatio: 3 / 2.3,
                ),
                itemBuilder: (context, index) {
                  final quiz = quizzes[index];
                  final quizResult = quiz.quizResult;

                  String status = "Chưa hoàn thành";
                  int score = 0;

                  if (quizResult != null) {
                    final totalCorrect = quizResult.correctAnswers ?? 0;
                    status = "Đã hoàn thành";
                    score = totalCorrect; // hoặc quizResult.score ?? 0;
                  }

                  return QuizCard(
                    title: quiz.name ?? "Quiz ${index + 1}",
                    status: status,
                    score: score,
                    quizzId: quiz.id ?? 0,
                    titleSubject: titleSubject,
                    // Có thể thêm onTap để vào chi tiết quiz
                    // onTap: () => Navigator.push(...)
                  );
                },
              );
            }

            return const SizedBox(); // fallback nếu không đúng state
          },
        ),
      ),
    );
  }
}
