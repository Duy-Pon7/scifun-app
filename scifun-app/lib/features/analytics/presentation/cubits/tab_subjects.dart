import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/analytics/presentation/cubits/selected_subject_cubit.dart';



class TabSubjects extends StatelessWidget {
  final List subjects; // đổi thành List<Subject> nếu em có model

  const TabSubjects({
    super.key,
    required this.subjects,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedSubjectCubit, String?>(
      builder: (context, selectedId) {
        return Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppColor.backgroundTab,
            borderRadius: BorderRadius.circular(9.r),
          ),
          child: Row(
            children: subjects.map((subject) {
              final String id = subject.id;
              final String name = subject.name; // đúng field API
              final bool isSelected = id == selectedId;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    context.read<SelectedSubjectCubit>().selectSubject(id);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? AppColor.primary600 : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Text(
                        name,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: isSelected ? Colors.white : null,
                              fontWeight:
                                  isSelected ? FontWeight.w600 : null,
                            ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

