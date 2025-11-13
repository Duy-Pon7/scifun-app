import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/analytics/presentation/cubits/school_cubit.dart';

class ListStatisticsSchoolOne extends StatelessWidget {
  const ListStatisticsSchoolOne({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SchoolCubit>()..fetchSchools(),
      child: BlocBuilder<SchoolCubit, SchoolState>(
        builder: (context, state) {
          print(state);
          if (state is SchoolLoaded) {
            print(state.school.suggestedSchools.toString());
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 32.h,
                    horizontal: 16.w,
                  ),
                  child: Column(
                    spacing: 32.h,
                    children: [
                      Column(
                        spacing: 12.h,
                        children: [
                          Text(
                            "Điểm thi thử gần nhất",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontSize: 22.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          Text(
                            state.school.userScores?.totalScore?.toString() ??
                                "N/A",
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(
                                  fontSize: 68.sp,
                                  color: AppColor.primary500,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: AppColor.primary50, // nền hồng nhạt
                              borderRadius:
                                  BorderRadius.circular(6.r), // bo góc
                            ),
                            child: Text(
                              "Tổng điểm = (Toán * 2) + (Ngữ Văn * 2) + Tiếng Anh",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontSize: 13.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 24.h),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              width: 0.3,
                              color: Colors.black.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              spacing: 8.h,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  state.school.userScores?.mathematics
                                          ?.latestScore
                                          ?.toString() ??
                                      'N/A',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontSize: 28.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                Text(
                                  "Môn Toán",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 40.h,
                              child: VerticalDivider(
                                thickness: 0.3,
                                color: Colors.black.withValues(alpha: 0.3),
                                width: 0.3,
                              ),
                            ),
                            Column(
                              spacing: 8.h,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  state.school.userScores?.foreignLanguage
                                          ?.latestScore
                                          ?.toString() ??
                                      'N/A',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontSize: 28.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                Text(
                                  "Tiếng Anh",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 40.h,
                              child: VerticalDivider(
                                thickness: 0.3,
                                color: Colors.black.withValues(alpha: 0.3),
                                width: 0.3,
                              ),
                            ),
                            Column(
                              spacing: 8.h,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  // timeTaken ?? "00’00”",
                                  state.school.userScores?.literature
                                          ?.latestScore
                                          ?.toString() ??
                                      'N/A',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontSize: 28.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                Text(
                                  "Môn Văn",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Danh sách các trường bạn phù hợp",
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ),
                      DefaultTabController(
                        length: 3,
                        child: Column(
                          children: [
                            TabBar(
                              labelColor: Colors.red,
                              unselectedLabelColor: Colors.black,
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelStyle: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w700, // chọn
                              ),
                              unselectedLabelStyle: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w400, // không chọn
                              ),
                              tabs: const [
                                Tab(text: "NV1"),
                                Tab(text: "NV2"),
                                Tab(text: "NV3"),
                              ],
                            ),
                            SizedBox(
                              height: 200.h, // chỉnh chiều cao bảng
                              child: TabBarView(
                                children: [
                                  buildTable(state.school.suggestedSchools,
                                      "first_choice"),
                                  buildTable(state.school.suggestedSchools,
                                      "second_choice"),
                                  buildTable(state.school.suggestedSchools,
                                      "third_choice"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return SizedBox();
        },
      ),
    );
  }

  Widget buildTable(List<dynamic> suggestedSchools, String choiceKey) {
    final rows = suggestedSchools.expand((schoolData) {
      final school = schoolData.school;
      final recs = schoolData.recommendations
          .where((rec) => rec.choice == choiceKey)
          .toList();

      return recs.map((rec) => {
            "code": school.code ?? '',
            "name": school.name ?? '',
            "score": "${rec.requiredScore ?? ''} điểm"
          });
    }).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Table(
        border: TableBorder.all(
          color: AppColor.border,
          width: 1,
        ),
        columnWidths: const {
          0: FlexColumnWidth(1), // Mã trường
          1: FlexColumnWidth(1), // Tên trường
          2: FlexColumnWidth(1), // Điểm NV
        },
        children: [
          // Hàng tiêu đề
          TableRow(
            children: [
              tableCell("Mã trường", isHeader: true),
              tableCell("Tên trường", isHeader: true),
              tableCell("Điểm NV", isHeader: true),
            ],
          ),
          // Các hàng dữ liệu
          for (var row in rows)
            TableRow(
              children: [
                tableCell(row["code"].toString()),
                tableCell(row["name"].toString()),
                tableCell(row["score"].toString()),
              ],
            ),
        ],
      ),
    );
  }

  Widget tableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 12.h,
        horizontal: 16.w,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.w400 : FontWeight.w400,
          fontSize: isHeader ? 16.sp : 11.sp,
        ),
      ),
    );
  }
}
