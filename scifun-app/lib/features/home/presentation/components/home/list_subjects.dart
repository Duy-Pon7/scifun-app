import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/features/home/presentation/widget/subject_item.dart';
import 'package:sci_fun/features/subject/presentation/cubit/subject_cubit.dart';
import 'package:sci_fun/features/topic/presentation/pages/topic_page.dart';

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
            print("SubjectState: $state");
            if (state is SubjectLoading) {
              return SizedBox(
                height: 150.h,
                child: const Center(child: CircularProgressIndicator()),
              );
            }

            if (state is SubjectsLoaded) {
              final items = state.subjectList;
              if (items.isEmpty) {
                return SizedBox(
                  height: 150.h,
                  child: const Center(child: Text('Không có môn học')),
                );
              }

              return SizedBox(
                height: 150.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  separatorBuilder: (_, __) => SizedBox(width: 8.w),
                  itemBuilder: (context, index) {
                    final subject = items[index];
                    return SubjectItem(
                      subjectName: subject.name ?? "",
                      imagePath: subject.image ?? "",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TopicPage(
                                subjectId: subject.id ?? '',
                                subjectName: subject.name ?? '',
                              ),
                            ));
                      },
                    );
                  },
                ),
              );
            }

            if (state is SubjectError) {
              return SizedBox(
                height: 150.h,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Lỗi khi tải môn học: ${state.message}'),
                      ElevatedButton(
                        onPressed: () => context
                            .read<SubjectCubit>()
                            .getSubjects(searchQuery: ""),
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SizedBox(
              height: 150.h,
              child: const Center(child: Text('Không có môn học')),
            );
          },
        ),
      ],
    );
  }
}
