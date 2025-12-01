// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'package:sci_fun/common/widget/basic_appbar.dart';
// import 'package:sci_fun/core/utils/theme/app_color.dart';

// class NewsPage extends StatelessWidget {
//   final int newsId;
//   final String title;
//   final DateTime createdAt;
//   final String content;
//   final String image;
//   const NewsPage(
//       {super.key,
//       required this.newsId,
//       required this.title,
//       required this.createdAt,
//       required this.content,
//       required this.image});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: FocusScope.of(context).unfocus,
//       child: Scaffold(
//         appBar: BasicAppbar(
//           title: Text(
//             "Chi tiết bài viết",
//             style: Theme.of(context).textTheme.titleMedium!.copyWith(
//                   fontSize: 17.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//           ),
//           leading: IconButton(
//             icon: Icon(
//               Icons.arrow_back_ios_new_rounded,
//               color: AppColor.primary600,
//             ),
//             onPressed: () => Navigator.pop(context),
//           ),
//           centerTitle: true,
//         ),
//         body: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: Theme.of(context).textTheme.bodyLarge!.copyWith(
//                       fontSize: 17.sp,
//                       fontWeight: FontWeight.w600,
//                     ),
//               ),
//               SizedBox(height: 6.h),
//               Text(
//                 DateFormat("dd/MM/yyyy").format(createdAt),
//                 style: Theme.of(context).textTheme.bodyLarge!.copyWith(
//                       fontSize: 13.sp,
//                       fontWeight: FontWeight.w600,
//                       color: AppColor.hurricane800.withValues(alpha: 0.6),
//                     ),
//               ),
//               SizedBox(height: 20.h),
//               Center(
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(12.r),
//                   child: Image.network(
//                     image.startsWith("http")
//                         ? image
//                         : "http://3004.mevivu.net/$image",
//                     width: double.infinity,
//                     height: 260.h,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Html(
//                 data: content,
//                 style: {
//                   "body": Style(
//                     fontSize: FontSize(16.sp),
//                     color: Theme.of(context).textTheme.bodyLarge?.color,
//                   ),
//                   "p": Style(
//                     margin: Margins.only(),
//                   ),
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
