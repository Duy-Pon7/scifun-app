import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/home/presentation/cubit/select_tab_cubit.dart';

class TabSubjects extends StatefulWidget {
  const TabSubjects({super.key});

  @override
  State<TabSubjects> createState() => _TabSubjectsState();
}

class _TabSubjectsState extends State<TabSubjects> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectTabCubit, int>(
      builder: (context, selectedIndex) {
        return Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppColor.backgroundTab,
            borderRadius: BorderRadius.circular(9.r),
          ),
          child: Row(
            children: [
              _buildTab(0, 'Toán', selectedIndex),
              _buildTab(1, 'Tiếng Anh', selectedIndex),
              _buildTab(2, 'Ngữ Văn', selectedIndex),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTab(
    int index,
    String text,
    int selectedIndex,
  ) {
    bool isSelected = index == selectedIndex;

    return Expanded(
      child: GestureDetector(
        onTap: () => context.read<SelectTabCubit>().selectTab(index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColor.primary600 : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: isSelected ? Colors.white : null,
                    fontWeight: isSelected ? FontWeight.w600 : null,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
