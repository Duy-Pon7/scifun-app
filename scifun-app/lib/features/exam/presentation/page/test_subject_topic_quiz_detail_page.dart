// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sci_fun/common/helper/show_alert_dialog.dart';
// import 'package:sci_fun/common/helper/transition_page.dart';
// import 'package:sci_fun/common/widget/basic_appbar.dart';
// import 'package:sci_fun/core/di/injection.dart';
// import 'package:sci_fun/core/utils/theme/app_color.dart';
// import 'package:sci_fun/core/utils/usecase.dart';
// import 'package:sci_fun/features/exam/presentation/page/history_page.dart';
// import 'package:sci_fun/features/home/domain/usecase/get_quizz_result.dart';
// import 'package:sci_fun/features/home/presentation/cubit/quizz_result_paginator_cubit.dart';
// import 'package:sci_fun/features/home/presentation/page/test_page.dart';

// class TestSubjectTopicQuizDetailPage extends StatelessWidget {
//   final int quizzId;
//   final String titleSubject;
//   const TestSubjectTopicQuizDetailPage(
//       {super.key, required this.quizzId, required this.titleSubject});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
// // ...existing code...
//       appBar: BasicAppbar(
//         title: Text(
//           "Chi tiết đề bài",
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
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.history,
//               color: AppColor.primary600,
//             ),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => BlocProvider(
//                     create: (_) => QuizzResultPaginatorCubit(
//                       usecase: sl<GetQuizzResult>(),
//                       quizzId: quizzId,
//                     )..paginateData(
//                         param: PaginationParamId<void>(
//                           page: 1, // hoặc _currentPage nếu bạn muốn điều khiển
//                           id: quizzId,
//                         ),
//                       ),
//                     child: HistoryPage(quizzId: quizzId),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
// // ...existing code...
//       body: Padding(
//         padding: EdgeInsets.all(16.w),
//         child: Column(
//           children: [
//             // Khung chứa tiêu đề, số câu và thời gian
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.symmetric(vertical: 16.h),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16.r),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 4,
//                     offset: Offset(0, 0),
//                   ),
//                 ],
//               ),
//               child: Padding(
//                 padding: EdgeInsets.all(16.w),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       titleSubject,
//                       style: TextStyle(
//                         fontSize: 28.sp,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     SizedBox(height: 16.h),
//                     Row(
//                       children: [
//                         Icon(Icons.help,
//                             color: AppColor.primary500, size: 60.sp),
//                         SizedBox(width: 8.w),
//                         Text(
//                           "30 câu",
//                           style: TextStyle(
//                             fontSize: 22.sp,
//                             color: AppColor.primary500,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 12.h),
//                     Row(
//                       children: [
//                         Icon(Icons.access_time,
//                             color: AppColor.primary500, size: 60.sp),
//                         SizedBox(width: 8.w),
//                         Text(
//                           "90 phút",
//                           style: TextStyle(
//                             fontSize: 22.sp,
//                             color: AppColor.primary500,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 24.h),

//             // Khung chứa nội dung hướng dẫn
//             Expanded(
//               child: Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.all(16.w),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16.r),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 4,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Trước khi làm bài",
//                         style: TextStyle(
//                           fontSize: 20.sp,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       SizedBox(height: 12.h),
//                       _buildBulletPoint(
//                           "Đối với đề thi trắc nghiệm, chọn tất cả các đáp án đúng. Sau khi kết thúc bài kiểm tra, bạn có thể xem điểm, đáp án và làm lại (nếu cần)."),
//                       _buildBulletPoint(
//                           "Đối với đề thi tự luận, sau khi nộp bài cần chờ thời gian chấm. Bạn có thể vào lại bài thi sau để kiểm tra điểm."),
//                       _buildBulletPoint(
//                           "Nếu thoát ra trong lúc làm bài, bài thi sẽ không lưu lại."),
//                       _buildBulletPoint(
//                           "Đối với đề thi trắc nghiệm, chọn tất cả các đáp án đúng. Sau khi kết thúc bài kiểm tra, bạn có thể xem điểm, đáp án và làm lại (nếu cần)."),
//                       _buildBulletPoint(
//                           "Đối với đề thi tự luận, sau khi nộp bài cần chờ thời gian chấm. Bạn có thể vào lại bài thi sau để kiểm tra điểm."),
//                       _buildBulletPoint(
//                           "Nếu thoát ra trong lúc làm bài, bài thi sẽ không lưu lại."),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             // Nút bắt đầu làm bài
//             SizedBox(height: 16.h),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   showAlertDialog(
//                     context,
//                     () async {
//                       Navigator.push(
//                         context,
//                         slidePage(
//                           TestPage(quizzId: quizzId), // hoặc quizz.id ?? 0
//                         ),
//                       );
//                     },
//                     () {}, // Không làm gì khi cancel
//                     "Bắt đầu làm bài",
//                     "Bạn có chắc chắn muốn bắt đầu làm bài không? Thời gian sẽ bắt đầu tính ngay khi bạn xác nhận.",
//                     "Bắt đầu",
//                     "Hủy",
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red,
//                   padding: EdgeInsets.symmetric(vertical: 14.h),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                 ),
//                 child: Text(
//                   "Bắt đầu làm bài",
//                   style: TextStyle(
//                     fontSize: 17.sp,
//                     color: Colors.white,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBulletPoint(String text) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 10.h),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("• ", style: TextStyle(fontSize: 16.sp)),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(fontSize: 16.sp),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
