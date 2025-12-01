// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sci_fun/common/widget/basic_appbar.dart';
// import 'package:sci_fun/core/di/injection.dart';
// import 'package:sci_fun/core/utils/theme/app_color.dart';
// import 'package:sci_fun/features/analytics/presentation/components/list_statistics_lesson.dart';
// import 'package:sci_fun/features/analytics/presentation/cubits/tab_subjects.dart';
// import 'package:sci_fun/features/home/presentation/cubit/progress_cubit.dart';
// import 'package:sci_fun/features/home/presentation/cubit/select_tab_cubit.dart';
// import 'package:sci_fun/features/subject/presentation/cubit/subject_cubit.dart';

// class StatisticsLesson extends StatefulWidget {
//   const StatisticsLesson({super.key});

//   @override
//   State<StatisticsLesson> createState() => _StatisticsLessonState();
// }

// class _StatisticsLessonState extends State<StatisticsLesson> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (_) => SelectTabCubit()),
//         BlocProvider(
//           create: (context) => sl<SubjectCubit>()..getSubjects(),
//         ),
//       ],
//       child: Scaffold(
//         appBar: BasicAppbar(
//           title: Text(
//             "Bài học",
//             style: Theme.of(context).textTheme.titleMedium!.copyWith(
//                   fontSize: 17.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//           ),
//           centerTitle: true,
//           leading: IconButton(
//             icon: Icon(
//               Icons.arrow_back_ios_rounded,
//               color: AppColor.primary600,
//             ),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//         ),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//               child: TabSubjects(), // Tab chọn subject
//             ),
//             Expanded(
//               child: BlocBuilder<SubjectCubit, SubjectState>(
//                 builder: (context, subjectState) {
//                   print(subjectState);
//                   if (subjectState is SubjectLoading) {
//                     return Center(child: CircularProgressIndicator());
//                   } else if (subjectState is SubjectsLoaded) {
//                     final subjectIds = subjectState.subjectList.subjects
//                         .map((e) => e.id)
//                         .toList();

//                     return BlocBuilder<SelectTabCubit, int>(
//                       builder: (context, selectedIndex) {
//                         return IndexedStack(
//                             index: selectedIndex,
//                             children: List.generate(
//                               subjectIds.length,
//                               (index) => BlocProvider(
//                                 create: (_) => sl<ProgressCubit>()
//                                   ..fetchProgress(subjectIds[index]!),
//                                 child: ListStatisticsLesson(
//                                     subjectId: subjectIds[index]),
//                               ),
//                             ));
//                       },
//                     );
//                   } else if (subjectState is SubjectError) {
//                     return Center(child: Text("Lỗi: ${subjectState.message}"));
//                   }
//                   return SizedBox.shrink();
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
