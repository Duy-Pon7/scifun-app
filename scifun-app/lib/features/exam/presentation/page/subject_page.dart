import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/exam/presentation/page/test_subject_topic.dart';
import 'package:sci_fun/features/exam/presentation/widget/card_subject_item.dart';
import 'package:sci_fun/features/subject/presentation/cubit/subject_cubit.dart';

class SubjectPage extends StatelessWidget {
  const SubjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          "Môn học",
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
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: BlocBuilder<SubjectCubit, SubjectState>(
          builder: (context, state) {
            if (state is SubjectsLoaded) {
              final subjects = state.subjectList.subjects;

              return ListView.separated(
                itemCount: subjects.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  return CardSubjectItem(
                    imagePath: subject.avatar ?? '',
                    title: subject.name ?? '',
                    onTap: () {
                      print("Subject ID: ${subject.id}");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TestSubjectTopic(
                              subjectId: subject.id!, title: subject.name!),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (state is SubjectLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: Text('Không có dữ liệu môn học'));
            }
          },
        ),
      ),
    );
  }
}
