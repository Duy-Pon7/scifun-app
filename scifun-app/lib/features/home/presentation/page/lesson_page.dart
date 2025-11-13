import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/common/widget/topic_item.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/home/presentation/components/lesson/tab_lesson.dart';
import 'package:sci_fun/features/home/presentation/components/lesson/theory_content.dart';
import 'package:sci_fun/features/home/presentation/components/lesson/video_content.dart';
import 'package:sci_fun/features/home/presentation/cubit/lesson_cubit.dart';
import 'package:sci_fun/features/home/presentation/cubit/quizz_cubit.dart';
import 'package:sci_fun/features/home/presentation/cubit/select_tab_cubit.dart';
import 'package:sci_fun/features/home/presentation/page/homework_result_page.dart';
import 'package:sci_fun/features/home/presentation/page/test_history_literature_page.dart';
import 'package:sci_fun/features/home/presentation/page/test_literature_page.dart';
import 'package:sci_fun/features/home/presentation/page/test_page.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({super.key, required this.lessonId});
  final int lessonId;

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<SelectTabCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<QuizzCubit>(),
        ),
        BlocProvider(
          create: (context) =>
              sl<LessonCubit>()..getLesson(lessonId: widget.lessonId),
        )
      ],
      child: Scaffold(
        appBar: BasicAppbar(
          title: Text(
            "Bài học",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColor.primary600,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            Builder(
              builder: (context) {
                return BlocBuilder<LessonCubit, LessonState>(
                  builder: (context, state) {
                    if (state is LessonDetailLoaded) {
                      final last = state.lessonEntity.latestQuizResult != null;
                      return IconButton(
                        icon: Icon(
                          Icons.history,
                          color: last ? AppColor.primary600 : Colors.brown,
                        ),
                        onPressed: last
                            ? () async {
                                // Lấy cubit
                                final lessonCubit = context.read<LessonCubit>();

                                // Lấy dữ liệu mới nhất
                                await lessonCubit.getLesson(
                                    lessonId: widget.lessonId);

                                // Lấy state hiện tại
                                final state = lessonCubit.state;

                                if (state is LessonDetailLoaded) {
                                  final quizzId = state.lessonEntity
                                          .latestQuizResult?.quizId ??
                                      0;
                                  final quizzType = state.lessonEntity.quizz[0]
                                      .categorySubject!.type!;

                                  // Lấy QuizzCubit
                                  final quizzCubit = context.read<QuizzCubit>();
                                  quizzCubit.getDetailQuizz(quizzId: quizzId);

                                  if (quizzType == 'literature') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BlocProvider.value(
                                          value: quizzCubit,
                                          child: TestHistoryLiteraturePage(
                                              quizzId: quizzId),
                                        ),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BlocProvider.value(
                                          value: quizzCubit,
                                          child: HomeworkResultPage(
                                              quizzId: quizzId),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              }
                            : null,
                      );
                    }
                    return SizedBox();
                  },
                );
              },
            ),
          ],
        ),
        backgroundColor: AppColor.hurricane50,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: TabLesson(),
            ),
            Expanded(
              child: BlocBuilder<SelectTabCubit, int>(
                builder: (context, selectedIndex) {
                  return IndexedStack(
                    index: selectedIndex,
                    children: [
                      TheoryContent(),
                      VideoContent(),
                    ],
                  );
                },
              ),
            ),
            BlocBuilder<LessonCubit, LessonState>(
              builder: (context, state) {
                if (state is LessonDetailLoaded) {
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(
                              color: Colors.black.withValues(alpha: 0.3),
                              width: 0.3),
                        ),
                      ),
                      child: Row(
                        spacing: 12.w,
                        children: [
                          Expanded(
                            child: BasicButton(
                              text: "Bài tập tự luyện",
                              fontSize: 20.sp,
                              onPressed: () {},
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 16.h,
                              ),
                              backgroundColor: Colors.transparent,
                              border: true,
                              borderWidth: 1,
                              textColor: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: BasicButton(
                              text: "Kiểm tra",
                              fontSize: 20.sp,
                              onPressed: () {
                                final quizzes = state
                                    .lessonEntity.quizz; // Lấy từ dữ liệu đã có

                                Navigator.push(
                                  context,
                                  slidePage(
                                    Scaffold(
                                      appBar: BasicAppbar(
                                        title: Text(
                                          "Danh sách bài kiểm tra",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                fontSize: 17.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        centerTitle: true,
                                        leading: IconButton(
                                          icon: Icon(
                                            Icons.arrow_back_ios_rounded,
                                            color: AppColor.primary600,
                                          ),
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                        ),
                                      ),
                                      body: ListView.builder(
                                        itemCount: quizzes.length,
                                        itemBuilder: (context, index) {
                                          final quizz = quizzes[index];
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.w,
                                                vertical: 8.h),
                                            child: TopicItem(
                                              title: quizz.name ?? "",
                                              onTap: () {
                                                print("Quizz ID: ${quizz.id}");
                                                Navigator.push(
                                                  context,
                                                  slidePage(
                                                    quizz.categorySubject
                                                                ?.type ==
                                                            'literature'
                                                        ? TestLiteraturePage(
                                                            quizzId:
                                                                quizz.id ?? 0)
                                                        : TestPage(
                                                            quizzId:
                                                                quizz.id ?? 0),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 16.h,
                              ),
                              backgroundColor: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            )
          ],
        ),
      ),
    );
  }
}
