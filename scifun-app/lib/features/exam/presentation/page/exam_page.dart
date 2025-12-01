// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sci_fun/common/widget/basic_appbar.dart';
// import 'package:sci_fun/core/di/injection.dart';
// import 'package:sci_fun/core/utils/assets/app_image.dart';
// import 'package:sci_fun/features/exam/presentation/page/examset_page.dart';
// import 'package:sci_fun/features/exam/presentation/page/subject_page.dart';
// import 'package:sci_fun/features/exam/presentation/widget/type_exam_item.dart';
// import 'package:sci_fun/features/subject/presentation/cubit/subject_cubit.dart';

// class ExamPage extends StatefulWidget {
//   const ExamPage({super.key});

//   @override
//   State<ExamPage> createState() => _ExamPageState();
// }

// class _ExamPageState extends State<ExamPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: BasicAppbar(
//         title: Text(
//           "Kiểm tra",
//           style: Theme.of(context).textTheme.titleMedium!.copyWith(
//                 fontSize: 17.sp,
//                 fontWeight: FontWeight.w600,
//               ),
//         ),
//         centerTitle: true,
//       ),
//       body: Container(
//         padding: EdgeInsets.all(40.h),
//         margin: EdgeInsets.all(10.h),
//         width: double.infinity,
//         child: Column(
//           spacing: 40.h,
//           children: [
//             TypeExamItem(
//               imagePath: AppImage.knowledgeLearn,
//               title: "Kiến thức đã học",
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => BlocProvider(
//                       create: (_) => sl<SubjectCubit>()..getSubjects(),
//                       child: SubjectPage(),
//                     ),
//                   ),
//                 );
//               },
//             ),
//             TypeExamItem(
//               imagePath: AppImage.examineTest,
//               title: "Thi thử lớp 10",
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ExamsetPage(),
//                     ));
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
