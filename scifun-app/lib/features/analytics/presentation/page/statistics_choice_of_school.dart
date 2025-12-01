import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/analytics/presentation/components/list_statistics_school_one.dart';
import 'package:sci_fun/features/analytics/presentation/components/list_statistics_school_two.dart';
import 'package:sci_fun/features/analytics/presentation/cubits/school_paginator_cubit.dart';
import 'package:sci_fun/features/analytics/presentation/cubits/tab_choice_of_school.dart';
import 'package:sci_fun/features/home/presentation/cubit/select_tab_cubit.dart';

class StatisticsChoiceOfSchool extends StatefulWidget {
  const StatisticsChoiceOfSchool({super.key});

  @override
  State<StatisticsChoiceOfSchool> createState() =>
      _StatisticsChoiceOfSchoolState();
}

class _StatisticsChoiceOfSchoolState extends State<StatisticsChoiceOfSchool> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectTabCubit(),
      child: Scaffold(
          appBar: BasicAppbar(
            title: "Chi tiết lịch sử gói cước",
            showTitle: true,
            showBack: true,
          ),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: TabChoiceOfSchool(),
                ),
                Expanded(
                  child: BlocProvider(
                    create: (context) => sl<SchoolPaginatorCubit>(),
                    child: BlocBuilder<SelectTabCubit, int>(
                      builder: (context, selectedIndex) {
                        return IndexedStack(
                          index: selectedIndex,
                          children: [
                            ListStatisticsSchoolOne(),
                            ListStatisticsSchoolTwo(),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ])),
    );
  }
}
