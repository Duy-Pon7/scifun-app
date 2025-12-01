// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sci_fun/common/widget/basic_appbar.dart';
// import 'package:sci_fun/core/utils/theme/app_color.dart';
// import 'package:sci_fun/features/home/presentation/widget/question_grid.dart';

// class HomeworkAllQues extends StatelessWidget {
//   final int totalQuestions;
//   final int currentIndex;
//   final List<int> answeredQuestionIndexes;
//   final Function(int) onQuestionTap;

//   const HomeworkAllQues({
//     super.key,
//     required this.totalQuestions,
//     required this.currentIndex,
//     required this.answeredQuestionIndexes,
//     required this.onQuestionTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: BasicAppbar(
//         title: Text(
//           "Tất cả câu hỏi",
//           style: Theme.of(context).textTheme.titleMedium!.copyWith(
//                 fontSize: 17.sp,
//                 fontWeight: FontWeight.w600,
//               ),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back_ios_rounded,
//             color: AppColor.primary600,
//           ),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: QuestionGrid(
//           totalQuestions: totalQuestions,
//           currentIndex: currentIndex,
//           answeredQuestionIndexes: answeredQuestionIndexes,
//           onQuestionTap: onQuestionTap,
//         ),
//       ),
//     );
//   }
// }
