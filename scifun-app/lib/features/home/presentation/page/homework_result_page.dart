// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sci_fun/common/widget/basic_appbar.dart';
// import 'package:sci_fun/core/utils/theme/app_color.dart';
// import 'package:sci_fun/features/home/presentation/components/lesson/list_homework_all_page.dart';
// import 'package:sci_fun/features/home/presentation/components/lesson/list_homework_right_page.dart';
// import 'package:sci_fun/features/home/presentation/components/lesson/list_homework_wrong_page.dart';
// import 'package:sci_fun/features/home/presentation/cubit/quizz_cubit.dart';
// import 'package:sci_fun/features/home/presentation/cubit/select_tab_cubit.dart';
// import 'package:sci_fun/features/home/presentation/cubit/tab_homework_cubit.dart';

// class HomeworkResultPage extends StatefulWidget {
//   const HomeworkResultPage({super.key, this.quizzId});
//   final int? quizzId;

//   @override
//   State<HomeworkResultPage> createState() => _HomeworkResultPageState();
// }

// class _HomeworkResultPageState extends State<HomeworkResultPage> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => SelectTabCubit(),
//       child: Scaffold(
//           appBar: BasicAppbar(
//             title: Text(
//               "Chi tiết bài làm",
//               style: Theme.of(context).textTheme.titleMedium!.copyWith(
//                     fontSize: 17.sp,
//                     fontWeight: FontWeight.w600,
//                   ),
//             ),
//             centerTitle: true,
//             leading: IconButton(
//               icon: Icon(
//                 Icons.arrow_back_ios_rounded,
//                 color: AppColor.primary600,
//               ),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//           ),
//           body: BlocBuilder<QuizzCubit, QuizzState>(
//             builder: (context, state) {
//               print("State quizzhistory $state");
//               if (state is QuizzLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (state is QuizzError) {
//                 return Center(child: Text("Lỗi: ${state.message}"));
//               } else if (state is QuizzDetailLoaded) {
//                 final questions = state.quizzEntity.questions ?? [];

//                 // final currentQuestion = questions[state.currentIndex];
//                 // final selectedIds =
//                 //     state.selectedAnswers[currentQuestion.id] ?? [];
//                 // final isMultipleChoice =
//                 //     currentQuestion.answerMode == 'multiple';

//                 final resultAnswers =
//                     state.quizzEntity.quizResult?.answers ?? [];
//                 return Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 16.w, vertical: 12.h),
//                         child: TabHomeworkCubit(),
//                       ),
//                       Expanded(
//                         child: BlocBuilder<SelectTabCubit, int>(
//                           builder: (context, selectedIndex) {
//                             return IndexedStack(
//                               index: selectedIndex,
//                               children: [
//                                 ListHomeworkAllPage(
//                                   resultAnswers: resultAnswers,
//                                   questions: questions,
//                                 ),
//                                 ListHomeworkRightPage(
//                                   resultAnswers: resultAnswers,
//                                   questions: questions,
//                                 ),
//                                 ListHomeworkWrongPage(
//                                   resultAnswers: resultAnswers,
//                                   questions: questions,
//                                 ),
//                               ],
//                             );
//                           },
//                         ),
//                       ),
//                     ]);
//               }
//               return SizedBox();
//             },
//           )),
//     );
//   }
// }
