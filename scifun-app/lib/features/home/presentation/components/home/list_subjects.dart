import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/common/page/topic_page.dart';
import 'package:sci_fun/common/widget/topic_item.dart';
import 'package:sci_fun/common/widget/topic_item_lesson.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/features/home/domain/entity/lesson_category_entity.dart';
import 'package:sci_fun/features/home/domain/entity/lesson_entity.dart';
import 'package:sci_fun/features/home/domain/usecase/get_lesson_category.dart';
import 'package:sci_fun/features/home/domain/usecase/get_list_lesson.dart';
import 'package:sci_fun/features/home/presentation/page/lesson_page.dart';
import 'package:sci_fun/features/home/presentation/widget/subject_item.dart';
import 'package:sci_fun/features/subject/presentation/cubit/subject_cubit.dart';

class ListSubjects extends StatelessWidget {
  const ListSubjects({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          width: double.infinity,
          child: Column(
            spacing: 8.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Môn học",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
              ),
            ],
          ),
        ),
        BlocBuilder<SubjectCubit, SubjectState>(
          builder: (context, state) {
            if (state is SubjectsLoaded) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: state.subjectList.subjects
                    .map(
                      (subject) => SubjectItem(
                        subjectName: subject.name ?? "",
                        imagePath: subject.avatar ?? "",
                        onTap: () {
                          Navigator.push(
                            context,
                            slidePage(
                              TopicPage<LessonCategoryEntity,
                                  GetLessonCateParam>(
                                title: 'Chủ đề',
                                param: GetLessonCateParam(
                                    subjectId: subject.id ?? 0),
                                usecase: sl<GetLessonCategory>(),
                                itemBuilder: (context, cate) => TopicItem(
                                  title: cate.name ?? "",
                                  onTap: () => Navigator.push(
                                    context,
                                    slidePage(
                                      TopicPage<LessonEntity, int>(
                                        title: 'Danh sách bài học',
                                        param: cate.id ?? 0,
                                        usecase: sl<GetListLesson>(),
                                        itemBuilder: (context, lesson) =>
                                            TopicItemLesson(
                                          title: lesson.name ?? "",
                                          onTap: () => Navigator.push(
                                            context,
                                            slidePage(LessonPage(
                                              lessonId: lesson.id ?? 0,
                                            )),
                                          ),
                                          isCompleted:
                                              lesson.isCompleted ?? false,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                    .toList(),
              );
            }
            return SizedBox();
          },
        ),
      ],
    );
  }
}
