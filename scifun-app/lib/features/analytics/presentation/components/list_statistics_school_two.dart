import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/analytics/domain/entities/school_data_entity.dart';
import 'package:sci_fun/features/analytics/presentation/cubits/school_paginator_cubit.dart';
import 'package:sci_fun/features/auth/presentation/bloc/auth_bloc.dart';

class ListStatisticsSchoolTwo extends StatefulWidget {
  const ListStatisticsSchoolTwo({super.key});

  @override
  State<ListStatisticsSchoolTwo> createState() =>
      _ListStatisticsSchoolTwoState();
}

class _ListStatisticsSchoolTwoState extends State<ListStatisticsSchoolTwo> {
  @override
  void initState() {
    super.initState();
    // Gọi API ở initState sau khi widget đã mount
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthUserSuccess) {
        final provinceId = 0;
        context.read<SchoolPaginatorCubit>().fetchSchoolData(
              DateTime.now().year,
              provinceId,
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthUserSuccess) {
          final provinceName = "state.user!.province?.name";

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              spacing: 32.h,
              children: [
                SizedBox(height: 32.h),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 22.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                    children: [
                      const TextSpan(text: 'Bảng điểm chuẩn '),
                      TextSpan(
                        text: provinceName ?? "",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: 22.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: DateTime.now().year.toString(),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: 22.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                ),

                // Hiển thị theo state của SchoolPaginatorCubit
                Expanded(
                  child: BlocBuilder<SchoolPaginatorCubit, SchoolDataState>(
                    builder: (context, schoolState) {
                      if (schoolState is SchoolDataLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (schoolState is SchoolDataLoaded) {
                        return _buildSchoolTable(schoolState.schools);
                      } else if (schoolState is SchoolDataError) {
                        return Center(child: Text(schoolState.message));
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          );
        }

        if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return const Center(child: Text('Không thể tải dữ liệu'));
      },
    );
  }

  Widget _buildSchoolTable(List<SchoolDataEntity> schools) {
    return Table(
      border: TableBorder.all(
        color: AppColor.border,
        width: 1,
      ),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          children: [
            _tableCell("Mã trường", isHeader: true),
            _tableCell("Tên trường", isHeader: true),
            _tableCell("NV1", isHeader: true),
            _tableCell("NV2", isHeader: true),
            _tableCell("NV3", isHeader: true),
          ],
        ),
        ...schools.map((school) => TableRow(
              children: [
                _tableCell(school.schoolCode ?? ''),
                _tableCell(school.schoolName ?? ''),
                _tableCell(school.firstChoice?.toString() ?? ''),
                _tableCell(school.secondChoice?.toString() ?? ''),
                _tableCell(school.thirdChoice?.toString() ?? ''),
              ],
            )),
      ],
    );
  }

  Widget _tableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.w600 : FontWeight.w400,
          fontSize: isHeader ? 14.sp : 12.sp,
        ),
      ),
    );
  }
}
