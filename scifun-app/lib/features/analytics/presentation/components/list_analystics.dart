// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sci_fun/core/di/injection.dart';
// import 'package:sci_fun/core/utils/assets/app_image.dart';
// import 'package:sci_fun/features/analytics/presentation/page/score_average_of_subjects.dart';
// import 'package:sci_fun/features/analytics/presentation/page/statistics_choice_of_school.dart';
// import 'package:sci_fun/features/analytics/presentation/page/statistics_lesson.dart';
// import 'package:sci_fun/features/analytics/presentation/widget/analytic_item.dart';
// import 'package:sci_fun/features/exam/presentation/cubit/examset_paginator_cubit.dart';

// class ListAnalystics extends StatelessWidget {
//   const ListAnalystics({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       spacing: 16.h,
//       children: [
//         AnalyticItem(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => StatisticsLesson()),
//             );
//           },
//           image: AppImage.lesson,
//           title: "Bài học",
//         ),
//         AnalyticItem(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => BlocProvider(
//                         create: (context) => sl<ExamsetPaginatorCubit>(),
//                         child: ScoreAverageOfSubjects(),
//                       )),
//             );
//           },
//           image: AppImage.testScore,
//           title: "Điểm thi thử lớp 10",
//         ),
//         AnalyticItem(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => StatisticsChoiceOfSchool()),
//             );
//           },
//           image: AppImage.knowledgeLearned,
//           title: "Tư vấn chọn trường",
//         ),
//       ],
//     );
//   }
// }
