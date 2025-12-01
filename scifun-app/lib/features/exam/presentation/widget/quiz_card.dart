// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sci_fun/core/utils/theme/app_color.dart';
// import 'package:sci_fun/features/exam/presentation/page/test_subject_topic_quiz_detail_page.dart';

// class QuizCard extends StatelessWidget {
//   final String title;
//   final String status;
//   final int? score;
//   final int quizzId;
//   final String titleSubject;
//   const QuizCard({
//     super.key,
//     required this.title,
//     required this.status,
//     this.score,
//     required this.quizzId,
//     required this.titleSubject,
//   });

//   Color getStatusColor() {
//     switch (status) {
//       case 'Đã hoàn thành':
//         return const Color(0xff34C759);
//       case 'Đang chấm':
//         return const Color(0xff007AFF);
//       default:
//         return const Color(0xffFFCC00);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => TestSubjectTopicQuizDetailPage(
//                 quizzId: quizzId, titleSubject: titleSubject),
//           ),
//         );
//       },
//       child: Container(
//         padding: EdgeInsets.all(12.sp),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12.r),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 4,
//               offset: Offset(0, 2),
//             )
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Hàng 1: Trạng thái và điểm
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
//                   decoration: BoxDecoration(
//                     color: getStatusColor(),
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                   child: Text(
//                     status,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 11.sp,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ),
//                 if (score != null && score != 0)
//                   Container(
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
//                     decoration: BoxDecoration(
//                       color: AppColor.primary200,
//                       borderRadius: BorderRadius.circular(12.r),
//                     ),
//                     child: Text(
//                       '$score',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.w400,
//                         fontSize: 11.sp,
//                       ),
//                     ),
//                   ),
//               ],
//             ),

//             SizedBox(height: 12.h),

//             // Hàng 2: Tên đề
//             Text(
//               title,
//               maxLines: 1,
//               style: TextStyle(
//                 fontSize: 17.sp,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),

//             SizedBox(height: 12.h),

//             // Hàng 3: Số câu và thời gian
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.help,
//                         size: 14.sp,
//                         color: AppColor.hurricane800.withValues(alpha: 0.3)),
//                     SizedBox(width: 6.w),
//                     Text("30 câu",
//                         style: TextStyle(
//                             fontSize: 12.sp,
//                             color:
//                                 AppColor.hurricane800.withValues(alpha: 0.6))),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Icon(Icons.access_time,
//                         size: 14.sp,
//                         color: AppColor.hurricane800.withValues(alpha: 0.3)),
//                     SizedBox(width: 6.w),
//                     Text("90 phút",
//                         style: TextStyle(
//                             fontSize: 12.sp,
//                             color:
//                                 AppColor.hurricane800.withValues(alpha: 0.6))),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
